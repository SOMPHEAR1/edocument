// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class FeedbackFieldModel {
  String? errorCode;
  String? errorDetail;

  FeedbackFieldModel({this.errorCode, this.errorDetail});

  FeedbackFieldModel.fromJson(Map<String, dynamic> json) {
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
