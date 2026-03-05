class ProfileDetailsModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? image;

  ProfileDetailsModel(
      {this.id, this.firstName, this.lastName, this.email, this.image});

  ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['image'] = this.image;
    return data;
  }
}
