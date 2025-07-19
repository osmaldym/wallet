import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

enum RRFor { ever, date, toTimes }
enum RepeatEvery { once, day, week, month, anual }

class RecordRepetition extends Defs {
  /// Every x days | years
  int? timesPlaced;
  RRFor? rrFor;
  DateTime? forDate;
  RepeatEvery? repeatEvery;
  /// X Times
  int? repeatedTimes;

  RecordRepetition({
    super.id,
    super.serverId,
    this.timesPlaced,
    this.rrFor,
    this.forDate,
    this.repeatEvery,
    this.repeatedTimes,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'server_id': serverId,
    'times_placed': timesPlaced,
    'for': rrFor?.index,
    'for_date': forDate?.toIso8601String(),
    'repeat_every': repeatEvery?.index,
    'repeated_times': repeatedTimes,
  };

  @override
  String toString() => Convertions.classToString("Record Repetition", toMap());
}