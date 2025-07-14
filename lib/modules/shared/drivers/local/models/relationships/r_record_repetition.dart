import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_monthly.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_weekly.dart';

class RelatedRecordRepetition extends RecordRepetition {
  RecordRepetitionMonthly? recordRepetitionMonthly;
  RecordRepetitionWeekly? recordRepetitionWeekly;

  RelatedRecordRepetition({
    super.id,
    super.serverId,
    super.forDate,
    super.repeatEvery,
    super.rrFor,
    super.repeatedTimes,
    super.timesPlaced,
    this.recordRepetitionMonthly,
    this.recordRepetitionWeekly
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'repeat_every': repeatEvery,
      'for': rrFor,
      'for_date': forDate,
      'repeated_times': repeatedTimes,
      'times_placed': timesPlaced,
      'record_repetition_monthly': recordRepetitionMonthly,
      'record_repetition_weekly': recordRepetitionWeekly,
    };
  }

  @override
  String toString() => Convertions.classToString("RelatedRecordRepetition", toMap());
}