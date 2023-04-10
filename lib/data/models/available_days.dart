class AvailableDay {
  List<ServiceTypeTime>? serviceTypeTime;
  String? serviceId;

  AvailableDay({this.serviceTypeTime, this.serviceId});

  AvailableDay.fromJson(Map<String, dynamic> json) {
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
  int? date;

  AvailableTime({this.day, this.time, this.date});

  AvailableTime.fromJson(Map<String, dynamic> json) {
    day = json['serviceType'];
    date = json['date'];
    time = json['time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}

class SelectedTime {
  String? day;
  String? time;

  SelectedTime({this.day, this.time});

  SelectedTime.fromJson(Map<String, dynamic> json) {
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
