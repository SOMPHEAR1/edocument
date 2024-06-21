// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class LoginModel {
  String? errorCode;
  String? errorDetail;
  String? firstName;
  String? lastName;
  String? roleId;
  String? unitId;
  String? publicKey;
  String? tokenJWT;

  LoginModel(
      {this.errorCode,
      this.errorDetail,
      this.firstName,
      this.lastName,
      this.roleId,
      this.unitId,
      this.publicKey,
      this.tokenJWT});

  LoginModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDetail = json['ErrorDetail'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    roleId = json['RoleId'];
    unitId = json['UnitId'];
    publicKey = json['PublicKey'];
    tokenJWT = json['TokenJWT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDetail'] = this.errorDetail;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['RoleId'] = this.roleId;
    data['UnitId'] = this.unitId;
    data['PublicKey'] = this.publicKey;
    data['TokenJWT'] = this.tokenJWT;
    return data;
  }
}
