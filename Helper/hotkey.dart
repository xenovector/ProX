// For Styles
import '../Theme/color.dart';
import '../Theme/decoration.dart';
import '../Theme/shadow.dart';
import '../Theme/text.dart';

// For Utilities
import '../Utilities/date.dart';
import '../Utilities/show.dart';
import '../Utilities/map.dart';
import '../Utilities/general.dart';

// S stands for Styles.
class S {
  static final color = StyleColor();
  static final decoration = StyleDecoration();
  static final shadow = StyleShadow();
  static final text = StyleText();
}

// U stands for Utilities
class U {
  static final date = UtilsDate();
  static final show = UtilsShow();
  static final map = UtilsMap();
  static final general = UtilsGeneral();
}