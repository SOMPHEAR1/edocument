// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class TaskDetailModel {
  String? errorCode;
  TaskInfo? taskInfo;

  TaskDetailModel({this.errorCode, this.taskInfo});

  TaskDetailModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    taskInfo = json['TaskInfo'] != null
        ? new TaskInfo.fromJson(json['TaskInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.taskInfo != null) {
      data['TaskInfo'] = this.taskInfo!.toJson();
    }
    return data;
  }
}

class TaskInfo {
  String? assignmentId;
  String? documentId;
  String? assignerId;
  String? assignerName;
  String? vicePresidentId;
  String? vicePresidentName;
  String? coorVicePresidentId;
  String? coorVicePresidentName;
  String? deparmentId;
  String? departmentName;
  String? coorDeparmentId;
  String? coorDepartmentName;
  String? assigneeId;
  String? assigneeName;
  String? assignmentText;
  String? assignedDate;
  String? reportDate;
  String? status;
  String? documentNumber;
  String? documentDate;
  String? documentReleasePlace;
  String? documentType;
  String? receivedDate;
  String? documentTitle;
  List<ListOfFiles>? listOfFiles;

  TaskInfo(
      {this.assignmentId,
      this.documentId,
      this.assignerId,
      this.assignerName,
      this.vicePresidentId,
      this.vicePresidentName,
      this.coorVicePresidentId,
      this.coorVicePresidentName,
      this.deparmentId,
      this.departmentName,
      this.coorDeparmentId,
      this.coorDepartmentName,
      this.assigneeId,
      this.assigneeName,
      this.assignmentText,
      this.assignedDate,
      this.reportDate,
      this.status,
      this.documentNumber,
      this.documentDate,
      this.documentReleasePlace,
      this.documentType,
      this.receivedDate,
      this.documentTitle,
      this.listOfFiles});

  TaskInfo.fromJson(Map<String, dynamic> json) {
    assignmentId = json['AssignmentId'];
    documentId = json['DocumentId'];
    assignerId = json['AssignerId'];
    assignerName = json['AssignerName'];
    vicePresidentId = json['VicePresidentId'];
    vicePresidentName = json['VicePresidentName'];
    coorVicePresidentId = json['CoorVicePresidentId'];
    coorVicePresidentName = json['CoorVicePresidentName'];
    deparmentId = json['DeparmentId'];
    departmentName = json['DepartmentName'];
    coorDeparmentId = json['CoorDeparmentId'];
    coorDepartmentName = json['CoorDepartmentName'];
    assigneeId = json['AssigneeId'];
    assigneeName = json['AssigneeName'];
    assignmentText = json['AssignmentText'];
    assignedDate = json['AssignedDate'];
    reportDate = json['ReportDate'];
    status = json['Status'];
    documentNumber = json['DocumentNumber'];
    documentDate = json['DocumentDate'];
    documentReleasePlace = json['DocumentReleasePlace'];
    documentType = json['DocumentType'];
    receivedDate = json['ReceivedDate'];
    documentTitle = json['DocumentTitle'];
    if (json['ListOfFiles'] != null) {
      listOfFiles = <ListOfFiles>[];
      json['ListOfFiles'].forEach((v) {
        listOfFiles!.add(new ListOfFiles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AssignmentId'] = this.assignmentId;
    data['DocumentId'] = this.documentId;
    data['AssignerId'] = this.assignerId;
    data['AssignerName'] = this.assignerName;
    data['VicePresidentId'] = this.vicePresidentId;
    data['VicePresidentName'] = this.vicePresidentName;
    data['CoorVicePresidentId'] = this.coorVicePresidentId;
    data['CoorVicePresidentName'] = this.coorVicePresidentName;
    data['DeparmentId'] = this.deparmentId;
    data['DepartmentName'] = this.departmentName;
    data['CoorDeparmentId'] = this.coorDeparmentId;
    data['CoorDepartmentName'] = this.coorDepartmentName;
    data['AssigneeId'] = this.assigneeId;
    data['AssigneeName'] = this.assigneeName;
    data['AssignmentText'] = this.assignmentText;
    data['AssignedDate'] = this.assignedDate;
    data['ReportDate'] = this.reportDate;
    data['Status'] = this.status;
    data['DocumentNumber'] = this.documentNumber;
    data['DocumentDate'] = this.documentDate;
    data['DocumentReleasePlace'] = this.documentReleasePlace;
    data['DocumentType'] = this.documentType;
    data['ReceivedDate'] = this.receivedDate;
    data['DocumentTitle'] = this.documentTitle;
    if (this.listOfFiles != null) {
      data['ListOfFiles'] = this.listOfFiles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListOfFiles {
  String? fileId;
  String? fileName;
  String? serverFileName;

  ListOfFiles({this.fileId, this.fileName, this.serverFileName});

  ListOfFiles.fromJson(Map<String, dynamic> json) {
    fileId = json['FileId'];
    fileName = json['FileName'];
    serverFileName = json['ServerFileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileId'] = this.fileId;
    data['FileName'] = this.fileName;
    data['ServerFileName'] = this.serverFileName;
    return data;
  }
}
