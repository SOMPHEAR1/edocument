import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/dismiss_keyboad.dart';
import '../../widget/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.put(LoginController());
  bool isButtonClicked = false;

  @override
  void initState() {
    super.initState();
    Get.put(LoginController());
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
  }

  @override
  Widget build(BuildContext context) {
    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: buildLoginContent(),
        ),
      ),
    );
  }

  Widget buildLoginContent() {
    return Obx(() {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/bidc_logo_white.png',
                width: Get.width * 0.55,
              ),
              const SizedBox(height: 12),
              AppWidget().textTitle(
                title: 'E-DOCUMENT',
                size: 20,
                color: AppColor().info,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 32),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor().accent3,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        loginLabel(),
                        emailTextField(),
                        passwordTextField(),
                      ],
                    ),
                  ),
                ),
              ),
              AppWidget().buttonWidget(
                text: 'Login',
                fontColor: AppColor().info,
                color: isButtonClicked
                    ? AppColor().info.withOpacity(0.5)
                    : AppColor().tertiary,
                borderColor: AppColor().info,
                radius: 30,
                action: isButtonClicked
                    ? null
                    : () {
                        if (!isButtonClicked) {
                          submitData();
                        }
                      },
              ),
              SizedBox(height: Get.height * 0.12),
            ],
          ),
        ),
      );
    });
  }

  Widget loginLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppWidget().textTitle(
        title: 'Login',
        size: 24,
        color: AppColor().info,
      ),
    );
  }

  void submitData() async {
    setState(() {
      isButtonClicked = true;
    });
    EasyLoading.show(status: 'Loading...');
    await loginController.submitData();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      EasyLoading.dismiss();
      setState(() {
        isButtonClicked = false;
      });
    }
  }

  emailTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.alternate_email_rounded,
              color: AppColor().info,
              size: 24,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: loginController.emailController,
              focusNode: loginController.emailFocusNode,
              obscureText: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().info,
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
              ),
              style: TextStyle(
                color: AppColor().info,
                fontSize: 14,
              ),
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(loginController.passwordFocusNode);
              },
            ),
          ),
        ],
      ),
    );
  }

  passwordTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.password_rounded,
              color: AppColor().info,
              size: 24,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: loginController.passwordController,
              focusNode: loginController.passwordFocusNode,
              obscureText: !loginController.hidePass.value,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().info,
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
                  onTap: () => loginController.passShow(),
                  focusNode: FocusNode(skipTraversal: true),
                  child: Icon(
                    loginController.hidePass.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColor().primaryBackground,
                    size: 20,
                  ),
                ),
              ),
              style: TextStyle(
                color: AppColor().info,
                fontSize: 14,
              ),
              cursorColor: AppColor().info,
              onFieldSubmitted: (value) {
                loginController.passwordFocusNode.unfocus();
                if (!isButtonClicked) {
                  submitData();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
