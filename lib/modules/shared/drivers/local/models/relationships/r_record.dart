import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/record.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_scheduled_pay.dart';

class RelatedRecord extends Record {
  RelatedScheduledPay? scheduledPay;

  RelatedRecord({
    super.id,
    super.serverId,
    super.date,
    super.datePaid,
    super.expired,
    super.paid,
    super.amount,
    super.balance,
    this.scheduledPay,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'date': date,
      'date_paid': datePaid,
      'amount': amount,
      'balance': balance,
      'expired': expired,
      'paid': paid,
      'scheduled_pay': scheduledPay,
    };
  }

  @override
  String toString() => Convertions.classToString("RelatedRecord", toMap());
}