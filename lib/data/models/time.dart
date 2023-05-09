class Time {
  String? sId;
  String? lawyer;
  int? expiredTime;
  int? price;
  String? service;
  String? serviceType;
  List<TimeDetail>? timeDetail;

  Time(
      {this.sId,
      this.lawyer,
      this.expiredTime,
      this.price,
      this.service,
      this.serviceType,
      this.timeDetail});

  Time.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lawyer = json['lawyer'];
    expiredTime = json['expiredTime'];
    price = json['price'];
    service = json['service'];
    serviceType = json['serviceType'];
    if (json['timeDetail'] != null) {
      timeDetail = <TimeDetail>[];
      json['timeDetail'].forEach((v) {
        timeDetail!.add(TimeDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['lawyer'] = lawyer;
    data['expiredTime'] = expiredTime;
    data['price'] = price;
    data['service'] = service;
    data['serviceType'] = serviceType;
    if (timeDetail != null) {
      data['timeDetail'] = timeDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeDetail {
  String? status;
  int? time;

  TimeDetail({this.status, this.time});

  TimeDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['time'] = time;
    return data;
  }
}
