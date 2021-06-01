class Data {
    String confirmPassword;
    String previousPassword;
    String proposedPassword;

    Data({this.confirmPassword, this.previousPassword, this.proposedPassword});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            confirmPassword: json['confirmPassword'],
            previousPassword: json['previousPassword'],
            proposedPassword: json['proposedPassword'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['confirmPassword'] = this.confirmPassword;
        data['previousPassword'] = this.previousPassword;
        data['proposedPassword'] = this.proposedPassword;
        return data;
    }

    @override
    String toString() {
        return 'Data{confirmPassword: $confirmPassword, previousPassword: $previousPassword, proposedPassword: $proposedPassword}';
    }
}

class ResetPassword {
    Data data;

    ResetPassword({this.data});

    factory ResetPassword.fromJson(Map<String, dynamic> json) {
        return ResetPassword(
            data: json['data'] != null ? Data.fromJson(json['data']) : null,
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
        return 'ResetPassword{data: $data}';
    }
}
