import 'package:bicycle_app_technician/app/model/service_item_model.dart';
import 'package:intl/intl.dart';

class JobDetailsModel {
  int? id;
  String? customerName;
  String? location;
  String? distance;
  String? jobType;
  String? description;
  int? durationMinutes;
  String? charges;
  String? status;
  String? acceptedTechnicianId;
  String? createdAt;
  String? updatedAt;
  String? otp;
  String? verifyStatus;
  String? beforePhotos;
  String? startTime;
  String? acceptStatus;
  String? afterPhotos;
  String? partsUsed;
  int? totalTimeSeconds;
  String? completedTime;
  String? completionOtp;
  String? customerReview;
  String? date;
  String? time;
  String? type;
  List<ServiceItemModel>? serviceItems;

  JobDetailsModel(
      {this.id,
      this.customerName,
      this.location,
      this.distance,
      this.jobType,
      this.description,
      this.durationMinutes,
      this.charges,
      this.status,
      this.acceptedTechnicianId,
      this.createdAt,
      this.updatedAt,
      this.otp,
      this.verifyStatus,
      this.beforePhotos,
      this.startTime,
      this.acceptStatus,
      this.afterPhotos,
      this.partsUsed,
      this.totalTimeSeconds,
      this.completedTime,
      this.completionOtp,
      this.customerReview});

  JobDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    location = json['location'];
    distance = json['distance'];
    jobType = json['job_type'];
    description = json['description'];
    durationMinutes = json['duration_minutes'];
    charges = json['charges'];
    status = json['status'];
    acceptedTechnicianId = json['accepted_technician_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    otp = json['otp'];
    verifyStatus = json['verify_status'];
    beforePhotos = json['before_photos'];
    startTime = json['start_time'];
    acceptStatus = json['accept_status'];
    afterPhotos = json['after_photos'];
    partsUsed = json['parts_used'];
    totalTimeSeconds = json['total_time_seconds'];
    completedTime = json['completed_time'];
    completionOtp = json['completion_otp'];
    customerReview = json['customer_review'];
    type = json['type'];
    DateTime parsedDate = DateTime.parse(json["jobdatetime"]);
    date = DateFormat('MMM dd').format(parsedDate);
    time = DateFormat('hh:mm a').format(parsedDate);
    serviceItems = (json["service_items"] as List<dynamic>?)
        ?.map((item) => ServiceItemModel.fromJson(item))
        .toList() ??
    [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_name'] = this.customerName;
    data['location'] = this.location;
    data['distance'] = this.distance;
    data['job_type'] = this.jobType;
    data['description'] = this.description;
    data['duration_minutes'] = this.durationMinutes;
    data['charges'] = this.charges;
    data['status'] = this.status;
    data['accepted_technician_id'] = this.acceptedTechnicianId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['otp'] = this.otp;
    data['verify_status'] = this.verifyStatus;
    data['before_photos'] = this.beforePhotos;
    data['start_time'] = this.startTime;
    data['accept_status'] = this.acceptStatus;
    data['after_photos'] = this.afterPhotos;
    data['parts_used'] = this.partsUsed;
    data['total_time_seconds'] = this.totalTimeSeconds;
    data['completed_time'] = this.completedTime;
    data['completion_otp'] = this.completionOtp;
    data['customer_review'] = this.customerReview;
    return data;
  }
}
