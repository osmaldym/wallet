import 'package:flutter/material.dart';

/// Controller to notify a widgwt when the Locale is changed.
class LocaleNotifier extends ChangeNotifier {
  /// Shorthand to call `notifyListeners()`
  void notify() => notifyListeners();
}