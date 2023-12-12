import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'prox_controller.dart';

abstract class ProXWidget<T extends ProXController> extends StatelessWidget {
  T get c => Get.find<T>();

  String get routeName;
}

class ProXDebugWidget extends StatelessWidget {
  final Widget child;
  final Color color;
  const ProXDebugWidget({required this.child, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: child,
    );
  }
}

class ProXWorkInProgressWidget extends StatelessWidget {
  final String text;
  const ProXWorkInProgressWidget({this.text = 'Work In Progress...'});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.network('https://assets2.lottiefiles.com/packages/lf20_8uHQ7s.json', width: 300, reverse: true),
        SizedBox(height: 20),
        Text(text),
      ],
    ));
  }
}
