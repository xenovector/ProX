import 'package:flutter/material.dart';

/// Environment Type:
/// PRD = Production
/// UAT = User Acceptance Test
/// STG = Staging
enum Environment { PRD, UAT, STG, DEV }

class AppConfig extends InheritedWidget {
  final String appName;
  final Environment environment;
  final String apiBaseUrl;
  final String? demoAccountID;
  final String? demoAccountPwd;

  static const asd = '';
  static const iosAppID = '';
  static const hmsAppID = '';

  bool get isPRD => environment == Environment.PRD;
  bool get isUAT => environment == Environment.UAT;
  bool get isSTG => environment == Environment.STG;
  bool get isDEV => environment == Environment.DEV;

  const AppConfig({
    Key? key,
    required this.appName,
    required this.environment,
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
