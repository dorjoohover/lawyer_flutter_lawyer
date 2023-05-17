import './models.dart';

class Order {
  String? sId;
  int? date;
  ClientId? clientId;
  LawyerId? lawyerId;
  Location? location;
  int? expiredTime;
  String? serviceType;
  String? serviceStatus;
  String? channelName;
  String? serviceId;
  String? userToken;
  String? lawyerToken;
  String? price;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.sId,
      this.date,
      this.clientId,
      this.lawyerId,
      this.location,
      this.expiredTime,
      this.serviceType,
      this.serviceStatus,
      this.channelName,
      this.lawyerToken,
      this.userToken,
      this.price,
      this.createdAt,
      this.serviceId,
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    date = json['date'];
    clientId =
        json['clientId'] != null ? ClientId.fromJson(json['clientId']) : null;
    lawyerId =
        json['lawyerId'] != null ? LawyerId.fromJson(json['lawyerId']) : null;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;

    expiredTime = json['expiredTime'];
    serviceType = json['serviceType'];
    serviceStatus = json['serviceStatus'];
    channelName = json['channelName'];
    userToken = json['userToken'];
    lawyerToken = json['lawyerToken'];
    price = json['price'];
    serviceId = json['serviceId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['date'] = date;
    if (clientId != null) {
      data['clientId'] = clientId!.toJson();
    }
    if (lawyerId != null) {
      data['lawyerId'] = lawyerId!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }

    data['expiredTime'] = expiredTime;
    data['serviceType'] = serviceType;
    data['serviceStatus'] = serviceStatus;
    data['channelName'] = channelName;
    data['lawyerToken'] = lawyerToken;
    data['userToken'] = userToken;
    data['price'] = price;
    data['serviceId'] = serviceId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ClientId {
  String? sId;
  String? firstName;
  String? lastName;
  String? phone;

  ClientId({this.sId, this.firstName, this.lastName, this.phone});

  ClientId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    return data;
  }
}

class LawyerId {
  String? sId;
  String? firstName;
  String? lastName;
  String? phone;
  String? profileImg;

  LawyerId(
      {this.sId, this.firstName, this.lastName, this.phone, this.profileImg});

  LawyerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['profileImg'] = this.profileImg;
    return data;
  }
}
