// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class HistoryModel {
  String? errorCode;
  List<Document>? document;

  HistoryModel({this.errorCode, this.document});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    if (json['Document'] != null) {
      document = <Document>[];
      json['Document'].forEach((v) {
        document!.add(new Document.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.document != null) {
      data['Document'] = this.document!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Document {
  String? documentId;
  String? documentNumber;
  String? documentDate;
  String? documentTitle;
  String? documentReleasePlace;
  String? submissionToBOM;
  String? submissionDateTime;
  String? documentType;
  String? documentCategory;
  String? status;

  Document(
      {this.documentId,
      this.documentNumber,
      this.documentDate,
      this.documentTitle,
      this.documentReleasePlace,
      this.submissionToBOM,
      this.submissionDateTime,
      this.documentType,
      this.documentCategory,
      this.status});

  Document.fromJson(Map<String, dynamic> json) {
    documentId = json['DocumentId'];
    documentNumber = json['DocumentNumber'];
    documentDate = json['DocumentDate'];
    documentTitle = json['DocumentTitle'];
    documentReleasePlace = json['DocumentReleasePlace'];
    submissionToBOM = json['SubmissionToBOM'];
    submissionDateTime = json['SubmissionDateTime'];
    documentType = json['DocumentType'];
    documentCategory = json['DocumentCategory'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocumentId'] = this.documentId;
    data['DocumentNumber'] = this.documentNumber;
    data['DocumentDate'] = this.documentDate;
    data['DocumentTitle'] = this.documentTitle;
    data['DocumentReleasePlace'] = this.documentReleasePlace;
    data['SubmissionToBOM'] = this.submissionToBOM;
    data['SubmissionDateTime'] = this.submissionDateTime;
    data['DocumentType'] = this.documentType;
    data['DocumentCategory'] = this.documentCategory;
    data['Status'] = this.status;
    return data;
  }
}
