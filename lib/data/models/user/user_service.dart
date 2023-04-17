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
  int? price;
  int? expiredTime;

  ServiceTypes({this.serviceType, this.time, this.price});

  ServiceTypes.fromJson(Map<String, dynamic> json) {
    serviceType = json['serviceType'];
    if (json['time'] != null) {
      time = <Time>[];
      json['time'].forEach((v) {
        time!.add(Time.fromJson(v));
      });
    }
    price = json['price'];
    expiredTime = json['expiredTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceType'] = serviceType;
    if (time != null) {
      data['time'] = time!.map((v) => v.toJson()).toList();
    }

    data['price'] = price;
    data['expiredTime'] = expiredTime;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceType'] = serviceType;
    data['price'] = price;
    data['expiredTime'] = expiredTime;
    return data;
  }
}
