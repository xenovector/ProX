import 'package:lottie/lottie.dart';
import '../export.dart';

Widget loader(bool isLoading, String label, {Color color = Colors.white}) {
  return (isLoading
      ? GestureDetector(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black26,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black12),
                      backgroundColor: Colors.black12,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      label,
                      style: TextStyle(color: color),
                    ),
                  ],
                ),
              )),
          onTap: () {},
        )
      : Center());
}

Widget line({double height = 1, Color color = Colors.black26, double vertical = 0, double horizontal = 0}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
    width: double.infinity,
    height: height,
    color: color,
  );
}

Widget themeButton(String text, onTapCallBack,
    {EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 8), double fontSize = 19}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: S.color.main, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))),
    child: Padding(
      padding: padding,
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w600)),
    ),
    onPressed: onTapCallBack,
  );
}

Widget customThemeButton(String text, onTapCallBack,
    {EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
    Color? buttonColor,
    double fontSize = 16.5,
    Color fontColor = Colors.white,
    Color? shadowColor}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        elevation: 5,
        primary: buttonColor ?? S.color.main,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        shadowColor: shadowColor ?? S.color.main),
    child: Padding(
      padding: padding,
      child: Text(text, style: TextStyle(color: fontColor, fontSize: fontSize, fontWeight: FontWeight.w600)),
    ),
    onPressed: onTapCallBack,
  );
}

Widget infinityButton(String text, onTapCallBack,
    {double height = 40,
    double radius = 20,
    Color? buttonColor,
    Color textColor = Colors.black,
    double marginLeft = 0,
    double marginTop = 0,
    double marginRight = 0,
    double marginBottom = 0,
    double fontSize = 15,
    bool needShadow = false}) {
  return InkWell(
    child: Container(
      height: height,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(marginLeft, marginTop, marginRight, marginBottom),
      decoration: BoxDecoration(
        color: buttonColor ?? S.color.main,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: needShadow
            ? [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 3.0,
                  offset: Offset(1.5, 1.5),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w600)),
      ),
    ),
    onTap: () {
      onTapCallBack();
    },
  );
}

Widget customAppBar(String title,
    {bool withBackBtn = false,
    VoidCallback? callback,
    Widget? customBackButton,
    bool alignLeft = true,
    Color fontColor = Colors.black,
    Color backBtnColor = Colors.black,
    double? withProgress,
    Color? progressColor,
    Widget? optionWidget,
    double titleLeft = 10,
    String? fontFamily}) {
  Widget backBtn = withBackBtn
      ? Row(
          children: [
            InkWell(
              child: customBackButton ??
                  Container(
                      padding: EdgeInsets.only(left: 25, right: 10),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: backBtnColor,
                      )),
              onTap: () {
                if (callback == null) {
                  Get.back();
                } else {
                  callback();
                }
              },
            )
          ],
        )
      : Center();
  return Column(
    children: [
      Expanded(
        child: Row(
          children: [
            alignLeft ? backBtn : Expanded(child: backBtn),
            if (alignLeft) SizedBox(width: titleLeft),
            Text(title,
                style: TextStyle(
                    fontFamily: fontFamily,
                    letterSpacing: 2,
                    fontSize: alignLeft ? 24 : 24,
                    fontWeight: alignLeft ? FontWeight.w600 : FontWeight.w600,
                    color: fontColor)),
            Expanded(child: Center()),
            if (optionWidget != null) optionWidget
          ],
        ),
      ),
      withProgress == null
          ? Center()
          : Row(
              children: [
                AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 2,
                    width: Get.width * withProgress,
                    color: progressColor ?? S.color.main)
              ],
            )
    ],
  );
}

