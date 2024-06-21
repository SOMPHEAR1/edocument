
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../widget/app_widget.dart';

class ProfileController extends GetxController {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  var isSwitched = true;
  String appVersion = '';

  @override
  void onInit() {
    super.onInit();
    firebaseMessaging.subscribeToTopic('notify_system');
    firebaseMessaging.requestPermission();
    getAppVersion();
  }

  ProfileController() {
    if (getStorage.read('notify') != null) {
      isSwitched = getStorage.read('notify');
    }
    update();
  }

  void toggleNotifications(bool value) {
    isSwitched = value;
    getStorage.write('notify', isSwitched);
    update();
  }

  // get app version
  Future<void> getAppVersion() async {
    try {
      final pubspecFile = File('pubspec.yaml');
      final pubspecText = await pubspecFile.readAsString();
      final versionPattern = RegExp(r'version:\s*(\d+\.\d+\.\d+)');
      final match = versionPattern.firstMatch(pubspecText);
      if (match != null) {
        appVersion = match.group(1)!;
        update();
      }
    } catch (e) {
      log('Error reading pubspec.yaml: $e');
    }
  }

  
}
