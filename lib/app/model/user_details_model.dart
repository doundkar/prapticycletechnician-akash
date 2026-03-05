class UserDetailsModel {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? email;
  String? phone;
  String? token;

  UserDetailsModel(
      {this.id,
      this.name,
      this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.email,
      this.phone,
      this.token});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    final user = json["user"];
    id = user['id'];
    firstName = user['first_name'];
    lastName = user['last_name'];
    dateOfBirth = user['date_of_birth'];
    email = user['email'];
    phone = user['phone'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['date_of_birth'] = this.dateOfBirth;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['token'] = this.token;
    return data;
  }
}
