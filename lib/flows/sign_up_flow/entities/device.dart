class Device {
    String deviceId;
    String osType;
    String pushToken;

    Device({this.deviceId, this.osType, this.pushToken});

    factory Device.fromJson(Map<String, dynamic> json) {
        return Device(
            deviceId: json['deviceId'],
            osType: json['osType'],
            pushToken: json['pushToken'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['deviceId'] = this.deviceId;
        data['osType'] = this.osType;
        data['pushToken'] = this.pushToken;
        return data;
    }

    @override
    String toString() {
        return 'Device{deviceId: $deviceId, osType: $osType, pushToken: $pushToken}';
    }
}
