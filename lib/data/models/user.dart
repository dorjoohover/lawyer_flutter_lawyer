class User {
  String? sId;
  String? firstname;
  String? lastname;
  String? phone;
  String? password;
  String? userType;
  List<Rating>? rating;
  String? userStatus;
  List<AvailableDays>? availableDays;
  String? createdAt;
  String? updatedAt;
  String? bio;
  int? experience;
  String? profileImg;
  double? ratingAvg;

  User(
      {this.sId,
      this.firstname,
      this.lastname,
      this.phone,
      this.password,
      this.userType,
      this.rating,
      this.userStatus,
      this.availableDays,
      this.createdAt,
      this.updatedAt,
      this.bio,
      this.experience,
      this.profileImg,
      this.ratingAvg});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    password = json['password'];
    userType = json['userType'];
    if (json['rating'] != null) {
      rating = <Rating>[];
      json['rating'].forEach((v) {
        rating!.add(new Rating.fromJson(v));
      });
    }
    userStatus = json['userStatus'];
    if (json['availableDays'] != null) {
      availableDays = <AvailableDays>[];
      json['availableDays'].forEach((v) {
        availableDays!.add(new AvailableDays.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    bio = json['bio'];
    experience = json['experience'];
    profileImg = json['profileImg'];
    ratingAvg = json['ratingAvg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['userType'] = this.userType;
    if (this.rating != null) {
      data['rating'] = this.rating!.map((v) => v.toJson()).toList();
    }
    data['userStatus'] = this.userStatus;
    if (this.availableDays != null) {
      data['availableDays'] =
          this.availableDays!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['bio'] = this.bio;
    data['experience'] = this.experience;
    data['profileImg'] = this.profileImg;
    data['ratingAvg'] = this.ratingAvg;
    return data;
  }
}

class Rating {
  String? clientId;
  String? comment;
  double? rating;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Rating(
      {this.clientId,
      this.comment,
      this.rating,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Rating.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    comment = json['comment'];
    rating = json['rating'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientId'] = this.clientId;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class AvailableDays {
  String? date;
  List<ServiceTypeTime>? serviceTypeTime;
  String? serviceId;

  AvailableDays({this.date, this.serviceTypeTime, this.serviceId});

  AvailableDays.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['serviceTypeTime'] != null) {
      serviceTypeTime = <ServiceTypeTime>[];
      json['serviceTypeTime'].forEach((v) {
        serviceTypeTime!.add(new ServiceTypeTime.fromJson(v));
      });
    }
    serviceId = json['serviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.serviceTypeTime != null) {
      data['serviceTypeTime'] =
          this.serviceTypeTime!.map((v) => v.toJson()).toList();
    }
    data['serviceId'] = this.serviceId;
    return data;
  }
}

class ServiceTypeTime {
  String? serviceType;
  List<String>? time;

  ServiceTypeTime({this.serviceType, this.time});

  ServiceTypeTime.fromJson(Map<String, dynamic> json) {
    serviceType = json['serviceType'];
    time = json['time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceType'] = this.serviceType;
    data['time'] = this.time;
    return data;
  }
}
