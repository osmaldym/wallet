import 'package:flutter/widgets.dart';
import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart';
import 'package:wallet/modules/shared/drivers/local/models/currency.dart';
import 'package:wallet/modules/shared/drivers/local/models/notifications.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/subcategories.dart';

class RelatedScheduledPay extends ScheduledPay {
  Account? account;
  Subcategories? subcategory;
  Currency? currency;
  RelatedRecordRepetition? frecuency;
  IconData? image;
  Notifications? notification;

  RelatedScheduledPay({
    super.id,
    super.serverId,
    super.title,
    super.automatic,
    super.amount,
    super.beneficiary,
    super.date,
    super.type,
    super.note,
    super.completedPay,
    this.account,
    this.subcategory,
    this.currency,
    this.frecuency,
    this.image,
    this.notification
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'title': title,
      'automatic': automatic,
      'amount': amount,
      'beneficiary': beneficiary,
      'date': date,
      'type': type,
      'note': note,
      'account': account,
      'subcategory': subcategory,
      'currency': currency,
      'frecuency': frecuency,
      'image': image,
      'notification': notification,
      'completed_pay': completedPay!.boolToInt(),
    };
  }

  @override
  String toString() => Convertions.classToString("ScheduledPayRelated", toMap());
}