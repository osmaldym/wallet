import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Goal extends Defs {
  int? userId;
  int? frecuencyId;
  int? notificationId;
  int? iconId;
  String? title;
  double? total;
  double? saved;
  double? autoSaving;
  String? note;
  DateTime? dateFrom;
  DateTime? dateTo;

  Goal({
    super.id,
    super.serverId,
    this.userId,
    this.title,
    this.iconId,
    this.total,
    this.saved,
    this.autoSaving,
    this.note,
    this.frecuencyId,
    this.notificationId,
    this.dateFrom,
    this.dateTo,
  });

  void clear() {
    id = null;
    title = null;
    userId = null;
    iconId = null;
    serverId = null;
    notificationId = null;
    autoSaving = null;
    saved = null;
    dateFrom = null;
    dateTo = null;
    note = null;
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'user_id': userId,
    'icon_id': iconId,
    'saved': saved,
    'auto_saving': autoSaving,
    'total': total,
    'note': note,
    'frecuency_id': frecuencyId,
    'notification_id': notificationId,
    'date_from': dateFrom?.microsecondsSinceEpoch,
    'date_to': dateTo?.microsecondsSinceEpoch,
  };

  @override
  String toString() => Convertions.classToString("Goals", toMap());
}