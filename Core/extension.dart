import 'dart:ui';

extension MapDynamicValueToString on Map<String, dynamic> {
  Map<String, String> toMapString() {
    Map<String, String> _szMap = {};
    this.forEach((key, value) {
      if (value is String) {
        _szMap[key] = value.replaceAll("\\n", '\n');
      } else {
        print('invalid value of key from toMapString: $key, value: ${value.toString()}');
      }
    });
    return _szMap;
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
    return this.toString().startsWith('$value');
  }

  bool endsWith(int value) {
    return this.toString().endsWith('$value');
  }
}

extension ProXString on String {
  String lowerCaseAMPM() {
    return this.replaceAll('PM', 'pm').replaceAll('AM', 'am');
  }

  /// ```dart
  /// if (this == '') return true;
  /// return false;
  /// ```
  bool get isEmptyOrNull {
    if (this == '') return true;
    return false;
  }

  String? get reEmptyOrNull {
    if (this == '') return null;
    return this;
  }

  bool isPasswordCompliant([int minLength = 8]) {
    if (this == '') return false;

    bool hasUppercase = this.contains(RegExp(r'[A-Z]'));
    bool hasDigits = this.contains(RegExp(r'[0-9]'));
    bool hasLowercase = this.contains(RegExp(r'[a-z]'));
    //bool hasSpecialCharacters = this.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = this.length >= minLength;

    return hasDigits & hasUppercase & hasLowercase /*& hasSpecialCharacters*/ & hasMinLength;
  }

  /*bool isEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(this)) ? false : true;
  }*/
}

extension ProXNullableString on String? {
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

  String? get reEmptyOrNull {
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
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(this!)) ? false : true;
  }
}