import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

enum ScheduledPayTypes { expend, income }

class ScheculedPay extends Defs{
  int? imageId;
  int? userId;
  int? categoryId;
  int? budgetId;
  int? goalId;
  int? frecuencyId;
  int? paymentMethodId;
  int? notificationId;
  int? type;
  String? title;
  double? amount;
  DateTime? date;
  String? note;
  String? beneficiary;

  ScheculedPay({
    super.id,
    super.serverId,
    this.userId,
    this.imageId,
    this.categoryId,
    this.budgetId,
    this.goalId,
    this.frecuencyId,
    this.paymentMethodId,
    this.notificationId,
    this.type,
    this.title,
    this.amount,
    this.date,
    this.note,
    this.beneficiary,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'server_id' : serverId,
      'image_id': imageId,
      'category_id': categoryId,
      'budget_id': budgetId,
      'goal_id': goalId,
      'frecuency_id': frecuencyId,
      'payment_method_id': paymentMethodId,
      'notification_id': notificationId,
      'type': type,
      'title': title,
      'amount': amount,
      'date': date!.toIso8601String(),
      'note': note, 
      'beneficiary': beneficiary, 
    };
  }

  @override
  String toString() {
    return Convertions.classToString("ScheduledPay", toMap());
  }
}