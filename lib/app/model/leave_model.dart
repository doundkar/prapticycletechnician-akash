class LeaveModel {
  int? id;
  int? technicianId;
  String? startDate;
  String? endDate;
  String? type;
  String? reason;
  String? status;
  String? adminNote;
  int? actionBy;
  String? actionAt;
  String? createdAt;
  String? updatedAt;

  LeaveModel(
      {this.id,
      this.technicianId,
      this.startDate,
      this.endDate,
      this.type,
      this.reason,
      this.status,
      this.adminNote,
      this.actionBy,
      this.actionAt,
      this.createdAt,
      this.updatedAt});

  LeaveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    technicianId = json['technician_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    type = json['type'];
    reason = json['reason'];
    status = json['status'];
    adminNote = json['admin_note'];
    actionBy = json['action_by'];
    actionAt = json['action_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['technician_id'] = this.technicianId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['type'] = this.type;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['admin_note'] = this.adminNote;
    data['action_by'] = this.actionBy;
    data['action_at'] = this.actionAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
