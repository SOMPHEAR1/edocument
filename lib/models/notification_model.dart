// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class NotificationModel {
  String? errorCode;
  List<Notification>? notification;

  NotificationModel({this.errorCode, this.notification});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    if (json['Notification'] != null) {
      notification = <Notification>[];
      json['Notification'].forEach((v) {
        notification!.add(new Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.notification != null) {
      data['Notification'] = this.notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  String? notificationId;
  String? notificationTitle;
  String? notificationMessage;
  String? userId;
  String? userName;
  String? notificationType;
  String? documentId;
  String? assignmentId;
  String? assigner;
  String? state;
  String? postDate;

  Notification(
      {this.notificationId,
      this.notificationTitle,
      this.notificationMessage,
      this.userId,
      this.userName,
      this.notificationType,
      this.documentId,
      this.assignmentId,
      this.assigner,
      this.state,
      this.postDate});

  Notification.fromJson(Map<String, dynamic> json) {
    notificationId = json['NotificationId'];
    notificationTitle = json['NotificationTitle'];
    notificationMessage = json['NotificationMessage'];
    userId = json['UserId'];
    userName = json['UserName'];
    notificationType = json['NotificationType'];
    documentId = json['DocumentId'];
    assignmentId = json['AssignmentId'];
    assigner = json['Assigner'];
    state = json['State'];
    postDate = json['PostDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotificationId'] = this.notificationId;
    data['NotificationTitle'] = this.notificationTitle;
    data['NotificationMessage'] = this.notificationMessage;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['NotificationType'] = this.notificationType;
    data['DocumentId'] = this.documentId;
    data['AssignmentId'] = this.assignmentId;
    data['Assigner'] = this.assigner;
    data['State'] = this.state;
    data['PostDate'] = this.postDate;
    return data;
  }
}
