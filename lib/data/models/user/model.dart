import 'user.dart';

class User {
  String? sId;
  String? firstName;
  String? lastName;
  String? phone;

  String? userType;
  double? ratingAvg;
  List<Experiences>? experiences;
  List<Rating>? rating;
  String? userStatus;
  List<UserServices>? userServices;
  String? bio;
  int? experience;
  String? profileImg;

  User(
      {this.sId,
      this.firstName,
      this.lastName,
      this.phone,
      this.userType,
      this.experiences,
      this.rating,
      this.userStatus,
      this.userServices,
      this.bio,
      this.ratingAvg,
      this.experience,
      this.profileImg});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    userType = json['userType'];
    ratingAvg = json['ratingAvg'];
    if (json['experiences'] != null) {
      experiences = <Experiences>[];
      json['experiences'].forEach((v) {
        experiences!.add(Experiences.fromJson(v));
      });
    }
    if (json['rating'] != null) {
      rating = <Rating>[];
      json['rating'].forEach((v) {
        rating!.add(Rating.fromJson(v));
      });
    } else {
      rating = <Rating>[];
    }
    userStatus = json['userStatus'];
    if (json['userServices'] != null) {
      userServices = <UserServices>[];
      json['userServices'].forEach((v) {
        userServices!.add(UserServices.fromJson(v));
      });
    }
    bio = json['bio'];
    experience = json['experience'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['userType'] = userType;
    data['ratingAvg'] = ratingAvg;
    if (experiences != null) {
      data['experiences'] = experiences!.map((v) => v.toJson()).toList();
    }
    if (rating != null) {
      data['rating'] = rating!.map((v) => v.toJson()).toList();
    }
    data['userStatus'] = userStatus;
    if (userServices != null) {
      data['userServices'] = userServices!.map((v) => v.toJson()).toList();
    }
    data['bio'] = bio;
    data['experience'] = experience;
    data['profileImg'] = profileImg;
    return data;
  }

  User.empty() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = '';
    data['firstName'] = '';
    data['lastName'] = '';
    data['phone'] = '';
    data['userType'] = '';
    data['ratingAvg'] = '';

    data['experiences'] = null;

    data['rating'] = null;

    data['userStatus'] = '';

    data['userServices'] = null;

    data['bio'] = '';
    data['experience'] = '';
    data['profileImg'] = '';
  }
}
