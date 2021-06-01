import 'dart:typed_data';

import 'package:Velmie/app.dart';
import 'package:Velmie/common/bloc/loader_bloc.dart';
import 'package:Velmie/common/repository/user_repository.dart';
import 'package:Velmie/common/secure_repository.dart';
import 'package:Velmie/common/session/cubit/session_cubit.dart';
import 'package:Velmie/common/storage_constants.dart';
import 'package:Velmie/flows/kyc_flow/models/requirement_request.dart';
import 'package:Velmie/flows/kyc_flow/models/tiers_result.dart';
import 'package:Velmie/flows/kyc_flow/repository/kyc_repository.dart';
import 'package:Velmie/flows/sign_up_flow/screens/sign_up_screen/entities/sign_up_errors.dart';
import 'package:Velmie/flows/sign_up_flow/screens/sign_up_screen/models/sign_up_models.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:network_utils/resource.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(
    this._userRepository,
    this._loaderBloc,
    this._sessionCubit,
    this._kycRepository,
  ) : super(const SignUpState());

  final UserRepository _userRepository;
  final LoaderBloc _loaderBloc;
  final SessionCubit _sessionCubit;
  final KycRepository _kycRepository;

  void stepChanged(SignUpStep step) {
    emit(state.copyWith(step: step));
  }

  Future<int> _getRequirementIdByElementIndex(ElementIndex index) async {
    int requirementId;

    await for (final resource in _kycRepository.getTiers()) {
      if (resource.status == Status.success) {
        final tier = resource.data.last;
        requirementId = tier.getRequirementIdByElementIndex(index);
        break;
      } else if (resource.status == Status.error) {
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        return null;
      }
    }

    return requirementId;
  }

  void loadSignatureLink({String language = 'en'}) async {
    await for (final resource in _kycRepository.getSignatureLink(language: language)) {
      if (resource.status == Status.success) {
        emit(state.copyWith(signatureLink: resource.data));
        break;
      } else if (resource.status == Status.error) {
        emit(state.copyWith(signatureError: resource.errors?.first?.code ?? ''));
        return;
      }
    }
  }

  void sendVoucher() async{
    _loaderBloc.add(LoaderEvent.buttonLoadEvent);

      await for (final resource in _userRepository.uploadVaucher(
        state.setVoucherPath
    )) {
      if (resource.status == Status.success) {
        print('Exitooooooooooooooo');
        emit(state.copyWith(step: SignUpStep.signature));
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        break;
      } else if (resource.status == Status.error) {
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        emit(state.copyWith(
            proofOfResidenceErrorCode: resource.errors?.first?.code ?? ErrorStrings.SOMETHING_WENT_WRONG));
        break;
      }
    }
  }


  void sendCashOut({String bankName, String accountNumber, String type, String referencesAdditional, String numberRef}) async{
  //   "userUid":"56c4bc5a-2d55-45a0-9c04-2111ec29cdb9",				
	// "bankName":"Azteca",
	// "accountNumber":"11223334455667788",
	// "type":"CLABE",
	// "referencesAdditional":"Nothings Else Mathers"
    _loaderBloc.add(LoaderEvent.buttonLoadEvent);

      await for (final resource in _userRepository.uploadCashOut(
        bankName:bankName,
        accountNumber:accountNumber,
        type:type,
        referencesAdditional:referencesAdditional,
        numberRef:numberRef
      )
      
      ) {
      if (resource.status == Status.success) {
        print('Exitooooooooooooooo');
        emit(state.copyWith(step: SignUpStep.signature));
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        break;
      } else if (resource.status == Status.error) {
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        emit(state.copyWith(
            proofOfResidenceErrorCode: resource.errors?.first?.code ?? ErrorStrings.SOMETHING_WENT_WRONG));
        break;
      }
    }
  }


  void sendProofOfResidence() async {
    _loaderBloc.add(LoaderEvent.buttonLoadEvent);
    final elementIndex =
        state?.isCorporate == true ? ElementIndex.proofPermanentAddressCompany : ElementIndex.proofPermanentAddress;
    final requirementId = await _getRequirementIdByElementIndex(elementIndex);

    await for (final resource in _kycRepository.updateRequirement(
      requirement: RequirementRequest(
        values: [
          ElementValue(
            index: elementIndex,
            value: state.proofOfResidencePath,
          ),
        ],
      ),
      id: requirementId,
    )) {
      if (resource.status == Status.success) {
        emit(state.copyWith(step: SignUpStep.signature));
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        break;
      } else if (resource.status == Status.error) {
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        emit(state.copyWith(
            proofOfResidenceErrorCode: resource.errors?.first?.code ?? ErrorStrings.SOMETHING_WENT_WRONG));
        break;
      }
    }
  }

  void sendIdDocuments() async {
    _loaderBloc.add(LoaderEvent.buttonLoadEvent);
    final requirementId = await _getRequirementIdByElementIndex(ElementIndex.idFront);

    await for (final resource in _kycRepository.updateRequirement(
      requirement: RequirementRequest(
        values: [
          ElementValue(
            index: ElementIndex.idFront,
            value: state.idFrontPath,
          ),
          if (state.idBackPath != null)
            ElementValue(
              index: ElementIndex.idBack,
              value: state.idBackPath,
            ),
          ElementValue(
            index: ElementIndex.selfiePhoto,
            value: state.selfiePath,
          ),
        ],
      ),
      id: requirementId,
    )) {

       print('************//////////////// RESPONSE UPDATE IMAGE *******/////////// ');
  print(resource.status);
      if (resource.status == Status.success) {
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        emit(state.copyWith(step: SignUpStep.residence));
        return;
      } else if (resource.status == Status.error) {
        _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
        emit(state.copyWith(idDocumentsErrorCode: resource.errors?.first?.code ?? ErrorStrings.SOMETHING_WENT_WRONG));
        return;
      }
    }
  }

  void languageChanged(String value) {
    emit(state.copyWith(languageCode: value));
    SecureRepository().addToStorage(StorageConstants.languageCode, value);
  }

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.password,
        state.confirmPassword,
        state.phone,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.email,
        password,
        state.confirmPassword,
        state.phone,
      ]),
    ));
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = PasswordConfirmInput.dirty(value);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate([
        state.email,
        state.password,
        confirmPassword,
        state.phone,
      ]),
    ));
  }

  void dialCodeChanged(String value) {
    emit(state.copyWith(dialCode: value));
  }

  void phoneChanged(String value) {
    final phone = PhoneInput.dirty(value);
    emit(state.copyWith(
      phone: phone,
      status: Formz.validate([
        state.email,
        state.password,
        state.confirmPassword,
        phone,
      ]),
    ));
  }

  void termsAndConditionsAcceptanceChanged(bool value) {
    emit(state.copyWith(
      termsAndConditionsAccepted: value,
      status: Formz.validate([
        state.email,
        state.password,
        state.confirmPassword,
        state.phone,
      ]),
    ));
  }

  void accountTypeChanged(bool isCorporate) {
    emit(state.copyWith(isCorporate: isCorporate));
  }

  void signUpRequest() {
    if (!state.status.isValidated) {
      return;
    }

    final email = state.email.value.trim();
    final password = state.password.value;
    final confirmPassword = state.confirmPassword.value;
    final phoneNumber = state.phoneNumber;
    final isCorporate = state.isCorporate ?? false;

    _userRepository
        .signUp(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      isCorporate: isCorporate,
    )
        .listen((resource) {
      logger.d(resource);
      switch (resource.status) {
        case Status.success:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(status: FormzStatus.submissionSuccess, step: SignUpStep.verification));
          return;
        case Status.loading:
          _loaderBloc.add(LoaderEvent.buttonLoadEvent);
          emit(state.copyWith(status: FormzStatus.submissionInProgress));
          break;
        case Status.error:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            backendErrors: SignUpErrors.fromList(resource.errors),
          ));
          return;
      }
    });
  }

  void signIn() {
    final email = state.email.value.trim();
    final password = state.password.value;

    this._userRepository.signIn(email: email, password: password).listen((resource) {
      logger.d(resource);
      switch (resource.status) {
        case Status.success:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          _sessionCubit.sessionCreatingPassCodeEvent(isSignIn: true);
          return;
        case Status.loading:
          _loaderBloc.add(LoaderEvent.buttonLoadEvent);
          emit(state.copyWith(status: FormzStatus.submissionInProgress));
          break;
        case Status.error:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            backendErrors: SignUpErrors.fromList(resource.errors),
          ));
          return;
      }
    });
  }

  void setIdFront(String filePath) {
    emit(state.copyWith(idFrontPath: filePath));
  }

  void setIdBack(String filePath) {
    emit(state.copyWith(idBackPath: filePath));
  }

  void setSelfie(String filePath) {
    emit(state.copyWith(selfiePath: filePath));
  }

  void setProofOfResidencePath(String filePath) {
    emit(state.copyWith(proofOfResidencePath: filePath));
  }

void setVoucherPath(String filePath) {
    emit(state.copyWith(setVoucherPath: filePath));
  }
  void loadTermsAndConditions() async {
    await for (final resource in _kycRepository.getTermsAndConditionsDoc()) {
      if (resource.status == Status.success) {
        emit(state.copyWith(termsAndConditions: resource.data));
        return;
      } else if (resource.status == Status.error) {
        return;
      }
    }
  }

  void signInUserAndGoToSetPasscode() {
    final email = state.email.value.trim();
    final password = state.password.value;

    this._userRepository.signIn(email: email, password: password).listen((resource) {
      logger.d(resource);
      switch (resource.status) {
        case Status.success:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          _sessionCubit.sessionCreatingPassCodeEvent(isSignIn: false);
          return;
        case Status.loading:
          _loaderBloc.add(LoaderEvent.buttonLoadEvent);
          emit(state.copyWith(status: FormzStatus.submissionInProgress));
          break;
        case Status.error:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            backendErrors: SignUpErrors.fromList(resource.errors),
          ));
          return;
      }
    });
  }
}
