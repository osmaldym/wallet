import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTheme {
  final BuildContext context;
  const AppTheme(this.context);
  static AppTheme of(BuildContext context) => AppTheme(context);

  static ThemeMode themeMode = ThemeMode.system;

  bool get isThemeDark { 
    if (themeMode == ThemeMode.system) 
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    return themeMode == ThemeMode.dark;
  }

  Color get seedBgColor {
    return Theme.of(context).colorScheme.surface;
  }

  Color get textContrast {
    return isThemeDark ? Color(0xFFFFFFFFF) : textBlack;
  }
  
  Color get bgOfBottomSheet {
    // If i want to use the mode dark or light, i discomment the lines below
    // Brightness mode = MediaQuery.of(context).platformBrightness;
    // if (mode == Brightness.light) return Colors.black; // Is an example
    return Colors.transparent;
  }

  Color get primary {
    return const Color.fromRGBO(255, 216, 78, 1);
  }

  Color get contrast {
    return const Color.fromRGBO(0, 0, 0, 1);
  }

  Color get textBlack { return contrast; }

  Color get yellowBlack {
    return const Color.fromRGBO(169, 132, 0, 1);
  }

  Color get textYellow { return yellowBlack; }

  Color get greenLight {
    return const Color.fromRGBO(174, 255, 160, 1);
  }

  Color get greenDark {
    return const Color.fromRGBO(10, 69, 0, 1);
  }

  Color get textGreen { return greenDark; }

  Color get redLight {
    return const Color.fromRGBO(137, 0, 0, 1);
  }

  Color get textRed { return redLight; }

  Color get redDark {
    return const Color.fromRGBO(34, 0, 0, 1);
  }

  Color get textRedDark { return redDark; }
}