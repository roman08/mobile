
import 'package:Velmie/flows/sign_up_flow/entities/device.dart';

class SignInRequest {
    SignInData data;

    SignInRequest({this.data});

    factory SignInRequest.fromJson(Map<String, dynamic> json) {
        return SignInRequest(
            data: json['data'] != null ? SignInData.fromJson(json['data']) : null,
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
        return 'SignInRequest{data: $data}';
    }
}

class SignInData {
    Device device;
    String email;
    String password;

    SignInData({this.device, this.email, this.password});

    factory SignInData.fromJson(Map<String, dynamic> json) {
        return SignInData(
            device: json['device'] != null ? Device.fromJson(json['device']) : null,
            email: json['email'],
            password: json['password'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['email'] = this.email;
        data['password'] = this.password;
        if (this.device != null) {
            data['device'] = this.device.toJson();
        }
        return data;
    }

    @override
    String toString() {
        return 'SignInData{device: $device, email: $email, password: $password}';
    }
}