/*Widget dropDownWidget(String label, String hint, List<String> list, Function(String) callBack,
    {double width, bool expanded = true, double marginTop = 40, bool enable = true, bool smallerSize = false}) {
  bool isEmpty = label == null;
  Widget textChild = Container(
    height: smallerSize ? 34 : 44,
    child: Row(
      children: <Widget>[
        SizedBox(width: 15),
        expanded
            ? Expanded(
                child: Text(isEmpty ? hint : label,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: smallerSize ? 13 : 15, color: (isEmpty || !enable) ? ThemeColor.disable : Colors.black)),
              )
            : Text(isEmpty ? hint : label,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: smallerSize ? 13 : 15, color: isEmpty ? ThemeColor.disable : Colors.black)),
        Icon(Icons.arrow_drop_down, color: enable ? ThemeColor.main : Colors.grey.withOpacity(0.5), size: smallerSize ? 34 : 40),
        SizedBox(width: 3),
      ],
    ),
  );
  return Container(
      margin: EdgeInsets.only(top: marginTop),
      padding: EdgeInsets.all(5),
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: AbsorbPointer(
        absorbing: !enable,
        child: MenuButton<String>(
          decoration: BoxDecoration(),
          child: textChild,
          items: list,
          itemBuilder: (String value) {
            bool isFirst = list.first == value;
            bool isLast = list.last == value;
            return Container(
              height: smallerSize ? 40 : 50,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: isFirst ? Radius.circular(8) : Radius.zero,
                  topRight: isFirst ? Radius.circular(8) : Radius.zero,
                  bottomLeft: isLast ? Radius.circular(8) : Radius.zero,
                  bottomRight: isLast ? Radius.circular(8) : Radius.zero,
                ),
              ),
              padding: EdgeInsets.only(left: 20, right: 5),
              child: Text(value, textAlign: TextAlign.left, style: TextStyle(fontSize: smallerSize ? 13 : 15)),
            );
          },
          divider: Center(),
          scrollPhysics: AlwaysScrollableScrollPhysics(),
          onItemSelected: (String value) {
            callBack(value);
          },
          itemBackgroundColor: Colors.transparent,
          popupHeight: (list.length > 6 ? ((smallerSize ? 40 : 50) * 6) : list.length * (smallerSize ? 40 : 50)).toDouble(),
        ),
      ));
}*/

Widget spacedRow({Widget? child, double space = 25}) {
  return Row(
    children: [
      SizedBox(width: space),
      Expanded(
        child: child ?? Center(),
      ),
      SizedBox(width: space),
    ],
  );
}

Future<void> showSuccessLottie(String text) async {
  showLottieDialog('assets/lottie/success.json', text);
  await Future.delayed(Duration(milliseconds: 1500));
  Get.back();
  return;
}

Future<void> showFailedLottie(String text) async {
  showLottieDialog('assets/lottie/failed.json', text);
  await Future.delayed(Duration(milliseconds: 1500));
  Get.back();
  return;
}

void showLottieDialog(String lottieURL, String text) {
  Get.dialog(
    Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: Get.width * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(lottieURL, height: 250, repeat: true),
              spacedRow(
                child: Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: S.color.main, fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              /*SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        //side: BorderSide(color: Colors.grey.shade200, width: 0.2),
                        borderRadius: BorderRadius.circular(12.0))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        child: Text('OK',
                            style: TextStyle(color: Colors.white, fontSize: 14))),
                  ],
                ),
                onPressed: () {
                  Get.back();
                },
              ),*/
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
    useSafeArea: false,
    barrierDismissible: true,
  );
}

Widget dialogWidget(String hint, TextEditingController controller,
    {TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    double marginTop = 40,
    void Function(String)? onChanged,
    void Function()? onTap}) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(top: marginTop),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            obscureText: obscureText,
            controller: controller,
            style: TextStyle(fontSize: 16),
            keyboardType: inputType,
            onChanged: onChanged,
            onTap: onTap,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 16, color: S.color.disable),
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 15)),
          ),
        ),
        InkWell(child: Icon(Icons.arrow_drop_down, color: S.color.main, size: 40), onTap: onTap),
        SizedBox(width: 5)
      ],
    ),
  );
}

