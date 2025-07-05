import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Notifications extends Defs {
  String? name;
  String? localeName;

  Notifications({
    super.id,
    super.serverId,
    this.name,
    this.localeName
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'name': name,
      'locale_name': localeName
    };
  }

  @override
  String toString() => Convertions.classToString("Notifications", toMap());
}