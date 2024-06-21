// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:badges/badges.dart' as badges;

import '../controllers/login_controller.dart';
import 'color.dart';
import 'triangle_shape.dart';

var getStorage = GetStorage();
var hasConnection = InternetConnectionChecker().hasConnection;

class AppWidget {
  // check network
  getConnect({Function()? function}) async {
    final hasConnection = InternetConnectionChecker().hasConnection;
    if (hasConnection == true) {
      function;
    }
  }

  // pull to refresh
  pullRefresh({
    Function()? action,
    Widget? child,
  }) {
    return CustomMaterialIndicator(
      onRefresh: () async {
        EasyLoading.show(status: 'Loading...');

        Future.delayed(const Duration(seconds: 1), () {
          action!.call();
          EasyLoading.dismiss();
        });
      },
      indicatorBuilder: (BuildContext context, IndicatorController controller) {
        return LoadingIndicator(
          indicatorType: Indicator.ballClipRotateMultiple,
          strokeWidth: 3,
          colors: [AppColor().primary],
        );
      },
      durations: const RefreshIndicatorDurations(
        cancelDuration: Duration(seconds: 2),
      ),
      child: child!,
    );
  }

  // task & sub-task item
  taskItem({
    String? number,
    String? docTitle,
    String? docBy,
    String? byPerson,
    String? date,
    String? progress,
    Color rippleColor = Colors.black26,
    String? isLate,
    Function()? action,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TouchRippleEffect(
        onTap: () {
          action?.call();
        },
        rippleColor: rippleColor,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor().secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLate == '0' ? Colors.transparent : Colors.red.shade900,
              width: 2,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 6),
                    FaIcon(
                      FontAwesomeIcons.fileImport,
                      color: isLate == '1'
                          ? Colors.red.shade900.withOpacity(0.9)
                          : AppColor().primary,
                      size: 28,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Icon(
                          Icons.av_timer_outlined,
                          color: isLate == '1'
                              ? Colors.red.shade900
                              : progress == '0'
                                  ? AppColor().secondaryText.withOpacity(0.6)
                                  : progress != '100'
                                      ? Colors.lightBlue
                                      : AppColor().primary,
                          size: 20,
                        ),
                        AppWidget().textTitle(
                          title: '$progress%',
                          size: 12.5,
                          color: isLate == '1'
                              ? Colors.red.shade900
                              : progress == '0'
                                  ? AppColor().secondaryText.withOpacity(0.6)
                                  : progress != '100'
                                      ? Colors.lightBlue
                                      : AppColor().primary,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppWidget().textNormal(
                                title: '$number',
                                color: AppColor().secondary,
                                size: 13,
                              ),
                              AppWidget().textNormal(
                                title: '$date',
                                color: AppColor().primaryText,
                                size: 13,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          AppWidget().textTitle(
                            title: '$docTitle',
                            color: AppColor().primaryText,
                            size: 15,
                            line: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppWidget().textNormal(
                            title: '$docBy:',
                            color: AppColor().primary,
                            size: 12.5,
                          ),
                          AppWidget().textNormal(
                            title: '$byPerson',
                            color: AppColor().primaryText,
                            size: 12.5,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // task for proposal item
  taskProposalItem({
    String? docBy,
    String? byPerson,
    String? assignedDate,
    String? reportDate,
    String? progress,
    Color rippleColor = Colors.black26,
    Function()? action,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TouchRippleEffect(
        onTap: () {
          action?.call();
        },
        rippleColor: rippleColor,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor().secondaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 6),
                    FaIcon(
                      FontAwesomeIcons.fileImport,
                      color: AppColor().primary,
                      size: 28,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Icon(
                          Icons.av_timer_outlined,
                          color: progress == '0'
                              ? AppColor().secondaryText.withOpacity(0.6)
                              : progress != '100'
                                  ? Colors.lightBlue
                                  : AppColor().primary,
                          size: 20,
                        ),
                        AppWidget().textTitle(
                          title: '$progress%',
                          size: 12.5,
                          color: progress == '0'
                              ? AppColor().secondaryText.withOpacity(0.6)
                              : progress != '100'
                                  ? Colors.lightBlue
                                  : AppColor().primary,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppWidget().textNormal(
                            title: '$docBy',
                            color: AppColor().secondary,
                            size: 13,
                          ),
                          const SizedBox(height: 2),
                          byPerson == null
                              ? Container()
                              : AppWidget().textTitle(
                                  title: byPerson,
                                  color: AppColor().primaryText,
                                  size: 13,
                                ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppWidget().textNormal(
                            title: '$assignedDate',
                            color: AppColor().primaryText,
                            size: 12.5,
                          ),
                          AppWidget().textNormal(
                            title: '$reportDate',
                            color: AppColor().primaryText,
                            size: 12.5,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // feedback item
  feedbackItems({
    String? userId,
    String? assignerName,
    required String username,
    required String date,
    required String comment,
    Widget? fileWidget,
    String progress = '0',
  }) {
    return userId == getStorage.read('username') && assignerName == username ||
            userId == getStorage.read('username') &&
                Get.arguments['documentType'] == 'SubTask' &&
                getStorage.read('roleId') == 'CEO' ||
            userId == getStorage.read('username') &&
                Get.arguments['documentType'] == 'SubTask' &&
                getStorage.read('roleId') == 'BOM' ||
            userId == getStorage.read('username') &&
                Get.arguments['documentType'] == 'SubTask' &&
                getStorage.read('roleId') == 'Director'
        ? Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 40),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 90,
                            ),
                            comment.isEmpty
                                ? Container()
                                : AppWidget().textNormal(
                                    title: comment,
                                    size: 12,
                                    color: AppColor().info,
                                  ),
                            fileWidget!,
                            const SizedBox(height: 22),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              AppWidget().textNormal(
                                title: date,
                                size: 10.5,
                                color: AppColor().info.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ClipPath(
                    clipper: TriangleRightShape(),
                    child: Container(
                      height: 10,
                      width: 10,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          )
        : userId == getStorage.read('username')
            ? Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 40),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(height: 14),
                                Container(
                                  width: 90,
                                ),
                                comment.isEmpty
                                    ? Container()
                                    : AppWidget().textNormal(
                                        title: comment,
                                        size: 12,
                                        color: AppColor().info,
                                      ),
                                fileWidget!,
                                const SizedBox(height: 22),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: AppWidget().textNormal(
                                title: '$progress%',
                                size: 11,
                                color: AppColor().info.withOpacity(0.7),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),
                                  AppWidget().textNormal(
                                    title: date,
                                    size: 10.5,
                                    color: AppColor().info.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ClipPath(
                        clipper: TriangleRightShape(),
                        child: Container(
                          height: 10,
                          width: 10,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : assignerName == username
                ? Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ProfilePicture(
                          name: username,
                          radius: 16,
                          fontsize: 12,
                        ),
                        const SizedBox(width: 4),
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ClipPath(
                            clipper: TriangleLeftShape(),
                            child: Container(
                              height: 10,
                              width: 10,
                              color: AppColor().info,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(right: 40),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor().info,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppWidget().textTitle(
                                            title: username,
                                            size: 13,
                                          ),
                                          const SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                    comment.isEmpty
                                        ? Container()
                                        : AppWidget().textNormal(
                                            title: comment,
                                            size: 12,
                                          ),
                                    fileWidget!,
                                    const SizedBox(height: 16),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: AppWidget().textTitle(
                                    title: date,
                                    size: 10.5,
                                    color: AppColor().primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ProfilePicture(
                          name: username,
                          radius: 16,
                          fontsize: 12,
                        ),
                        const SizedBox(width: 4),
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ClipPath(
                            clipper: TriangleLeftShape(),
                            child: Container(
                              height: 10,
                              width: 10,
                              color: AppColor().info,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(right: 40),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor().info,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppWidget().textTitle(
                                            title: username,
                                            size: 13,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: CircleAvatar(
                                              radius: 2,
                                              backgroundColor:
                                                  AppColor().accent1,
                                            ),
                                          ),
                                          AppWidget().textNormal(
                                            title: '$progress%',
                                            size: 13,
                                            color: AppColor().secondary,
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                    comment.isEmpty
                                        ? Container()
                                        : AppWidget().textNormal(
                                            title: comment,
                                            size: 12,
                                          ),
                                    fileWidget!,
                                    const SizedBox(height: 18),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: AppWidget().textTitle(
                                    title: date,
                                    size: 10.5,
                                    color: AppColor().primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
  }

  // feedback file view item
  feedbackFileItem({
    required String fileName,
    String? userId,
    Function? action,
  }) {
    return userId == getStorage.read('username')
        ? Container(
            margin: const EdgeInsets.only(top: 6),
            alignment: Alignment.centerRight,
            child: TouchRippleEffect(
              onTap: () {
                action!.call();
              },
              rippleColor: Colors.white24,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColor().accent3,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColor().info.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidFileText,
                      color: AppColor().info,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppWidget().textTitle(
                        title: fileName,
                        size: 12,
                        color: AppColor().info,
                        line: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.only(top: 6),
            child: TouchRippleEffect(
              onTap: () {
                action!.call();
              },
              rippleColor: Colors.black26,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColor().accent2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColor().primary.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidFileText,
                      color: AppColor().primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppWidget().textTitle(
                        title: fileName,
                        size: 12,
                        color: AppColor().primary,
                        line: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  // expired token => popup login password
  loginPopup({
    required Function() refreshAction,
  }) {
    final LoginController loginController = Get.find();
    loginController.hidePassExpire = true.obs;

    return customPopup(
      context: Get.context!,
      barrier: false,
      actionTitle: 'Login',
      action: () {
        refreshAction.call();
      },
      widget: Obx(() {
        loginController.emailController.text = '${getStorage.read('username')}';
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            AppWidget().textTitle(
              title: 'Login with',
              size: 20,
            ),
            const SizedBox(height: 12),

            // login textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.alternate_email_rounded,
                      color: AppColor().primaryText,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: loginController.emailController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: AppColor().primaryText,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: AppColor().primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // password textfield
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.password_rounded,
                      color: AppColor().primaryText,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: loginController.passwordController,
                      focusNode: loginController.passwordFocusNode,
                      obscureText: loginController.hidePassExpire.value,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: AppColor().primaryText,
                          fontSize: 14,
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: AppColor().primaryText,
                          fontSize: 14,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor().primaryText,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor().tertiary,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor().error,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor().error,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            loginController.passShowExpire();
                          },
                          focusNode: FocusNode(skipTraversal: true),
                          child: Icon(
                            loginController.hidePassExpire.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColor().primaryText,
                            size: 20,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: AppColor().primaryText,
                        fontSize: 14,
                      ),
                      cursorColor: AppColor().primaryText,
                      onFieldSubmitted: (value) {
                        refreshAction.call();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  // notification badge
  notificationBadge({required int countNotify}) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$countNotify',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  // loading indicator
  loadingIndicator() {
    return Center(
      child: SizedBox(
        width: 120,
        child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotateMultiple,
          strokeWidth: 3,
          colors: [AppColor().info],
        ),
      ),
    );
  }

  // error popup
  errorScackbar({
    String title = 'Something Wrong!',
    String message = 'Please check your internet connection',
  }) {
    return Get.snackbar(
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 5),
      backgroundColor: AppColor().error,
      title,
      message,
      colorText: AppColor().info,
    );
  }

  // success popup
  successScackbar({
    String title = 'Success',
    String message = 'You have been assigned document successfully!',
  }) {
    return Get.snackbar(
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 5),
      backgroundColor: AppColor().success,
      title,
      message,
      colorText: AppColor().info,
    );
  }

  // custom popup
  customPopup({
    required Widget widget,
    required BuildContext context,
    String actionTitle = '',
    bool barrier = true,
    Function()? action,
    double radius = 20,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrier,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          content: SizedBox(
            width: Get.width,
            child: widget,
          ),
          actions: [
            buttonWidget(
              text: actionTitle,
              fontColor: AppColor().info,
              color: AppColor().primary,
              action: () {
                action?.call();
              },
            ),
          ],
        );
      },
    );
  }

  // assign member detail view
  detailAssignMember({
    required String title,
    required String member,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: textTitle(
                  title: title,
                  size: 13,
                  color: AppColor().info,
                ),
              ),
            ],
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 8, 15, 10),
              child: textTitle(
                title: member,
                size: 14,
                color: AppColor().info,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // assign member
  assignMember({
    required String title,
    String option = '(Optional)',
    Function()? action,
    Color color = Colors.white,
    double radius = 12,
    Widget? memberWidget,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: textTitle(
                    title: title,
                    size: 13,
                    color: AppColor().info,
                  ),
                ),
                option == '(Optional)'
                    ? textSubTitle(
                        title: option,
                        size: 12,
                        color: AppColor().info,
                      )
                    : textTitle(
                        title: option,
                        size: 12,
                        color: const Color(0xFFFFB2B4),
                      ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: TouchRippleEffect(
              onTap: () {
                action?.call();
              },
              backgroundColor: color,
              rippleColor: Colors.black26,
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor().primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColor().secondary,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor().info,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(11),
                          topRight: Radius.circular(11),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(15, 8, 12, 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: textNormal(
                                title: 'Select member',
                                color: AppColor().tertiary,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColor().tertiary,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: AppColor().secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 8, 15, 10),
                      child: memberWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // document detail information
  detailInfo({
    required String symbol,
    required String issueDate,
    required String from,
    String? type = 'Proposal',
    String? receiveDate,
    String? title,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor().accent3,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 75,
                      child: textSubTitle(
                        title: 'Doc No :',
                        size: 14,
                        color: AppColor().info,
                      ),
                    ),
                    Expanded(
                      child: textTitle(
                        title: symbol,
                        size: 14,
                        color: AppColor().info,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60,
                      child: textSubTitle(
                        title: 'Title :',
                        size: 14,
                        color: AppColor().info,
                      ),
                    ),
                    Flexible(
                      child: textTitle(
                        title: '$title',
                        size: 14,
                        color: AppColor().info,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                      child: textSubTitle(
                        title: 'Issue Date :',
                        size: 14,
                        color: AppColor().info,
                      ),
                    ),
                    textTitle(
                      title: issueDate,
                      size: 14,
                      color: AppColor().info,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: textSubTitle(
                        title: 'Release Place :',
                        size: 14,
                        color: AppColor().info,
                      ),
                    ),
                    textTitle(
                      title: from,
                      size: 14,
                      color: AppColor().info,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 60,
                          child: textSubTitle(
                            title: 'Type :',
                            size: 14,
                            color: AppColor().info,
                          ),
                        ),
                        textTitle(
                          title: '$type',
                          size: 14,
                          color: AppColor().info,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                      child: textSubTitle(
                        title: 'Receive Date :',
                        size: 14,
                        color: AppColor().info,
                      ),
                    ),
                    textTitle(
                      title: '$receiveDate',
                      size: 14,
                      color: AppColor().info,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // end document detail information

  // history document item
  historyDocItem({
    required String docNumber,
    required String docTitle,
    required String date,
    required String from,
    Function()? action,
    Color color = Colors.white,
    double radius = 16,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
      child: TouchRippleEffect(
        onTap: () {
          action?.call();
        },
        backgroundColor: color,
        rippleColor: Colors.black26,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor().info,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(2, 2),
              )
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 12, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 18, 0),
                            child: FaIcon(
                              FontAwesomeIcons.fileImport,
                              color: AppColor().primary,
                              size: 28,
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppWidget().textNormal(
                                    title: docNumber,
                                    color: AppColor().secondary,
                                    size: 13,
                                  ),
                                  Text(
                                    docTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      textTitle(
                                        title: from,
                                        size: 12,
                                        color: AppColor().primary,
                                      ),
                                      textNormal(
                                        title: date,
                                        size: 12,
                                        color: AppColor().secondaryText,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: AppColor().tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: AppColor().tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColor().primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // end history document item

  // assigned document item
  assignDocItem({
    required String docTitle,
    required String docNumber,
    required String assignDate,
    Function()? action,
    Color color = Colors.white,
    Color? rippleColor,
    double topLeftRad = 16,
    double botLeftRad = 16,
    double topRightRad = 16,
    double botRightRad = 16,
    Color? smallBarColor,
    Widget? more,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
      child: TouchRippleEffect(
        onTap: () {
          action?.call();
        },
        backgroundColor: color,
        rippleColor: rippleColor ?? Colors.black26,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeftRad),
          bottomLeft: Radius.circular(botLeftRad),
          topRight: Radius.circular(topRightRad),
          bottomRight: Radius.circular(botRightRad),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor().info,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(2, 2),
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRad),
              bottomLeft: Radius.circular(botLeftRad),
              topRight: Radius.circular(topRightRad),
              bottomRight: Radius.circular(botRightRad),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 0, 18, 0),
                            child: FaIcon(
                              FontAwesomeIcons.fileImport,
                              color: AppColor().primary,
                              size: 28,
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    docNumber,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor().secondary,
                                    ),
                                  ),
                                  Text(
                                    docTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 8, 0, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        textSubTitle(
                                          title: assignDate,
                                          size: 12,
                                          color: AppColor().secondaryText,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    more ??
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 8),
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: AppColor().tertiary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: AppColor().tertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: smallBarColor ?? AppColor().primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // end assigned document item

  // new document item
  newDocItem({
    required BuildContext context,
    required String title,
    required String docTitle,
    required String docNumber,
    required int countFile,
    required String date,
    Function()? action,
    Color color = Colors.white,
    double radius = 16,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
      child: TouchRippleEffect(
        onTap: () {
          action?.call();
        },
        backgroundColor: color,
        rippleColor: Colors.black26,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: 180,
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor().accent1, AppColor().info],
              stops: const [0, 1],
              begin: const AlignmentDirectional(1, 0.64),
              end: const AlignmentDirectional(-1, -0.64),
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: AppColor().info,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 20, 15, 25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 12, 0),
                            child: FaIcon(
                              FontAwesomeIcons.fileImport,
                              color: AppColor().primary,
                              size: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 2, 0, 0),
                            child: textTitle(
                              title: title,
                              color: AppColor().primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    textNormal(
                      title: docNumber,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor().tertiary,
                      size: 12.5,
                    ),
                    const SizedBox(height: 4),
                    textNormal(
                      title: docTitle,
                      color: AppColor().primary,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                      child: Row(
                        children: [
                          textTitle(
                            title: '$countFile',
                            size: 13,
                            color: AppColor().primary,
                          ),
                          textSubTitle(
                            title: ' Files',
                            size: 13,
                            color: AppColor().primaryText,
                          ),
                        ],
                      ),
                    ),
                    textSubTitle(
                      title: date,
                      size: 12,
                      color: AppColor().primaryText,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // end new document item

  // gridview item
  itemGridView({
    required String title,
    int count = 0,
    Function()? action,
    Color color = Colors.white,
    double radius = 12,
  }) {
    return TouchRippleEffect(
      onTap: () {
        action?.call();
      },
      backgroundColor: color,
      rippleColor: Colors.black26,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor().secondaryBackground,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 16, 10, 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColor().info,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.network(
                              title == 'BIDV'
                                  ? 'https://www.bidc.com.kh/DataFiles/Shared/Mobile/Icon_Edoc/1.png'
                                  : title == 'BIDC'
                                      ? 'https://www.bidc.com.kh/DataFiles/Shared/Mobile/Icon_Edoc/2.jpeg'
                                      : title == 'NBC'
                                          ? 'https://www.bidc.com.kh/DataFiles/Shared/Mobile/Icon_Edoc/3.jpeg'
                                          : 'https://www.bidc.com.kh/DataFiles/Shared/Mobile/bakong/bidc.png',
                            ).image,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Flexible(
                      child: textTitle(
                        title: title,
                        size: 16,
                        color: AppColor().primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    count != 0
                        ? Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColor().error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : Container(),
                    Flexible(
                      child: textSubTitle(
                        title: count <= 1
                            ? '$count New Document'
                            : '$count New Documents',
                        size: 12,
                        color: AppColor().primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // end gridview item

  // custom profile label
  profileLabelForHome({
    String countNotify = '0',
    String? name,
    String? role,
    Function()? profileAction,
    Function()? action,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: AppColor().accent3,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 0, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  child: InkWell(
                    onTap: () {
                      profileAction!.call();
                    },
                    child: ProfilePicture(
                      name: name!,
                      radius: 25,
                      fontsize: 18,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textTitle(
                      title: 'Hello, $name!',
                      size: 16,
                      color: AppColor().info,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: textNormal(
                        title: role!,
                        size: 13,
                        color: AppColor().info,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 24),
              alignment: Alignment.centerRight,
              child: badges.Badge(
                badgeContent: Container(
                  height: 24,
                  width: 24,
                  alignment: Alignment.center,
                  child: AppWidget().textNormal(
                    title: countNotify == '0' ? '' : countNotify,
                    size: 12,
                    color: AppColor().info,
                  ),
                ),
                stackFit: StackFit.passthrough,
                badgeAnimation: const badges.BadgeAnimation.slide(
                  animationDuration: Duration(milliseconds: 300),
                  colorChangeAnimationDuration: Duration(milliseconds: 300),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: countNotify == '0'
                      ? Colors.transparent
                      : AppColor().error,
                  padding: EdgeInsets.zero,
                ),
                child: AppWidget().iconButtonWidget(
                  icon: Icons.notifications_rounded,
                  iconColor: AppColor().info,
                  iconSize: 26,
                  height: 42,
                  width: 42,
                  color: AppColor().accent2.withOpacity(0.3),
                  action: () {
                    action!.call();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  profileLabelForSetting({
    String name = 'Wannakboth',
    String role = 'Member',
    Widget? widget,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 8),
        decoration: BoxDecoration(
          color: AppColor().accent3,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                    child: ProfilePicture(
                      name: name,
                      radius: 25,
                      fontsize: 18,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textTitle(
                        title: 'Hello, $name!',
                        size: 16,
                        color: AppColor().info,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: textNormal(
                          title: role,
                          size: 13,
                          color: AppColor().info,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: widget,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // end custom profile label

  // setting button
  settingButton({
    required String title,
    IconData icon = Icons.settings_outlined,
    Function()? action,
    Widget? widget,
    double radius = 12,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TouchRippleEffect(
        onTap: () {
          action?.call();
        },
        rippleColor: Colors.black26,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor().secondaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        icon,
                        color: AppColor().secondaryText,
                        size: 24,
                      ),
                    ),
                    textNormal(
                      title: title,
                      size: 14,
                    ),
                  ],
                ),
                Container(
                  child: widget,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // custom icon button
  iconButtonWidget({
    required IconData icon,
    required Color iconColor,
    Color? color,
    Function()? action,
    double width = 40,
    double height = 40,
    double iconSize = 24,
    double topPad = 0,
    double bottomPad = 0,
    double leftPad = 0,
    double rightPad = 0,
    double radius = 30,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        leftPad,
        topPad,
        rightPad,
        bottomPad,
      ),
      child: TouchRippleEffect(
        onTap: () {
          action?.call();
        },
        backgroundColor: color,
        rippleColor: Colors.white24,
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
  // end custom icon button

  // custom button
  buttonWidget({
    required String text,
    required Color fontColor,
    required Color color,
    Color rippleColor = Colors.white24,
    Function()? action,
    final route,
    Widget? icon,
    double height = 40,
    double fontSize = 14,
    double topPad = 12,
    double bottomPad = 12,
    double leftPad = 50,
    double rightPad = 50,
    double radius = 8,
    Color borderColor = Colors.transparent,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        leftPad,
        topPad,
        rightPad,
        bottomPad,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            width: 1,
            color: borderColor,
          ),
        ),
        child: TouchRippleEffect(
          onTap: () {
            action?.call();
          },
          backgroundColor: color,
          rippleColor: rippleColor,
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: icon,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: textTitle(
                    title: text,
                    color: fontColor,
                    size: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // end custom button

  // custom short button
  shortButtonWidget({
    required String text,
    required Color fontColor,
    required Color color,
    Color rippleColor = Colors.white24,
    Function()? action,
    Widget? icon,
    double height = 40,
    double fontSize = 14,
    double topPad = 8,
    double bottomPad = 8,
    double leftPad = 12,
    double rightPad = 16,
    double radius = 8,
    Color borderColor = Colors.transparent,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          width: 1,
          color: borderColor,
        ),
      ),
      child: TouchRippleEffect(
        onTap: () {
          action?.call();
        },
        backgroundColor: color,
        rippleColor: rippleColor,
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            leftPad,
            topPad,
            rightPad,
            bottomPad,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: icon,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: textTitle(
                  title: text,
                  color: fontColor,
                  size: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // end custom short button

  // custom back button
  backButton(BuildContext context) {
    return TouchRippleEffect(
      onTap: () {
        Navigator.pop(context);
      },
      backgroundColor: AppColor().accent3,
      rippleColor: Colors.white24,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.chevron_left_rounded,
            color: AppColor().info,
            size: 26,
          ),
        ),
      ),
    );
  }

  // custom icon for button
  iconCustom({
    required IconData icon,
    double size = 24,
    Color color = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, left: 4),
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }

  faIconCustom({
    required IconData icon,
    double size = 18,
    Color color = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, left: 4),
      child: FaIcon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
  // end custom icon for button

  // custom text
  textLargeTitle({
    String title = 'Title',
    double? size = 18,
    Color? color,
    int? line,
  }) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w700,
      ),
      maxLines: line,
    );
  }

  textTitle({
    String title = 'Title',
    double? size = 16,
    Color? color,
    TextOverflow? overflow,
    int? line,
  }) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w500,
        overflow: overflow,
      ),
      maxLines: line,
    );
  }

  textSubTitle({
    String title = 'Sub Title',
    double? size = 13,
    Color? color,
    TextOverflow? overflow,
    int? line,
  }) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w300,
        overflow: overflow,
      ),
      maxLines: line,
    );
  }

  textNormal({
    String title = 'Normal Title',
    double? size = 14,
    Color? color,
    TextOverflow? overflow,
    int? line,
  }) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: size,
        overflow: overflow,
      ),
      maxLines: line,
    );
  }
  // end custom text

  // custom background image
  backgroundImage({
    required Widget child,
  }) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bidc_building_1.jpg'),
            fit: BoxFit.cover),
      ),
      child: child,
    );
  }
  // end custom background image

  // custom new app bar
  newAppBar({
    required String title,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backButton(context),
          textTitle(
            title: title,
            size: 22,
            color: AppColor().info,
          ),
          const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.transparent,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  // appbar 0 height
  AppBar customAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 0,
    );
  }
  // end appbar
}
