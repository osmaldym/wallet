import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Record extends Defs {
  int? scheduledPayId;
  DateTime? date;
  DateTime? datePaid;
  double? amount;
  double? balance;
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
    this.balance,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'server_id': serverId,
    'scheduled_pay_id': scheduledPayId,
    'date': date?.microsecondsSinceEpoch,
    'date_paid': datePaid?.microsecondsSinceEpoch,
    'amount': amount,
    'balance': balance,
    'paid': paid.boolToIntOrNull(),
    'expired': expired.boolToIntOrNull(),
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