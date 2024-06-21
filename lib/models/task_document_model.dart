// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class TaskDocumentModel {
  String? errorCode;
  List<Task>? task;
  List<SubTask>? subTask;

  TaskDocumentModel({this.errorCode, this.task, this.subTask});

  TaskDocumentModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    if (json['Task'] != null) {
      task = <Task>[];
      json['Task'].forEach((v) {
        task!.add(new Task.fromJson(v));
      });
    }
    if (json['SubTask'] != null) {
      subTask = <SubTask>[];
      json['SubTask'].forEach((v) {
        subTask!.add(new SubTask.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.task != null) {
      data['Task'] = this.task!.map((v) => v.toJson()).toList();
    }
    if (this.subTask != null) {
      data['SubTask'] = this.subTask!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  String? assignmentType;
  String? documentId;
  String? documentNumber;
  String? documentTitle;
  String? submissionDateTime;
  String? assignmentID;
  String? assignerName;
  String? vicePresidentName;
  String? deparmentName;
  String? isLate;
  String? assignedDate;
  String? noOfFeedbacks;
  String? progress;
  List<Feedbacks>? feedbacks;

  Task(
      {this.assignmentType,
      this.documentId,
      this.documentNumber,
      this.documentTitle,
      this.submissionDateTime,
      this.assignmentID,
      this.assignerName,
      this.vicePresidentName,
      this.deparmentName,
      this.isLate,
      this.assignedDate,
      this.noOfFeedbacks,
      this.progress,
      this.feedbacks});

  Task.fromJson(Map<String, dynamic> json) {
    assignmentType = json['AssignmentType'];
    documentId = json['DocumentId'];
    documentNumber = json['DocumentNumber'];
    documentTitle = json['DocumentTitle'];
    submissionDateTime = json['SubmissionDateTime'];
    assignmentID = json['AssignmentID'];
    assignerName = json['AssignerName'];
    vicePresidentName = json['VicePresidentName'];
    deparmentName = json['DeparmentName'];
    isLate = json['IsLate'];
    assignedDate = json['AssignedDate'];
    noOfFeedbacks = json['NoOfFeedbacks'];
    progress = json['Progress'];
    if (json['Feedbacks'] != null) {
      feedbacks = <Feedbacks>[];
      json['Feedbacks'].forEach((v) {
        feedbacks!.add(new Feedbacks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AssignmentType'] = this.assignmentType;
    data['DocumentId'] = this.documentId;
    data['DocumentNumber'] = this.documentNumber;
    data['DocumentTitle'] = this.documentTitle;
    data['SubmissionDateTime'] = this.submissionDateTime;
    data['AssignmentID'] = this.assignmentID;
    data['AssignerName'] = this.assignerName;
    data['VicePresidentName'] = this.vicePresidentName;
    data['DeparmentName'] = this.deparmentName;
    data['IsLate'] = this.isLate;
    data['AssignedDate'] = this.assignedDate;
    data['NoOfFeedbacks'] = this.noOfFeedbacks;
    data['Progress'] = this.progress;
    if (this.feedbacks != null) {
      data['Feedbacks'] = this.feedbacks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubTask {
  String? assignmentType;
  String? documentId;
  String? documentNumber;
  String? documentTitle;
  String? submissionDateTime;
  String? assignmentID;
  String? assignerName;
  String? vicePresidentName;
  String? coorVicePresidentName;
  String? deparmentName;
  String? staffName;
  String? coorDeparmentName;
  String? isLate;
  String? assignedDate;
  String? noOfFeedbacks;
  String? progress;
  List<Feedbacks>? feedbacks;

  SubTask(
      {this.assignmentType,
      this.documentId,
      this.documentNumber,
      this.documentTitle,
      this.submissionDateTime,
      this.assignmentID,
      this.assignerName,
      this.vicePresidentName,
      this.coorVicePresidentName,
      this.deparmentName,
      this.staffName,
      this.coorDeparmentName,
      this.isLate,
      this.assignedDate,
      this.noOfFeedbacks,
      this.progress,
      this.feedbacks});

  SubTask.fromJson(Map<String, dynamic> json) {
    assignmentType = json['AssignmentType'];
    documentId = json['DocumentId'];
    documentNumber = json['DocumentNumber'];
    documentTitle = json['DocumentTitle'];
    submissionDateTime = json['SubmissionDateTime'];
    assignmentID = json['AssignmentID'];
    assignerName = json['AssignerName'];
    vicePresidentName = json['VicePresidentName'];
    coorVicePresidentName = json['CoorVicePresidentName'];
    deparmentName = json['DeparmentName'];
    staffName = json['StaffName'];
    coorDeparmentName = json['CoorDeparmentName'];
    isLate = json['IsLate'];
    assignedDate = json['AssignedDate'];
    noOfFeedbacks = json['NoOfFeedbacks'];
    progress = json['Progress'];
    if (json['Feedbacks'] != null) {
      feedbacks = <Feedbacks>[];
      json['Feedbacks'].forEach((v) {
        feedbacks!.add(new Feedbacks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AssignmentType'] = this.assignmentType;
    data['DocumentId'] = this.documentId;
    data['DocumentNumber'] = this.documentNumber;
    data['DocumentTitle'] = this.documentTitle;
    data['SubmissionDateTime'] = this.submissionDateTime;
    data['AssignmentID'] = this.assignmentID;
    data['AssignerName'] = this.assignerName;
    data['VicePresidentName'] = this.vicePresidentName;
    data['CoorVicePresidentName'] = this.coorVicePresidentName;
    data['DeparmentName'] = this.deparmentName;
    data['StaffName'] = this.staffName;
    data['CoorDeparmentName'] = this.coorDeparmentName;
    data['IsLate'] = this.isLate;
    data['AssignedDate'] = this.assignedDate;
    data['NoOfFeedbacks'] = this.noOfFeedbacks;
    data['Progress'] = this.progress;
    if (this.feedbacks != null) {
      data['Feedbacks'] = this.feedbacks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedbacks {
  String? feedbackId;
  String? feedbackText;
  String? feedbackerName;
  String? feedbackTime;
  String? progress;

  Feedbacks(
      {this.feedbackId,
      this.feedbackText,
      this.feedbackerName,
      this.feedbackTime,
      this.progress});

  Feedbacks.fromJson(Map<String, dynamic> json) {
    feedbackId = json['FeedbackId'];
    feedbackText = json['FeedbackText'];
    feedbackerName = json['FeedbackerName'];
    feedbackTime = json['FeedbackTime'];
    progress = json['Progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FeedbackId'] = this.feedbackId;
    data['FeedbackText'] = this.feedbackText;
    data['FeedbackerName'] = this.feedbackerName;
    data['FeedbackTime'] = this.feedbackTime;
    data['Progress'] = this.progress;
    return data;
  }
}
