import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/extensions/datetime_ext.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';

class Utils {
  final DateFormat _readableDateFormat = DateFormat("dd/MM/yyyy");
  final DateFormat _readableTimeFormat = DateFormat("hh:mm a");

  /// Converts a DateTime with TimeOfDay
  /// 
  /// if [datetime] doesn't passed it returns null
  /// 
  /// if [time] doesn't passed it returns a datetime at 0 hours
  DateTime? toDateTime(DateTime? datetime, [TimeOfDay? time]) {
    if (datetime == null) return null;
    time ??= const TimeOfDay(hour: 0, minute: 0);
    return DateTime(datetime.year, datetime.month, datetime.day, time.hour, time.minute);
  }

  String toReadableRelativeDate(DateTime datetime, BuildContext context) {
    datetime = datetime.recreateInTimeZero();
    DateTime today = DateTime.now().recreateInTimeZero();
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime tomorrow = today.add(const Duration(days: 1));

    if (datetime.isAtSameMomentAs(today)) return context.l10n!.today;
    else if (datetime.isAtSameMomentAs(yesterday)) return context.l10n!.yesterday;
    else if (datetime.isAtSameMomentAs(tomorrow)) return context.l10n!.tomorrow;
    else return toReadableDate(datetime);
  }

  String toReadableDate(DateTime datetime) => _readableDateFormat.format(datetime);

  String toReadableDateTime(DateTime datetime) => "${_readableDateFormat.format(datetime)} ${_readableTimeFormat.format(datetime)}";

  String toReadableTime(DateTime datetime) => _readableTimeFormat.format(datetime);

  bool? intToBool(int? number) => number != null ? number > 0 ? true : false : null;

  int getWeekPositionInMonth(DateTime datetime) { 
    return ((datetime.day / 7) is int ? (datetime.day / 7) : (datetime.day / 7) + 1).toInt();
  }

  bool isLastDayOfMonth(DateTime datetime){
    return DateTime(datetime.year, datetime.month, datetime.day + 1).day == 1;
  }

  void showSnackBarMessage(BuildContext context, String text, { bool? error }) {
    Color color = error ?? false ? AppTheme.of(context).redContrast : AppTheme.of(context).contrast;

    WidgetsBinding.instance.addPostFrameCallback((_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: (error ?? false ? Colors.red : AppTheme.of(context).contrast).withAlpha(30),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Icon(
                error ?? false ? Icons.error_outline : Icons.info_outline,
                color: color,
              ),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    color: color,
                  ),
                ),
              )
            ],
          )
        )
      )
    );
  }
}