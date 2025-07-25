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
    'date': date?.toIso8601String(),
    'date_paid': datePaid?.toIso8601String(),
    'amount': amount,
    'paid': paid.boolToInt(),
    'expired': expired.boolToInt(),
  };

  Map<String, Object?> toCleanMap() {
    Map<String, Object?> map = toMap();
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString() {
    return Convertions.classToString("Record", toMap());
  }
}