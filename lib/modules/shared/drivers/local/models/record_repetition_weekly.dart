import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class RecordRepetitionWeekly extends Defs {
  int? recordRepetitionId;
  List<int?>? daysOfWeek;

  RecordRepetitionWeekly({
    super.id,
    super.serverId,
    this.recordRepetitionId,
    this.daysOfWeek
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'server_id': serverId,
    'record_repetition_id': recordRepetitionId,
    'days_of_week': daysOfWeek?.join(", "),
  };

  @override
  String toString() => Convertions.classToString("Record Repetition Weekly", toMap());
}