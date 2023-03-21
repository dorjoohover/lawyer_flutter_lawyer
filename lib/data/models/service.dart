class Service {
  String? sId;
  String? title;
  String? img;
  String? parentId;

  Service({this.sId, this.title, this.img, this.parentId});

  Service.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    img = json['img'];
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['img'] = this.img;
    data['parentId'] = this.parentId;
    return data;
  }
}

class SubService {
  String? sId;
  String? title;
  ParentId? parentId;
  String? img;
  String? description;

  SubService({this.sId, this.title, this.parentId, this.img, this.description});

  SubService.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    parentId = json['parentId'] != null
        ? new ParentId.fromJson(json['parentId'])
        : null;
    img = json['img'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    if (this.parentId != null) {
      data['parentId'] = this.parentId!.toJson();
    }
    data['img'] = this.img;
    data['description'] = this.description;
    return data;
  }
}

class ParentId {
  String? sId;
  String? title;

  ParentId({this.sId, this.title});

  ParentId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    return data;
  }
}
