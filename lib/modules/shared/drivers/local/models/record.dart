import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Record extends Defs {
  int? scheduledPayId;
  DateTime? date;
  DateTime? datePaid;
  double? amount;
  bool? paid;
  bool? expired;

  Record({
    super.id,
    super.serverId,
    this.scheduledPayId,
    this.date,
    this.paid,
    this.expired,
    this.amount,
    this.datePaid,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'server_id': serverId,
    'scheduled_pay_id': scheduledPayId,
    'date': date?.microsecondsSinceEpoch,
    'date_paid': datePaid?.microsecondsSinceEpoch,
    'amount': amount,
    'paid': paid.boolToInt(),
    'expired': expired.boolToInt(),
  };

  Map<String, Object?> toCleanMap({ bool? zeroToNull = false }) {
    Map<String, Object?> map = toMap();

    if (zeroToNull ?? false)
      for (final entry in map.entries)
        if (entry.value == 0) map[entry.key] = null;

    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return Convertions.classToString("Record", toMap());
  }
}