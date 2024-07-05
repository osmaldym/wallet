import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTheme {
  final BuildContext context;
  const AppTheme(this.context);
  static AppTheme of(BuildContext context) => AppTheme(context);

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