// ignore_for_file: unnecessary_this, prefer_collection_literals, unnecessary_new

class AssignStaffModel {
  String? errorCode;
  String? errorDetail;

  AssignStaffModel({this.errorCode, this.errorDetail});

  AssignStaffModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDetail = json['ErrorDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDetail'] = this.errorDetail;
    return data;
  }
}
