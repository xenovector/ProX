import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:prox/ProX/export.dart';

class LoginPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginPageController());
  }
}

class LoginPageController extends ProXController with SingleGetTickerProviderMixin {
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  AnimationController? lottieCtrl;
  bool visible = false;

  @override
  void onInit() {
    super.onInit();
  }

  void login() async {
    //
  }

  void forgotPassword() {
    print('forgot password');
  }

  void register() {
    print('Join Now');
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProXWidget<LoginPageController>(
        child: GetBuilder<LoginPageController>(
            builder: (ctrl) => Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(L.Login_Welcome.tr,
                        style: TextStyle(
                            color: ThemeColor.text_color_contrast, fontSize: 20, fontWeight: FontWeight.bold)),
                    // Padding(
                    //     padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 12),
                    //     child: Container(height: 1, width: double.infinity, color: ThemeColor.main)),
                    SizedBox(height: 10),
                    Text(L.Login_Des.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: ThemeColor.text_color_contrast)),
                    SizedBox(height: 10),
                    textWidget(L.Login_Email_Hints, ctrl.emailTEC,
                        opacity: .37,
                        fontColor: ThemeColor.text_color_contrast,
                        fontColorDisable: ThemeColor.text_color_contrast.withOpacity(.59),
                        inputType: TextInputType.emailAddress),
                    Stack(
                      children: [
                        textWidget(
                          L.Login_Password_Hints,
                          ctrl.passwordTEC,
                          opacity: .37,
                          fontColor: ThemeColor.text_color_contrast,
                          fontColorDisable: ThemeColor.text_color_contrast.withOpacity(.59),
                          obscureText: !ctrl.visible,
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 20,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                            child: IconButton(
                              icon: ctrl.visible == true
                                  ? Icon(
                                      Icons.visibility,
                                      color: ThemeColor.text_color_contrast.withOpacity(.59),
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: ThemeColor.text_color_contrast.withOpacity(.59),
                                      size: 20,
                                    ),
                              onPressed: () {
                                ctrl.visible = !ctrl.visible;
                                ctrl.update();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(children: [
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                          child: Text(L.Login_Forget_Password.tr,
                              style: TextStyle(fontSize: 12, color: ThemeColor.text_color_contrast)),
                          onTap: ctrl.forgotPassword)
                    ]),
                    SizedBox(height: 50),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 70),
                        width: double.infinity,
                        child: themeButton(L.Login_Btn_Login.tr, ctrl.login, fontSize: 15)),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(L.Login_Not_Member.tr,
                            style: TextStyle(fontSize: 12, color: ThemeColor.text_color_contrast)),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                            child: Text(L.Login_Btn_Join_Now.tr,
                                style: TextStyle(fontSize: 12, color: ThemeColor.main)),
                            onTap: ctrl.register),
                      ],
                    ),
                  ],
                ))));
  }
}
