import 'package:get/get.dart';

import '../controllers/bottom_nav_bar_controller.dart';
import '../controllers/history_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/splash_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() async {
    // Initialize all Controllers
    Get.put<SplashController>(SplashController());
    Get.put<LoginController>(LoginController());
    Get.lazyPut<BottomNavBarController>(() => BottomNavBarController());

    // Assigned
    Get.lazyPut<HistoryController>(() => HistoryController());

    // Profiles
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
