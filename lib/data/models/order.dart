class Order {
  String? sId;
  int? date;
  ClientId? clientId;
  LawyerId? lawyerId;
  String? location;
  String? expiredTime;
  String? serviceType;
  String? serviceStatus;
  String? channelName;
  String? channelToken;
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
      this.channelToken,
      this.createdAt,
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    date = json['date'];
    clientId = json['clientId'] != null
        ? new ClientId.fromJson(json['clientId'])
        : null;
    lawyerId = json['lawyerId'] != null
        ? new LawyerId.fromJson(json['lawyerId'])
        : null;
    location = json['location'];
    expiredTime = json['expiredTime'];
    serviceType = json['serviceType'];
    serviceStatus = json['serviceStatus'];
    channelName = json['channelName'];
    channelToken = json['channelToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['date'] = this.date;
    if (this.clientId != null) {
      data['clientId'] = this.clientId!.toJson();
    }
    if (this.lawyerId != null) {
      data['lawyerId'] = this.lawyerId!.toJson();
    }
    data['location'] = this.location;
    data['expiredTime'] = this.expiredTime;
    data['serviceType'] = this.serviceType;
    data['serviceStatus'] = this.serviceStatus;
    data['channelName'] = this.channelName;
    data['channelToken'] = this.channelToken;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ClientId {
  String? sId;
  String? firstname;
  String? lastname;
  String? phone;

  ClientId({this.sId, this.firstname, this.lastname, this.phone});

  ClientId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    return data;
  }
}

class LawyerId {
  String? sId;
  String? firstname;
  String? lastname;
  String? phone;
  String? profileImg;

  LawyerId(
      {this.sId, this.firstname, this.lastname, this.phone, this.profileImg});

  LawyerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['profileImg'] = this.profileImg;
    return data;
  }
}