// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class UpdateInfoModel {
  String? errorCode;
  String? errorDetail;

  UpdateInfoModel({this.errorCode, this.errorDetail});

  UpdateInfoModel.fromJson(Map<String, dynamic> json) {
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
