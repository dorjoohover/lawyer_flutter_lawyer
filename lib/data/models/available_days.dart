class AvailableDay {
  String? date;
  List<ServiceTypeTime>? serviceTypeTime;
  String? serviceId;

  AvailableDay({this.date, this.serviceTypeTime, this.serviceId});

  AvailableDay.fromJson(Map<String, dynamic> json) {
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
  List<AvailableTime>? time;

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

class AvailableTime {
  String? day;
  List<String>? time;

  AvailableTime({this.day, this.time});

  AvailableTime.fromJson(Map<String, dynamic> json) {
    day = json['serviceType'];
    time = json['time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['time'] = this.time;
    return data;
  }
}