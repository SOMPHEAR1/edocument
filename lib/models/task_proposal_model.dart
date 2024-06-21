// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class TaskProposalModel {
  String? errorCode;
  List<Task>? task;
  List<SubTask>? subTask;

  TaskProposalModel({this.errorCode, this.task, this.subTask});

  TaskProposalModel.fromJson(Map<String, dynamic> json) {
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
  String? assignmentId;
  String? documentId;
  String? assignerId;
  String? assignerName;
  String? assigneeId;
  String? assigneeName;
  String? assignmentText;
  String? assignedDate;
  String? reportDate;
  String? numberOfFeedbacks;
  String? progress;
  String? vicePresidentId;
  String? vicePresidentName;
  String? coorVicePresidentId;
  String? coorVicePresidentName;
  String? departmentId;
  String? departmentName;
  String? coorDepartmentId;
  String? coorDepartmentName;

  Task(
      {this.assignmentId,
      this.documentId,
      this.assignerId,
      this.assignerName,
      this.assigneeId,
      this.assigneeName,
      this.assignmentText,
      this.assignedDate,
      this.reportDate,
      this.numberOfFeedbacks,
      this.progress,
      this.vicePresidentId,
      this.vicePresidentName,
      this.coorVicePresidentId,
      this.coorVicePresidentName,
      this.departmentId,
      this.departmentName,
      this.coorDepartmentId,
      this.coorDepartmentName});

  Task.fromJson(Map<String, dynamic> json) {
    assignmentId = json['AssignmentId'];
    documentId = json['DocumentId'];
    assignerId = json['AssignerId'];
    assignerName = json['AssignerName'];
    assigneeId = json['AssigneeId'];
    assigneeName = json['AssigneeName'];
    assignmentText = json['AssignmentText'];
    assignedDate = json['AssignedDate'];
    reportDate = json['ReportDate'];
    numberOfFeedbacks = json['NumberOfFeedbacks'];
    progress = json['Progress'];
    vicePresidentId = json['VicePresidentId'];
    vicePresidentName = json['VicePresidentName'];
    coorVicePresidentId = json['CoorVicePresidentId'];
    coorVicePresidentName = json['CoorVicePresidentName'];
    departmentId = json['DepartmentId'];
    departmentName = json['DepartmentName'];
    coorDepartmentId = json['CoorDepartmentId'];
    coorDepartmentName = json['CoorDepartmentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AssignmentId'] = this.assignmentId;
    data['DocumentId'] = this.documentId;
    data['AssignerId'] = this.assignerId;
    data['AssignerName'] = this.assignerName;
    data['AssigneeId'] = this.assigneeId;
    data['AssigneeName'] = this.assigneeName;
    data['AssignmentText'] = this.assignmentText;
    data['AssignedDate'] = this.assignedDate;
    data['ReportDate'] = this.reportDate;
    data['NumberOfFeedbacks'] = this.numberOfFeedbacks;
    data['Progress'] = this.progress;
    data['VicePresidentId'] = this.vicePresidentId;
    data['VicePresidentName'] = this.vicePresidentName;
    data['CoorVicePresidentId'] = this.coorVicePresidentId;
    data['CoorVicePresidentName'] = this.coorVicePresidentName;
    data['DepartmentId'] = this.departmentId;
    data['DepartmentName'] = this.departmentName;
    data['CoorDepartmentId'] = this.coorDepartmentId;
    data['CoorDepartmentName'] = this.coorDepartmentName;
    return data;
  }
}

class SubTask {
  String? assignmentType;
  String? assignmentId;
  String? documentId;
  String? assignerId;
  String? assignerName;
  String? assigneeId;
  String? assigneeName;
  String? vicePresidentId;
  String? vicePresidentName;
  String? coorVicePresidentId;
  String? coorVicePresidentName;
  String? departmentId;
  String? departmentName;
  String? coorDepartmentId;
  String? coorDepartmentName;
  String? assignmentText;
  String? assignedDate;
  String? reportDate;
  String? isLate;
  String? numberOfFeedbacks;
  String? progress;

  SubTask(
      {this.assignmentType,
      this.assignmentId,
      this.documentId,
      this.assignerId,
      this.assignerName,
      this.assigneeId,
      this.assigneeName,
      this.vicePresidentId,
      this.vicePresidentName,
      this.coorVicePresidentId,
      this.coorVicePresidentName,
      this.departmentId,
      this.departmentName,
      this.coorDepartmentId,
      this.coorDepartmentName,
      this.assignmentText,
      this.assignedDate,
      this.reportDate,
      this.isLate,
      this.numberOfFeedbacks,
      this.progress});

  SubTask.fromJson(Map<String, dynamic> json) {
    assignmentType = json['AssignmentType'];
    assignmentId = json['AssignmentId'];
    documentId = json['DocumentId'];
    assignerId = json['AssignerId'];
    assignerName = json['AssignerName'];
    assigneeId = json['AssigneeId'];
    assigneeName = json['AssigneeName'];
    vicePresidentId = json['VicePresidentId'];
    vicePresidentName = json['VicePresidentName'];
    coorVicePresidentId = json['CoorVicePresidentId'];
    coorVicePresidentName = json['CoorVicePresidentName'];
    departmentId = json['DepartmentId'];
    departmentName = json['DepartmentName'];
    coorDepartmentId = json['CoorDepartmentId'];
    coorDepartmentName = json['CoorDepartmentName'];
    assignmentText = json['AssignmentText'];
    assignedDate = json['AssignedDate'];
    reportDate = json['ReportDate'];
    isLate = json['IsLate'];
    numberOfFeedbacks = json['NumberOfFeedbacks'];
    progress = json['Progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AssignmentType'] = this.assignmentType;
    data['AssignmentId'] = this.assignmentId;
    data['DocumentId'] = this.documentId;
    data['AssignerId'] = this.assignerId;
    data['AssignerName'] = this.assignerName;
    data['AssigneeId'] = this.assigneeId;
    data['AssigneeName'] = this.assigneeName;
    data['VicePresidentId'] = this.vicePresidentId;
    data['VicePresidentName'] = this.vicePresidentName;
    data['CoorVicePresidentId'] = this.coorVicePresidentId;
    data['CoorVicePresidentName'] = this.coorVicePresidentName;
    data['DepartmentId'] = this.departmentId;
    data['DepartmentName'] = this.departmentName;
    data['CoorDepartmentId'] = this.coorDepartmentId;
    data['CoorDepartmentName'] = this.coorDepartmentName;
    data['AssignmentText'] = this.assignmentText;
    data['AssignedDate'] = this.assignedDate;
    data['ReportDate'] = this.reportDate;
    data['IsLate'] = this.isLate;
    data['NumberOfFeedbacks'] = this.numberOfFeedbacks;
    data['Progress'] = this.progress;
    return data;
  }
}
