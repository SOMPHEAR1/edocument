import 'package:e_document_app/screens/on_board/on_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/app_widget.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  bool isOnBoard = false;

  @override
  void onReady() {
    super.onReady();
    

    if (getStorage.read("token") != null) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.offAllNamed(
          '/bottomNavBar',
          arguments: {
            'username':
                '${getStorage.read("fistName")} ${getStorage.read("lastName")}',
          },
        );
      });
    } else {
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (getStorage.read('onBoard') == false || getStorage.read('onBoard') == null) {
          getStorage.write('onBoard', isOnBoard);

          Get.offAll(
            () => OnBoardScreen(),
          );
        } else {
          Get.offAllNamed('/login');
        }
      });
    }
  }
}
