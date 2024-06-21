// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class ProposalDocumentModel {
  String? errorCode;
  List<NewDocument>? newDocument;
  List<AssignedDocument>? assignedDocument;

  ProposalDocumentModel(
      {this.errorCode, this.newDocument, this.assignedDocument});

  ProposalDocumentModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    if (json['NewDocument'] != null) {
      newDocument = <NewDocument>[];
      json['NewDocument'].forEach((v) {
        newDocument!.add(new NewDocument.fromJson(v));
      });
    }
    if (json['AssignedDocument'] != null) {
      assignedDocument = <AssignedDocument>[];
      json['AssignedDocument'].forEach((v) {
        assignedDocument!.add(new AssignedDocument.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.newDocument != null) {
      data['NewDocument'] = this.newDocument!.map((v) => v.toJson()).toList();
    }
    if (this.assignedDocument != null) {
      data['AssignedDocument'] =
          this.assignedDocument!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewDocument {
  String? documentId;
  String? documentNumber;
  String? documentTitle;
  String? submissionDateTime;
  String? noOfFiles;
  String? isStar;

  NewDocument(
      {this.documentId,
      this.documentNumber,
      this.documentTitle,
      this.submissionDateTime,
      this.noOfFiles,
      this.isStar});

  NewDocument.fromJson(Map<String, dynamic> json) {
    documentId = json['DocumentId'];
    documentNumber = json['DocumentNumber'];
    documentTitle = json['DocumentTitle'];
    submissionDateTime = json['SubmissionDateTime'];
    noOfFiles = json['NoOfFiles'];
    isStar = json['IsStar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocumentId'] = this.documentId;
    data['DocumentNumber'] = this.documentNumber;
    data['DocumentTitle'] = this.documentTitle;
    data['DocumentNumber'] = this.documentNumber;
    data['SubmissionDateTime'] = this.submissionDateTime;
    data['NoOfFiles'] = this.noOfFiles;
    data['IsStar'] = this.isStar;
    return data;
  }
}

class AssignedDocument {
  String? documentId;
  String? documentNumber;
  String? documentTitle;
  String? submissionDateTime;

  AssignedDocument(
      {this.documentId,
      this.documentNumber,
      this.documentTitle,
      this.submissionDateTime});

  AssignedDocument.fromJson(Map<String, dynamic> json) {
    documentId = json['DocumentId'];
    documentNumber = json['DocumentNumber'];
    documentTitle = json['DocumentTitle'];
    submissionDateTime = json['SubmissionDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocumentId'] = this.documentId;
    data['DocumentNumber'] = this.documentNumber;
    data['DocumentTitle'] = this.documentTitle;
    data['SubmissionDateTime'] = this.submissionDateTime;
    return data;
  }
}
