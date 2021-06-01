import 'dart:typed_data';

import 'package:Velmie/common/repository/user_repository.dart';
import 'package:Velmie/common/secure_repository.dart';
import 'package:Velmie/common/storage_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_utils/resource.dart';

import '../../../../../app.dart';
import '../../../../../common/session/session_repository.dart';
import '../../../../../resources/strings/app_strings.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._sessionRepository, this._userRepository)
      : super(
          ProfileState(
            firstName: _sessionRepository.userData.value?.firstName ?? '',
            lastName: _sessionRepository.userData.value?.lastName ?? '',
            nickName: _sessionRepository.userData.value?.nickname ?? '',
          ),
        ) {
    _sessionRepository.userData.listen((event) {
      final firstNames = event.firstName.split(' ').toList();
      final lastNames = event.lastName.split(' ').toList();

      update(
        firstName: firstNames.first ?? '',
        secondName: firstNames.length > 1 ? firstNames[1] : '',
        lastName: lastNames.first ?? '',
        mothersName: lastNames.length > 1 ? lastNames[1] : '',
        nickName: event.nickname ?? '',
        avatarId: event.profileImageId,
      );
    });
  }

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  void update({
    String firstName,
    String lastName,
    String nickName,
    String secondName,
    String mothersName,
    int avatarId,
  }) async {
    final Uint8List avatar = await _userRepository.downloadAvatar(avatarId);
    emit(ProfileUpdatedState(
      firstName: firstName,
      lastName: lastName,
      nickName: nickName,
      avatar: avatar,
      secondName: secondName,
      mothersName: mothersName,
    ));
  }

  void updateNickName({String nickName}) {
    if (nickName.length < 3) {
      emit(ProfileUpdatingErrorState(
        firstName: _sessionRepository.userData.value.firstName,
        lastName: _sessionRepository.userData.value.lastName,
        nickName: nickName,
        avatar: state.avatar,
        error: ErrorStrings.SHOULD_BE_MINIMUM_THREE_CHARACTERS,
        secondName: state.secondName,
        mothersName: state.mothersName,
      ));
      return;
    }
    updateProfile(nickName: nickName);
  }

  void updateProfile({
    String firstName,
    String lastName,
    String nickName,
    String secondName,
    String mothersName,
  }) async {
    await for (final event in _userRepository.updateUserData(
      firstName: firstName == null && secondName == null ? null : '$firstName $secondName'.trim(),
      lastName: lastName == null && mothersName == null ? null : '$lastName $mothersName'.trim(),
      nickName: nickName,
    )) {
      if (event.status == Status.success) {
        logger.d("profile was updated");
        emit(ProfileUpdatedState(
          firstName: firstName ?? state.firstName ?? '',
          lastName: lastName ?? state.lastName ?? '',
          nickName: nickName ?? state.nickName ?? '',
          secondName: secondName ?? state.secondName ?? '',
          mothersName: mothersName ?? state.mothersName ?? '',
          avatar: state.avatar,
        ));
        return;
      } else if (event.status == Status.loading) {
        emit(ProfileLoadingState());
      } else {
        return;
      }
    }
  }

  void updateName({
    String firstName,
    String lastName,
    String secondName,
    String mothersName,
  }) {
    if (firstName.isEmpty) {
      emit(ProfileUpdatingErrorState(
        firstName: firstName,
        lastName: lastName,
        secondName: secondName ?? state.secondName,
        mothersName: mothersName ?? state.mothersName,
        nickName: _sessionRepository.userData.value.nickname,
        avatar: state.avatar,
        error: ErrorStrings.FIRST_NAME_SHOULD_NOT_BE_EMPTY,
      ));
      return;
    }
    if (lastName.isEmpty) {
      emit(ProfileUpdatingErrorState(
          firstName: firstName,
          lastName: lastName,
          secondName: secondName ?? state.secondName,
          mothersName: mothersName ?? state.mothersName,
          nickName: _sessionRepository.userData.value.nickname,
          avatar: state.avatar,
          error: ErrorStrings.SECOND_NAME_SHOULD_NOT_BE_EMPTY));
      return;
    }
    updateProfile(
      firstName: firstName,
      lastName: lastName,
      secondName: secondName,
      mothersName: mothersName,
    );
  }

  void updateAvatar({String filePath}) async {
    await for (final event in _userRepository.uploadAvatar(filePath)) {
      if (event.status == Status.success) {
        logger.d("avatar was uploaded");
        return;
      } else if (event.status == Status.loading) {
        emit(ProfileLoadingState());
      } else {
        updateProfile(
          firstName: _sessionRepository.userData.value.firstName,
          lastName: _sessionRepository.userData.value.lastName,
          nickName: _sessionRepository.userData.value.nickname,
          secondName: state.secondName,
          mothersName: state.mothersName,
        );
        return;
      }
    }
  }

   void updateVoucher({String filePath}) async {
    await for (final event in _userRepository.uploadVaucher(filePath)) {
      if (event.status == Status.success) {
        logger.d("avatar was uploaded");
        return;
      } else if (event.status == Status.loading) {
        emit(ProfileLoadingState());
      } 
    }
  }


  //  void updateCashOut({String filePath}) async {
  //   await for (final event in _userRepository.uploadCashOut(filePath)) {
  //     if (event.status == Status.success) {
  //       logger.d("avatar was uploaded");
  //       return;
  //     } else if (event.status == Status.loading) {
  //       emit(ProfileLoadingState());
  //     } 
  //   }
  // }

  void changeLanguage(String code) {
    SecureRepository().addToStorage(StorageConstants.languageCode, code);
  }
}
