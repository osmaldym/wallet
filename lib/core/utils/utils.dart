import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
}