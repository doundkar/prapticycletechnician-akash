class WorkLocationModel {
  int? id;
  String? location;
  String? pincode;
  String? createdAt;

  WorkLocationModel({this.id, this.location, this.pincode, this.createdAt});

  WorkLocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    pincode = json['pincode'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['pincode'] = this.pincode;
    data['created_at'] = this.createdAt;
    return data;
  }
}
