// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class ChangePasswordModel {
  String? errorCode;
  String? errorDetail;

  ChangePasswordModel({this.errorCode, this.errorDetail});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
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
