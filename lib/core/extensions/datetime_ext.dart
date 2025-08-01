import 'package:flutter/material.dart';

extension DatetimeExt on DateTime {
  int getWeekPositionInMonth() => ((day / 7) is int ? (day / 7) : (day / 7) + 1).toInt();

  /// Returns a new DateTime istance with the datetime data added and the data of the last DateTime not added
  DateTime addx({ int? years, int? months, int? days, int? hours, int? minutes, int? seconds, int? milliseconds, int? microseconds }) {
    return DateTime(
      year + (years ?? 0),
      month + (months ?? 0),
      day + (days ?? 0),
      hour + (hours ?? 0),
      minute + (minutes ?? 0),
      second + (seconds ?? 0),
      millisecond + (milliseconds ?? 0),
      microsecond + (microseconds ?? 0),
    );
  }

  TimeOfDay getTimeOfDay() => TimeOfDay(hour: hour, minute: minute);

  DateTime setTimeOfDay(TimeOfDay timeOfDay) => recreate(hour: timeOfDay.hour, minute: timeOfDay.minute);

  /// Returns a new DateTime istance with the datetime data replaced and the data of the last DateTime not replaced
  DateTime recreate({ int? year, int? month, int? day, int? hour, int? minute, int? second, int? millisecond, int? microsecond }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// Returns a new DateTime istance with the datetime data replaced and the data of the last DateTime not replaced
  DateTime recreateInTimeZero() => recreate(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
}