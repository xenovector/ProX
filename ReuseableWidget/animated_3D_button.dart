import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../Helper/hotkey.dart';

class Animated3DButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Image? image;
  final double height;
  final double width;
  final double? radius;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isActive;
  final Color textColor;
  final Color? buttonColor;
  final Color? shadowColor;
  final Color? borderColor;
  final bool invisible;
  final double pressableHeight;

  const Animated3DButton(this.text,
      {required this.onPressed,
      this.image,
      this.height = 44,
      this.width = double.infinity,
      this.radius,
      this.fontSize = 17,
      this.fontWeight = FontWeight.w500,
      this.isActive = true,
      this.textColor = Colors.white,
      this.buttonColor,
      this.shadowColor,
      this.borderColor,
      this.invisible = false,
      this.pressableHeight = 4});

  @override
  Animated3DButtonState createState() => Animated3DButtonState();
}

class Animated3DButtonState extends State<Animated3DButton> {
  final animateDuration = Duration(milliseconds: 30);
  double shadowHeight = 4;
  double position = 4;

  List<double> taskList = [];
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    shadowHeight = widget.pressableHeight;
    position = widget.pressableHeight;
  }

  Future<void> animate() async {
    if (isAnimating) return;
    bool haveTask = taskList.isNotEmpty;
    if (haveTask) {
      isAnimating = true;
      setState(() {
        position = taskList[0];
      });
      await Future.delayed(animateDuration);
      taskList.removeAt(0);
      isAnimating = false;
      return animate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = widget.height + 4 - shadowHeight;
    return InkWell(
      onTapUp: (_) async {
        taskList.add(shadowHeight);
        await animate();
        widget.onPressed();
      },
      onTapDown: (_) {
        taskList.add(0);
        animate();
      },
      onTapCancel: () {
        taskList.add(shadowHeight);
        animate();
      },
      child: SizedBox(
        height: buttonHeight + shadowHeight,
        width: widget.width,
        child: Stack(
          children: [
            // Shadow
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: buttonHeight,
                decoration: BoxDecoration(
                  color: widget.invisible
                      ? Colors.transparent
                      : widget.isActive
                          ? widget.shadowColor ?? S.color.themeMainShadow
                          : S.color.themeTitleColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.radius ?? buttonHeight / 2),
                  ),
                ),
              ),
            ),
            // Button
            AnimatedPositioned(
              curve: Curves.easeIn,
              bottom: position,
              left: 0,
              right: 0,
              duration: animateDuration * 1.5,
              child: Container(
                height: buttonHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widget.invisible
                      ? Colors.transparent
                      : widget.isActive
                          ? widget.buttonColor ?? S.color.themeMainLight
                          : S.color.themeTextColor,
                  border: Border.all(
                      color: widget.invisible
                          ? Colors.transparent
                          : widget.isActive
                              ? widget.borderColor ?? S.color.themeMainLight
                              : S.color.themeTextColor,
                      width: 1.2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.radius ?? buttonHeight / 2),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
                child: Center(
                  child: widget.image ??
                      AutoSizeText(
                        widget.text,
                        style: TextStyle(
                            color: widget.invisible ? Colors.grey[700] : widget.textColor,
                            fontSize: widget.fontSize,
                            fontWeight: widget.fontWeight),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
