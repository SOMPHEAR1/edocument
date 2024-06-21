// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class NotificationCountModel {
  String? errorCode;
  String? errorDetail;
  String? noOfNewNoti;

  NotificationCountModel({this.errorCode, this.noOfNewNoti});

  NotificationCountModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDetail = json['ErrorDetail'];
    noOfNewNoti = json['NoOfNewNoti'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDetail'] = this.errorDetail;
    data['NoOfNewNoti'] = this.noOfNewNoti;
    return data;
  }
}
