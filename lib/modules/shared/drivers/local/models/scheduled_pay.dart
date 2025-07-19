import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

enum ScheduledPayTypes { expend, income }

class ScheduledPay extends Defs{
  int? imageId;
  int? userId;
  int? categoryId;
  int? budgetId;
  int? goalId;
  int? frecuencyId;
  int? paymentMethodId;
  int? notificationId;
  int? accountId;
  int? currencyId;
  int? type;
  String? title;
  bool? automatic;
  double? amount;
  DateTime? date;
  String? note;
  String? beneficiary;

  ScheduledPay({
    super.id,
    super.serverId,
    this.userId,
    this.imageId,
    this.categoryId,
    this.accountId,
    this.budgetId,
    this.goalId,
    this.frecuencyId,
    this.paymentMethodId,
    this.notificationId,
    this.currencyId,
    this.type,
    this.title,
    this.automatic,
    this.amount,
    this.date,
    this.note,
    this.beneficiary,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'user_id': userId,
    'server_id' : serverId,
    'image_id': imageId,
    'category_id': categoryId,
    'account_id': accountId,
    'budget_id': budgetId,
    'goal_id': goalId,
    'frecuency_id': frecuencyId,
    'payment_method_id': paymentMethodId,
    'notification_id': notificationId,
    'type': type,
    'title': title,
    'automatic': automatic!.boolToInt(),
    'amount': amount,
    'date': date!.toIso8601String(),
    'note': note, 
    'beneficiary': beneficiary,
    'currency_id': currencyId,
  };

  @override
  String toString() {
    return Convertions.classToString("ScheduledPay", toMap());
  }
}