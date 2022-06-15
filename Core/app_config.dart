import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String appName;
  final String stagName;
  final String apiBaseUrl;
  final String? demoAccountID;
  final String? demoAccountPwd;

  static const asd = '';
  static const iosAppID = '';
  static const hmsAppID = '';

  const AppConfig({
    Key? key,
    required this.appName,
    required this.stagName,
    required this.apiBaseUrl,
    this.demoAccountID,
    this.demoAccountPwd,
    required Widget child,
  }) : super(key: key, child: child);

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
