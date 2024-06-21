// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class FeedbackModel {
  String? errorCode;
  String? totalFeedbacks;
  String? progress;
  List<Feedback>? feedback;

  FeedbackModel(
      {this.errorCode, this.totalFeedbacks, this.progress, this.feedback});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    totalFeedbacks = json['TotalFeedbacks'];
    progress = json['Progress'];
    if (json['Feedback'] != null) {
      feedback = <Feedback>[];
      json['Feedback'].forEach((v) {
        feedback!.add(new Feedback.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['TotalFeedbacks'] = this.totalFeedbacks;
    data['Progress'] = this.progress;
    if (this.feedback != null) {
      data['Feedback'] = this.feedback!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedback {
  String? feedbackId;
  String? assignmentId;
  String? feedbackerId;
  String? feedbackerName;
  String? feedbackDate;
  String? feedbackText;
  String? progress;
  List<File>? file;

  Feedback(
      {this.feedbackId,
      this.assignmentId,
      this.feedbackerId,
      this.feedbackerName,
      this.feedbackDate,
      this.feedbackText,
      this.progress,
      this.file});

  Feedback.fromJson(Map<String, dynamic> json) {
    feedbackId = json['FeedbackId'];
    assignmentId = json['AssignmentId'];
    feedbackerId = json['FeedbackerId'];
    feedbackerName = json['FeedbackerName'];
    feedbackDate = json['FeedbackDate'];
    feedbackText = json['FeedbackText'];
    progress = json['Progress'];
    if (json['File'] != null) {
      file = <File>[];
      json['File'].forEach((v) {
        file!.add(new File.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FeedbackId'] = this.feedbackId;
    data['AssignmentId'] = this.assignmentId;
    data['FeedbackerId'] = this.feedbackerId;
    data['FeedbackerName'] = this.feedbackerName;
    data['FeedbackDate'] = this.feedbackDate;
    data['FeedbackText'] = this.feedbackText;
    data['Progress'] = this.progress;
    if (this.file != null) {
      data['File'] = this.file!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class File {
  String? fileId;
  String? fileName;

  File({this.fileId, this.fileName});

  File.fromJson(Map<String, dynamic> json) {
    fileId = json['FileId'];
    fileName = json['FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileId'] = this.fileId;
    data['FileName'] = this.fileName;
    return data;
  }
}
