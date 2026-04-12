import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/goal.dart';
import 'package:wallet/modules/shared/drivers/local/models/icon.dart' as model;

class RelatedGoal extends Goal {
  model.Icon? icon;

  RelatedGoal({
    super.id,
    super.serverId,
    super.userId,
    super.note,
    super.notificationId,
    super.frecuencyId,
    this.icon,
    super.saved,
    super.title,
    super.total,
    super.autoSaving,
    super.dateFrom,
    super.dateTo,
    super.iconId,
  });

  @override
  void clear() {
    super.clear();
    icon = null;
  }

  @override
  String toString() => Convertions.classToString("RelatedGoal", toMap());
}