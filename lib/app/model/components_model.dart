class ComponentsModel {
  int? id;
  int? position;
  String? name;
  String? categoryId;
  String? type;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? icon;

  ComponentsModel(
      {this.id,
      this.position,
      this.name,
      this.categoryId,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.icon});

  ComponentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    name = json['name'];
    categoryId = json['category_id'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['type'] = this.type;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['icon'] = this.icon;
    return data;
  }
}
