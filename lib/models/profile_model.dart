class ProfileModel {
  int? id;
  String? username;
  String? password;
  String? firstName;
  String? image;
  String? accesstoken;

  ProfileModel({
    this.id,
    this.username,
    this.password,
    this.firstName,
    this.image,
    this.accesstoken,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    firstName = json['firstName'];
    image = json['image'];
    accesstoken = json['accesstoken'];
  }
}
