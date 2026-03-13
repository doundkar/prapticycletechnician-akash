class NotificationModel {
  int? id;
  int? userId;
  String? title;
  String? message;
  String? type;
  String? paymentStatus;
  bool? isRead;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? jobId;
  String? serviceId;
 

  NotificationModel(
      {this.id,
      this.userId,
      this.title,
      this.message,
      this.type,
      this.paymentStatus,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.jobId,
      this.serviceId,
      });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    paymentStatus = json['payment_status'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    jobId = json['job_id'];
    serviceId = json['service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['type'] = this.type;
    data['payment_status'] = this.paymentStatus;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['job_id'] = this.jobId;
    data['service_id'] = this.serviceId;
    return data;
  }
}
