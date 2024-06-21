import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/home_model.dart';
import '../services/api/home/home_service.dart';
import '../services/notification/notification_services.dart';
import '../widget/app_widget.dart';
import 'bottom_nav_bar_controller.dart';
import 'login_controller.dart';

class HomeController extends GetxController {
  NotificationServices notificationServices = NotificationServices();

  @override
  Future<void> onInit() async {
    super.onInit();
    await notificationServices.firebaseMessaging.requestPermission();
    // await Permission.manageExternalStorage.request().isGranted;
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
 

    submitData();
  }

  @override
  void dispose() {
    LoginController().passwordController.clear();
    super.dispose();
  }

  String formatDateTime({DateTime? dateTime}) {
    return DateFormat('dd/MM/yyyy').format(dateTime!);
  }

  HomeService service = HomeService();
  Rx<HomeModel> homeResModel = HomeModel().obs;
  var firstName = getStorage.read('firstName');
  var lastName = getStorage.read('lastName');
  var roleID = getStorage.read('roleId');

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    var dateFrom = DateTime.now().subtract(const Duration(days: 365));
    var dateTo = DateTime.now();

    final res = await service.postAPI(
      formatDateTime(dateTime: dateFrom),
      formatDateTime(dateTime: dateTo),
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      homeResModel.value = right;
    });
  }

  void navigateToProfile() {
    Get.find<BottomNavBarController>().tabController?.index = 2;
    Get.toNamed('/bottomNavBar');
  }
}
