class ForgotPassword {
    String emailOrPhone;

    ForgotPassword({this.emailOrPhone});

    factory ForgotPassword.fromJson(Map<String, dynamic> json) {
        return ForgotPassword(
            emailOrPhone: json['email'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['email'] = this.emailOrPhone;
        return data;
    }

    @override
    String toString() {
        return 'ResetPassword{emailOrPhone: $emailOrPhone}';
    }
}
