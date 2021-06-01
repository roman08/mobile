
import 'package:Velmie/flows/sign_up_flow/entities/device.dart';

class SignUpRequest {
  SignUpData data;

  SignUpRequest({this.data});

  factory SignUpRequest.fromJson(Map<String, dynamic> json) {
    return SignUpRequest(
      data: json['data'] != null ? SignUpData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'SignUpRequest{data: $data}';
  }
}

class SignUpData {
  Device device;
  String confirmPassword;
  String email;
  String password;
  String phoneNumber;
  String nickname;
  bool isCorporate;

  // STUB
  String profileType;
  String roleName;

  SignUpData({
    this.device,
    this.confirmPassword,
    this.email,
    this.password,
    this.phoneNumber,
    this.nickname,
    this.isCorporate,

    // STUB
    this.profileType,
    this.roleName,
  });

  factory SignUpData.fromJson(Map<String, dynamic> json) {
    return SignUpData(
      device: json['device'] != null ? Device.fromJson(json['device']) : null,
      confirmPassword: json['confirmPassword'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      nickname: json['nickname'],
      isCorporate: json['isCorporate'],

      // STUB
      profileType: json['profileType'],
      roleName: json['roleName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['confirmPassword'] = this.confirmPassword;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phoneNumber'] = this.phoneNumber;
    data['nickname'] = this.nickname;
    data['isCorporate'] = this.isCorporate;
    if (this.device != null) {
      data['device'] = this.device.toJson();
    }

    // STUB
    data['profileType'] = this.profileType;
    data['roleName'] = this.roleName;
    return data;
  }

  @override
  String toString() {
    return 'SignUpData{device: $device, confirmPassword: $confirmPassword, email: $email, password: $password, phoneNumber: $phoneNumber, roleName: $roleName, isCorporate: $isCorporate}';
  }
}
