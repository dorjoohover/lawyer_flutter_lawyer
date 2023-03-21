class User {
  String? sId;
  String? firstname;
  String? lastname;
  String? phone;
  String? userType;
  String? userStatus;
  String? profileImg;

  User(
      {this.sId,
      this.firstname,
      this.lastname,
      this.phone,
      this.userType,
      this.userStatus,
      this.profileImg});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    userType = json['userType'];
    userStatus = json['userStatus'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['userType'] = this.userType;
    data['userStatus'] = this.userStatus;
    data['profileImg'] = this.profileImg;
    return data;
  }
}