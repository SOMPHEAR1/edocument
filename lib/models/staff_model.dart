// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class StaffModel {
  String? errorCode;
  List<Staff>? staff;

  StaffModel({this.errorCode, this.staff});

  StaffModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    if (json['Staff'] != null) {
      staff = <Staff>[];
      json['Staff'].forEach((v) {
        staff!.add(new Staff.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.staff != null) {
      data['Staff'] = this.staff!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Staff {
  String? username;
  String? firstName;
  String? lastName;
  String? position;

  Staff({this.username, this.firstName, this.lastName, this.position});

  Staff.fromJson(Map<String, dynamic> json) {
    username = json['Username'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    position = json['Position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Username'] = this.username;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Position'] = this.position;
    return data;
  }
}
