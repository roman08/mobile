class PasswordVerifyCode {
    PasswordVerifyCode({this.confirmationCode});

    factory PasswordVerifyCode.fromJson(Map<String, dynamic> json) {
        return PasswordVerifyCode(
            confirmationCode: json['confirmationCode'],
        );
    }

    String confirmationCode;

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['confirmationCode'] = confirmationCode;
        return data;
    }

    @override
    String toString() {
        return 'VerifyCode{confirmationCode: $confirmationCode}';
    }
}
