class CredentialsData {
    String accessToken;
    Object challengeName;
    String refreshToken;

    CredentialsData({this.accessToken, this.challengeName, this.refreshToken});

    static CredentialsData fromJson(Map<String, dynamic> json) {
        return CredentialsData(
            accessToken: json['accessToken'],
            challengeName: json['challengeName'] ?? null,
            refreshToken: json['refreshToken'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['accessToken'] = this.accessToken;
        data['refreshToken'] = this.refreshToken;
        if (this.challengeName != null) {
            data['challengeName'] = this.challengeName;
        }
        return data;
    }
}
