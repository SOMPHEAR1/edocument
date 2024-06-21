// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class ProposalDetailModel {
  String? errorCode;
  DocumentInfo? documentInfo;

  ProposalDetailModel({this.errorCode, this.documentInfo});

  ProposalDetailModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    documentInfo = json['DocumentInfo'] != null
        ? new DocumentInfo.fromJson(json['DocumentInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.documentInfo != null) {
      data['DocumentInfo'] = this.documentInfo!.toJson();
    }
    return data;
  }
}

class DocumentInfo {
  String? documentId;
  String? documentNumber;
  String? documentDate;
  String? documentTitle;
  String? documentReleasePlace;
  String? documentSignature;
  String? documentType;
  String? documentCategory;
  String? submissionFormID;
  String? adminDateReceived;
  String? submisssionToBOM;
  String? submissionDateTime;
  List<ListOfFiles>? listOfFiles;

  DocumentInfo(
      {this.documentId,
      this.documentNumber,
      this.documentDate,
      this.documentTitle,
      this.documentReleasePlace,
      this.documentSignature,
      this.documentType,
      this.documentCategory,
      this.submissionFormID,
      this.adminDateReceived,
      this.submisssionToBOM,
      this.submissionDateTime,
      this.listOfFiles});

  DocumentInfo.fromJson(Map<String, dynamic> json) {
    documentId = json['DocumentId'];
    documentNumber = json['DocumentNumber'];
    documentDate = json['DocumentDate'];
    documentTitle = json['DocumentTitle'];
    documentReleasePlace = json['DocumentReleasePlace'];
    documentSignature = json['DocumentSignature'];
    documentType = json['DocumentType'];
    documentCategory = json['DocumentCategory'];
    submissionFormID = json['SubmissionFormID'];
    adminDateReceived = json['AdminDateReceived'];
    submisssionToBOM = json['SubmisssionToBOM'];
    submissionDateTime = json['SubmissionDateTime'];
    if (json['ListOfFiles'] != null) {
      listOfFiles = <ListOfFiles>[];
      json['ListOfFiles'].forEach((v) {
        listOfFiles!.add(new ListOfFiles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocumentId'] = this.documentId;
    data['DocumentNumber'] = this.documentNumber;
    data['DocumentDate'] = this.documentDate;
    data['DocumentTitle'] = this.documentTitle;
    data['DocumentReleasePlace'] = this.documentReleasePlace;
    data['DocumentSignature'] = this.documentSignature;
    data['DocumentType'] = this.documentType;
    data['DocumentCategory'] = this.documentCategory;
    data['SubmissionFormID'] = this.submissionFormID;
    data['AdminDateReceived'] = this.adminDateReceived;
    data['SubmisssionToBOM'] = this.submisssionToBOM;
    data['SubmissionDateTime'] = this.submissionDateTime;
    if (this.listOfFiles != null) {
      data['ListOfFiles'] = this.listOfFiles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListOfFiles {
  String? fileId;
  String? fileName;

  ListOfFiles({this.fileId, this.fileName});

  ListOfFiles.fromJson(Map<String, dynamic> json) {
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