Widget textWidget(String hint, TextEditingController controller,
    {TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    double marginTop = 20,
    bool enabled = true,
    double opacity = 1,
    Color fontColor = Colors.black,
    double fontSize = 15,
    Color? fontColorDisable,
    void Function(String)? onChanged}) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(top: marginTop, left: marginTop, right: marginTop),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(10),
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.grey.withOpacity(0.5),
      //     spreadRadius: 0,
      //     blurRadius: 8,
      //     offset: Offset(0, 2),
      //   ),
      // ],
    ),
    child: TextField(
      enabled: enabled,
      obscureText: obscureText,
      controller: controller,
      style: TextStyle(fontSize: fontSize, color: enabled ? fontColor : fontColorDisable ?? S.color.disable),
      keyboardType: inputType,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: fontSize, color: fontColorDisable ?? S.color.disable),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
    ),
  );
}

Widget searchWidget(String hint, TextEditingController controller, void Function() onSearch,
    {TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    double marginTop = 20,
    bool enabled = true,
    double opacity = 1,
    Color fontColor = Colors.black,
    double fontSize = 15,
    Color? fontColorDisable,
    void Function(String)? onChanged,
    Function()? onTap}) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(top: marginTop, left: marginTop, right: marginTop),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      enabled: enabled,
      obscureText: obscureText,
      controller: controller,
      style: TextStyle(fontSize: fontSize, color: enabled ? fontColor : fontColorDisable ?? S.color.disable),
      keyboardType: inputType,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onEditingComplete: onSearch,
      onTap: onTap,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: fontSize, color: fontColorDisable ?? S.color.disable),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
    ),
  );
}

Widget passwordWidget(String hint, TextEditingController controller, bool obscureText,
    {TextInputType inputType = TextInputType.text,
    FocusNode? focusNode,
    double marginTop = 20,
    bool enabled = true,
    double opacity = 1,
    Color fontColor = Colors.black,
    Color? fontColorDisable,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    Function()? visibleCallBack}) {
  return Stack(
    children: [
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: marginTop, left: marginTop, right: marginTop),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 0,
          //     blurRadius: 8,
          //     offset: Offset(0, 2),
          //   ),
          // ],
        ),
        child: TextField(
          enabled: enabled,
          obscureText: obscureText,
          obscuringCharacter: '0',
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(fontSize: 15, color: enabled ? fontColor : fontColorDisable ?? S.color.disable),
          keyboardType: inputType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 15, color: fontColorDisable ?? S.color.disable),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20)),
        ),
      ),
      visibleCallBack != null
          ? Positioned(
              top: 0 + marginTop,
              bottom: 0,
              right: 0 + marginTop,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: visibleCallBack,
                ),
              ),
            )
          : Center()
    ],
  );
}

/*Widget formWidget(String hint, TextEditingController controller,
    {TextInputType inputType = TextInputType.text,
    bool obscureText,
    double marginTop = 40,
    bool enabled = true,
    void Function(String) onChanged}) {
  return Stack(
    children: [
      TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'required';
          }
          return null;
        },
        autocorrect: false,
        obscureText: ctrl.visible,
        focusNode: ctrl.passwordNode,
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.visiblePassword,
        onFieldSubmitted: (term) {
          ctrl.btnSignIn.start();
        },
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.left,
        controller: ctrl.passwordTec,
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.white),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.red[200]),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.red),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.white),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 15, 50, 15),
        ),
      ),
      Positioned(
        top: 0,
        bottom: 0,
        right: 3,
        child: IconButton(
          icon: ctrl.visible == true
              ? Icon(
                  Icons.visibility,
                  color: Colors.white,
                )
              : Icon(
                  Icons.visibility_off,
                  color: Colors.white,
                ),
          onPressed: () {
            ctrl.visible = !ctrl.visible;
            ctrl.update();
          },
        ),
      )
    ],
  );
}*/

Widget successTickWidget() {
  return Container(
    margin: EdgeInsets.only(bottom: 25),
    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(36), boxShadow: [
      BoxShadow(
        color: Colors.grey[400]!.withOpacity(0.5),
        spreadRadius: 0,
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ]),
    child: Container(
        height: 60,
        width: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: S.color.tickGreen, borderRadius: BorderRadius.circular(30)),
        child: Image.asset('lib/ProX/Assets/tick.png')),
  );
}


