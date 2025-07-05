import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


extension AppLocalizationsX on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
}

extension AppLocalizationsExtension on AppLocalizations {
  String getByString(String? key) {
    switch (key){
      case "fifteenMinutesBefore": return fifteenMinutesBefore;
      case "thirtyMinutesBefore": return thirtyMinutesBefore;
      case "oneHourBefore": return oneHourBefore;
      case "twoHoursBefore": return twoHoursBefore;
      case "threeHoursBefore": return threeHoursBefore;
      case "sixHoursBefore": return sixHoursBefore;
      case "eightHoursBefore": return eightHoursBefore;
      case "twelveHoursBefore": return twelveHoursBefore;
      case "oneDayBefore": return oneDayBefore;
      default: return "";
    }
  }
}