import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/notification_count_controller.dart';
import '../../controllers/sub_task_document_controller.dart';
import '../../controllers/task_document_controller.dart';
import '../../models/notification_model.dart';
import '../../screens/assigned/assigned_screen.dart';
import '../../screens/home/comment_screen.dart';
import '../../widget/app_widget.dart';
import '../encryptor/aes_encryption.dart';
import '../encryptor/rsa_encryption.dart';
import '../url.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

class NotificationServices {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<dynamic> postAPI(String token, String publicKey) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": notificationHeader}
      };
      String convertRequestBody = json.encode(requestBody);

      // encrypt AES
      final encryptAES = AESEncryption().encryptAES64(
        plainText: convertRequestBody,
        secretKeyBase64Text: key,
      );

      // encrypt RSA
      final encrytRSA = await RSAEncryption().encryptRSA64(
        plainText: key,
        publicKeyStr: publicKey,
      );

      // encode request body
      Map<String, dynamic> requestBodyEncrypt = {
        "q": encryptAES,
        "m": encrytRSA,
      };
      String convertRequestBodyEncrypt = json.encode(requestBodyEncrypt);

      // request response
      final response = await dio.post(
        apiUrl,
        data: convertRequestBodyEncrypt,
        options: Options(
          validateStatus: (_) => true,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // check status
      if (response.statusCode == 200 && response.data['q'] != null) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('Notification: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(NotificationModel.fromJson(data));
      } else if (response.statusCode == 401) {
        return Left(response.statusMessage);
      } else if (response.statusCode == 403) {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: 'Service have problem!',
        );
        return Left(response.statusMessage);
      } else {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: 'Something wrong!',
        );
        return Left(response.statusMessage);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  handleMessage(RemoteMessage? message) {
    if (message != null && message.data['assignmentId'] != null) {
      Get.to(
        () => AssignedScreen(),
        arguments: {
          'documentType': 'Task',
          'assignmentId': '${message.data['assignmentId']}',
        },
      );
    } else if (message != null && message.data['documentId'] != null) {
      Get.to(
        () => CommentScreen(),
        arguments: {
          'docID': '${message.data['documentId']}',
          'documentType': 'new',
        },
      );
    }
    return;
  }

  Future<void> handleBackgroundMessage(RemoteMessage? message) async {
    if (message != null && message.data['assignmentId'] != null) {
      Get.to(
        () => AssignedScreen(),
        arguments: {
          'documentType': 'Task',
          'assignmentId': '${message.data['assignmentId']}',
        },
      );
    } else if (message != null && message.data['documentId'] != null) {
      Get.to(
        () => CommentScreen(),
        arguments: {
          'docID': '${message.data['documentId']}',
          'documentType': 'new',
        },
      );
    }
    return;
  }

  Future<void> initLocalNotification(RemoteMessage message) async {
    log('message1: ${message.data}');
    var androidInitSettings = const AndroidInitializationSettings(
      '@drawable/ic_launcher',
    );
    var iosInitSettings = const DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // handle interaction when app is active for android
        handleMessage(message);
      },
    );
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      Get.find<NotificationController>().submitData();
      Get.find<NotificationCountController>().submitData();
      Get.find<HomeController>().submitData();
      Get.find<TaskDocumentController>().submitTaskData();
      Get.find<SubTaskDocumentController>().submitSubTaskData();

      if (GetPlatform.isAndroid) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          payload: jsonEncode(message.toMap()),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
        );
      }
    }
  }

  initPushNotification() async {
    // on terminate
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 4000), () async {
        await handleMessage(initialMessage);
      });
    }

    // on background
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // on foreground
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotification(message);
      showFlutterNotification(message);
    });
  }

  initNotification() async {
    await setupFlutterNotifications();
    initLocalNotification(const RemoteMessage());
    initPushNotification();
  }
}
