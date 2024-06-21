// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class DirectorModel {
  String? errorCode;
  List<Unit>? unit;

  DirectorModel({this.errorCode, this.unit});

  DirectorModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    if (json['Unit'] != null) {
      unit = <Unit>[];
      json['Unit'].forEach((v) {
        unit!.add(new Unit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.unit != null) {
      data['Unit'] = this.unit!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Unit {
  String? unitID;
  String? unitName;

  Unit({this.unitID, this.unitName});

  Unit.fromJson(Map<String, dynamic> json) {
    unitID = json['unitID'];
    unitName = json['unitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitID'] = this.unitID;
    data['unitName'] = this.unitName;
    return data;
  }
}
