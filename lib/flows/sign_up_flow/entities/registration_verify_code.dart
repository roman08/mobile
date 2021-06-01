class VerifyCode {
    VerifyCode({this.code});

    factory VerifyCode.fromJson(Map<String, dynamic> json) {
        return VerifyCode(
            code: json['code'],
        );
    }

    String code;

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['code'] = code;
        return data;
    }

    @override
    String toString() {
        return 'VerifyCode{code: $code}';
    }
}
