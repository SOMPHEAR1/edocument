// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class AssignDocumentModel {
  String? errorCode;
  String? errorDetail;

  AssignDocumentModel({this.errorCode, this.errorDetail});

  AssignDocumentModel.fromJson(Map<String, dynamic> json) {
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
