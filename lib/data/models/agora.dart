class Agora {
  String? rtcToken;

  Agora({this.rtcToken});

  Agora.fromJson(Map<String, dynamic> json) {
    rtcToken = json['rtcToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rtcToken'] = this.rtcToken;
    return data;
  }
}