import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sprintf/sprintf.dart';
import '../Helper/sizer.dart';
import '../i18n/language_key.dart';

extension MapDynamicValueToString on Map<String, dynamic> {
  Map<String, String> toMapString() {
    Map<String, String> szMap = {};
    forEach((key, value) {
      if (value is String) {
        szMap[key] = value.replaceAll("\\n", '\n');
      } else {
        print('invalid value of key from toMapString: $key, value: ${value.toString()}');
      }
    });
    return szMap;
  }

  Map<String, dynamic> get checkIsArrayEmpty {
    Map<String, dynamic> thisMap = this;
    thisMap.forEach((key, value) {
      if (value is List) {
        //print('key: $key, value: $value');
        if (value.isEmpty) {
          thisMap[key] = null;
        }
      }
    });
    return thisMap;
  }
}

extension EmptyValueInMap on Map<String, dynamic>? {
  Map<String, dynamic> get checkIsArrayEmpty {
    if (this == null) return {};
    Map<String, dynamic> thisMap = this!;
    thisMap.forEach((key, value) {
      if (value is List) {
        //print('key: $key, value: $value');
        if (value.isEmpty) {
          thisMap[key] = null;
        }
      }
    });
    return thisMap;
  }
}

extension DynamicListToStringList on List<dynamic> {
  List<String> toStringList() {
    List<String> list = [];
    for (var item in this) {
      if (item is String) {
        list.add(item);
      } else {
        list.add(item.toString());
      }
    }
    return list;
  }
}

extension ProXFile on File {
  String get name {
    return basename(path);
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension ProXInt on int {
  bool startsWith(int value) {
    return toString().startsWith('$value');
  }

  bool endsWith(int value) {
    return toString().endsWith('$value');
  }

  String get withCurrency => sprintf(L.Currency_Value.tr, [this]);

  double get wpx => (this / Sizer.designWidth).w;
  double get hpx => (this / Sizer.designHeight).h;
}

extension ProXDouble on double {
  bool inTheRange({required double d1, required double d2, String debugName = ''}) {
    bool inRange = this > d1 && this < d2;
    if (debugName != '' && !inRange) {
      if (this > d1) {
        print('$debugName Not In Range: exceed d2 ${this - d2}');
      } else if (this < d2) {
        print('$debugName Not In Range: below d1 ${d1 - this}');
      } else {
        print('$debugName Something wrong: this:$this, d1: $d1, d2: $d2');
      }
    }
    return inRange;
  }

  String roundOff(int digit) {
    int rounded = round();
    int totalDigits = rounded.toString().length;
    num dd = pow(10, totalDigits - 1);
    String sz = (rounded / dd).toStringAsFixed(digit - 1);
    double dAnswer = (double.tryParse(sz) ?? 0) * dd;
    return dAnswer.toStringAsFixed(0);
  }

  String get readableFormat {
    return NumberFormat.compact().format(this);
  }

  String get withCurrency => sprintf(L.Currency_Value.tr, [this]);

  bool get isUltraWide => this > 1200;
  bool get isWide => this > 600;

  /// value provided multiple device width.
  double get w => this * Get.width;

  /// value provided multiple device height.
  double get h => this * Get.height;

  /// value provided multiple designed device width to makes others device follow the ratio.
  double get wpx => (this / Sizer.designWidth).w;

  /// value provided multiple designed device height to makes others device follow the ratio.
  double get hpx => (this / Sizer.designHeight).h;
}

extension ProXString on String {
  String toFirstUpperCaseOnly() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String lowerCaseAMPM() {
    return replaceAll('PM', 'pm').replaceAll('AM', 'am');
  }

  /// ```dart
  /// if (this == '') return true;
  /// return false;
  /// ```
  bool get isEmptyOrNull {
    if (this == '') return true;
    return false;
  }

  String? get getEmptyOrNull {
    if (this == '') return null;
    return this;
  }

  bool isPasswordCompliant([int minLength = 8]) {
    if (this == '') return false;

    bool hasUppercase = contains(RegExp(r'[A-Z]'));
    bool hasDigits = contains(RegExp(r'[0-9]'));
    bool hasLowercase = contains(RegExp(r'[a-z]'));
    //bool hasSpecialCharacters = this.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = length >= minLength;

    return hasDigits & hasUppercase & hasLowercase /*& hasSpecialCharacters*/ & hasMinLength;
  }

  bool get containSymbol {
    return contains(RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:：，。～、！@；？：“”_~`+=（）  ' // <-- Notice the escaped symbols
        "'" // <-- ' is added to the expression
        ']'));
  }

  /*bool isEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(this)) ? false : true;
  }*/
}

extension ProXNullableString on String? {
  String toFirstUpperCaseOnly() {
    return "${this?[0].toUpperCase()}${this?.substring(1).toLowerCase()}";
  }

  String? lowerCaseAMPM() {
    if (this == null || this == '') return this;
    return this!.replaceAll('PM', 'pm').replaceAll('AM', 'am');
  }

  /// ```dart
  /// if (this == null || this == '') return true;
  /// return false;
  /// ```
  bool get isEmptyOrNull {
    if (this == null || this == '') return true;
    return false;
  }

  String? get getEmptyOrNull {
    if (this == null || this == '') return null;
    return this;
  }

  bool isPasswordCompliant([int minLength = 8]) {
    if (this == null || this == '') return false;

    bool hasUppercase = this!.contains(RegExp(r'[A-Z]'));
    bool hasDigits = this!.contains(RegExp(r'[0-9]'));
    bool hasLowercase = this!.contains(RegExp(r'[a-z]'));
    //bool hasSpecialCharacters = this.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = this!.length >= minLength;

    return hasDigits & hasUppercase & hasLowercase /*& hasSpecialCharacters*/ & hasMinLength;
  }

  bool isEmail() {
    if (this == null || this == '') return false;
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(this!)) ? false : true;
  }

  bool get containSymbol {
    if (this == null || this == '') return false;
    return this!.contains(RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:：，。～、！@；？：“”_~`+=（）  ' // <-- Notice the escaped symbols
        "'" // <-- ' is added to the expression
        ']'));
  }
}
