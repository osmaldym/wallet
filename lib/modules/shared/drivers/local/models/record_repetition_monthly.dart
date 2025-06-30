import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class RecordRepetitionMonthly extends Defs {
  int? recordRepetitionId;
  bool? sameDayOfMonth;
  bool? everyLastDayOfMonth;
  int? everyNumberDay;
  int? weekNumber;

  RecordRepetitionMonthly({
    super.id,
    super.serverId,
    this.recordRepetitionId,
    this.sameDayOfMonth,
    this.everyLastDayOfMonth,
    this.everyNumberDay,
    this.weekNumber
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'record_repetition_id': recordRepetitionId,
      'same_day_of_month': sameDayOfMonth,
      'every_last_day_of_month': everyLastDayOfMonth,
      'every_number_day': everyNumberDay,
      'week_number': weekNumber,
    };
  }

  @override
  String toString() => Convertions.classToString("RecordRepetitionMonthly", toMap());
}