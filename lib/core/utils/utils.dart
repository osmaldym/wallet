import 'package:flutter/material.dart';

class Utils {
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
}