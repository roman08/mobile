class CreateNewPassword {
    String confirmationCode;
    String newPassword;

    CreateNewPassword({this.confirmationCode, this.newPassword});

    factory CreateNewPassword.fromJson(Map<String, dynamic> json) {
        return CreateNewPassword(
            confirmationCode: json['confirmationCode'],
            newPassword: json['newPassword'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['confirmationCode'] = this.confirmationCode;
        data['newPassword'] = this.newPassword;
        return data;
    }

    @override
    String toString() {
        return 'CreateNewPassword{confirmationCode: $confirmationCode, newPassword: $newPassword}';
    }
}
