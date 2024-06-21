// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class BOMModel {
  String? errorCode;
  List<BOM>? bOM;

  BOMModel({this.errorCode, this.bOM});

  BOMModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    if (json['BOM'] != null) {
      bOM = <BOM>[];
      json['BOM'].forEach((v) {
        bOM!.add(new BOM.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.bOM != null) {
      data['BOM'] = this.bOM!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BOM {
  String? bomID;
  String? bomName;

  BOM({this.bomID, this.bomName});

  BOM.fromJson(Map<String, dynamic> json) {
    bomID = json['bomID'];
    bomName = json['bomName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bomID'] = this.bomID;
    data['bomName'] = this.bomName;
    return data;
  }
}
