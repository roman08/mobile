import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfileState extends Equatable {
  const ProfileState({
    @required this.firstName,
    @required this.lastName,
    @required this.nickName,
    this.secondName,
    this.mothersName,
    this.avatar,
  });

  final String firstName;
  final String secondName;
  final String lastName;
  final String mothersName;
  final String nickName;
  final Uint8List avatar;

  ProfileState copyWith({
    String firstName,
    String lastName,
    String nickName,
    Uint8List avatar,
    String secondName,
    String mothersName,
  }) {
    return ProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickName: nickName ?? this.nickName,
      avatar: avatar ?? this.avatar,
      secondName: secondName ?? this.secondName,
      mothersName: mothersName ?? this.mothersName,
    );
  }

  @override
  List<Object> get props => [firstName, lastName, nickName, secondName, mothersName];

  @override
  String toString() => "${super.toString()} firstName = $firstName, lastName = $lastName,  nickName = $nickName";
}

class ProfileUpdatedState extends ProfileState {
  const ProfileUpdatedState({
    @required String firstName,
    @required String lastName,
    @required String nickName,
    @required Uint8List avatar,
    @required String secondName,
    @required String mothersName,
  }) : super(
          firstName: firstName,
          lastName: lastName,
          nickName: nickName,
          avatar: avatar,
          secondName: secondName,
          mothersName: mothersName,
        );
}

class ProfileLoadingState extends ProfileState {}

class ProfileUpdatingErrorState extends ProfileState {
  final String error;

  const ProfileUpdatingErrorState({
    @required String firstName,
    @required String lastName,
    @required String nickName,
    @required Uint8List avatar,
    @required String secondName,
    @required String mothersName,
    @required this.error,
  }) : super(
          firstName: firstName,
          lastName: lastName,
          nickName: nickName,
          avatar: avatar,
          secondName: secondName,
          mothersName: mothersName,
        );
}
