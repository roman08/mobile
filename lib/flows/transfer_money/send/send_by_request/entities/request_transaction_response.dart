class RequestMoneyResponse {
    String createdAt;
    String description;
    int id;
    String rate;
    String status;
    String subject;
    String userId;

    RequestMoneyResponse({this.createdAt, this.description, this.id, this.rate, this.status, this.subject, this.userId});

    static RequestMoneyResponse fromJson(Map<String, dynamic> json) {
        return RequestMoneyResponse(
            createdAt: json['createdAt'],
            description: json['description'],
            id: json['id'],
            rate: json['rate'],
            status: json['status'],
            subject: json['subject'],
            userId: json['userId'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['createdAt'] = this.createdAt;
        data['description'] = this.description;
        data['id'] = this.id;
        data['rate'] = this.rate;
        data['status'] = this.status;
        data['subject'] = this.subject;
        data['userId'] = this.userId;
        return data;
    }

    @override
    String toString() {
        return 'RequestMoneyResponse{createdAt: $createdAt, description: $description, id: $id, rate: $rate, status: $status, subject: $subject, userId: $userId}';
    }
}
