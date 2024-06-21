// live
String baseUrl = 'https://openapi.bidc.com.kh/e_document/v1';

String loginUrl = '$baseUrl/login';
String viewFileUrl = '$baseUrl/download';
String apiUrl = '$baseUrl/process';

String homeHeader = "03"; // home
String docProposalHeader = "04"; // get list proposal
String docTaskHeader = "05"; // get list task --> add type in header
String proposalDetailHeader = "06"; // proposal detail
String taskDetailHeader = "12"; // get list task detail
String historyHeader = "08"; // search document
String bomHeader = "02"; // get BOM list
String directorHeader = "01"; // get department and branch list
String assignInchargeHeader = "07"; // assign to incharge/coordinate
String taskProposalHeader = "11"; // list task when document are assigned already
String notificationHeader = "17"; // get notification list
String staffHeader =
    "09"; // get list staff, when director incharge assign to staff
String assignStaffHeader = "10"; // assign to staff
String feedbackListHeader =
    "14"; // get list feedback / document go to ("MsgID: 05")
String feedbackHeader = "13"; // insert feedback comment
String updateInfoHeader = "19"; // update information
String changePasswordHeader = "21"; // change password
String countNotification = "22"; // unread notification count


// open api
// String baseUrl = 'http://10.195.6.76:8086/e_document/v1';

// business
// String baseUrl = 'http://10.195.6.75:6801/BIDC/eDocument';