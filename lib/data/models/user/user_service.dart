class UserServices {
  List<ServiceTypes>? serviceTypes;
  String? serviceId;

  UserServices({this.serviceTypes, this.serviceId});

  UserServices.fromJson(Map<String, dynamic> json) {
    if (json['serviceTypes'] != null) {
      serviceTypes = <ServiceTypes>[];
      json['serviceTypes'].forEach((v) {
        serviceTypes!.add(ServiceTypes.fromJson(v));
      });
    }
    serviceId = json['serviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceTypes != null) {
      data['serviceTypes'] = serviceTypes!.map((v) => v.toJson()).toList();
    }
    data['serviceId'] = serviceId;
    return data;
  }
}

class ServiceTypes {
  String? serviceType;
  List<Time>? time;
  Price? price;

  ServiceTypes({this.serviceType, this.time, this.price});

  ServiceTypes.fromJson(Map<String, dynamic> json) {
    serviceType = json['serviceType'];
    if (json['time'] != null) {
      time = <Time>[];
      json['time'].forEach((v) {
        time!.add(Time.fromJson(v));
      });
    }
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceType'] = this.serviceType;
    if (time != null) {
      data['time'] = time!.map((v) => v.toJson()).toList();
    }
    if (price != null) {
      data['price'] = price!.toJson();
    }
    return data;
  }
}

class Time {
  String? day;
  int? date;
  List<String>? time;

  Time({this.day, this.date, this.time});

  Time.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    time = json['time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}

class Price {
  String? sId;
  String? serviceId;
  List<ServicePrice>? servicePrice;

  Price({this.sId, this.serviceId, this.servicePrice});

  Price.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    serviceId = json['serviceId'];
    if (json['servicePrice'] != null) {
      servicePrice = <ServicePrice>[];
      json['servicePrice'].forEach((v) {
        servicePrice!.add(new ServicePrice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['serviceId'] = this.serviceId;
    if (this.servicePrice != null) {
      data['servicePrice'] = this.servicePrice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicePrice {
  String? serviceType;
  int? price;
  String? expiredTime;

  ServicePrice({this.serviceType, this.price, this.expiredTime});

  ServicePrice.fromJson(Map<String, dynamic> json) {
    serviceType = json['serviceType'];
    price = json['price'];
    expiredTime = json['expiredTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceType'] = this.serviceType;
    data['price'] = this.price;
    data['expiredTime'] = this.expiredTime;
    return data;
  }
}
