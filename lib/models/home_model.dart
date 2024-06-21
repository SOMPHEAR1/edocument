// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class HomeModel {
  String? errorCode;
  List<Proposal>? proposal;
  List<Task>? task;

  HomeModel({this.errorCode, this.proposal, this.task});

  HomeModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    if (json['Proposal'] != null) {
      proposal = <Proposal>[];
      json['Proposal'].forEach((v) {
        proposal!.add(new Proposal.fromJson(v));
      });
    }
    if (json['Task'] != null) {
      task = <Task>[];
      json['Task'].forEach((v) {
        task!.add(new Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.proposal != null) {
      data['Proposal'] = this.proposal!.map((v) => v.toJson()).toList();
    }
    if (this.task != null) {
      data['Task'] = this.task!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Proposal {
  String? issuePlace;
  String? noOfNewDoc;

  Proposal({this.issuePlace, this.noOfNewDoc});

  Proposal.fromJson(Map<String, dynamic> json) {
    issuePlace = json['IssuePlace'];
    noOfNewDoc = json['NoOfNewDoc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IssuePlace'] = this.issuePlace;
    data['NoOfNewDoc'] = this.noOfNewDoc;
    return data;
  }
}

class Task {
  String? assignmentType;
  String? noOfNewDoc;

  Task({this.assignmentType, this.noOfNewDoc});

  Task.fromJson(Map<String, dynamic> json) {
    assignmentType = json['AssignmentType'];
    noOfNewDoc = json['NoOfNewDoc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AssignmentType'] = this.assignmentType;
    data['NoOfNewDoc'] = this.noOfNewDoc;
    return data;
  }
}
