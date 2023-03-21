class Lawyer {
  String? sId;
  String? firstname;
  String? lastname;
  String? phone;
  String? userType;
  List<Rating>? rating;
  String? userStatus;
  List<AvailableDays>? availableDays;
  String? bio;
  int? experience;
  String? profileImg;
  double? ratingAvg;

  Lawyer(
      {sId,
      firstname,
      lastname,
      phone,
      userType,
      rating,
      userStatus,
      availableDays,
      bio,
      experience,
      profileImg,
      ratingAvg});

  Lawyer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    userType = json['userType'];
    if (json['rating'] != null) {
      rating = <Rating>[];
      json['rating'].forEach((v) {
        rating!.add(Rating.fromJson(v));
      });
    }
    userStatus = json['userStatus'];
    if (json['availableDays'] != null) {
      availableDays = <AvailableDays>[];
      json['availableDays'].map((v) {
        availableDays!.add(AvailableDays.fromJson(v));
      });
    }
    bio = json['bio'];
    experience = json['experience'];
    profileImg = json['profileImg'];
    ratingAvg = json['ratingAvg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['phone'] = phone;
    data['userType'] = userType;
    if (rating != null) {
      data['rating'] = rating!.map((v) => v.toJson()).toList();
    }
    data['userStatus'] = userStatus;
    if (availableDays != null) {
      data['availableDays'] = availableDays!.map((v) => v.toJson()).toList();
    }
    data['bio'] = bio;
    data['experience'] = experience;
    data['profileImg'] = profileImg;
    data['ratingAvg'] = ratingAvg;
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

  Rating({clientId, comment, rating, sId, createdAt, updatedAt, iV});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['comment'] = comment;
    data['rating'] = rating;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class AvailableDays {
  String? date;
  List<ServiceTypeTime>? serviceTypeTime;
  String? serviceId;

  AvailableDays({date, serviceTypeTime, serviceId});

  AvailableDays.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['serviceTypeTime'] != null) {
      serviceTypeTime = <ServiceTypeTime>[];
      json['serviceTypeTime'].forEach((v) {
        serviceTypeTime!.add(ServiceTypeTime.fromJson(v));
      });
    }
    serviceId = json['serviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (serviceTypeTime != null) {
      data['serviceTypeTime'] =
          serviceTypeTime!.map((v) => v.toJson()).toList();
    }
    data['serviceId'] = serviceId;
    return data;
  }
}

class ServiceTypeTime {
  String? serviceType;
  List<String>? time;

  ServiceTypeTime({serviceType, time});

  ServiceTypeTime.fromJson(Map<String, dynamic> json) {
    serviceType = json['serviceType'];
    time = json['time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceType'] = serviceType;
    data['time'] = time;
    return data;
  }
}
