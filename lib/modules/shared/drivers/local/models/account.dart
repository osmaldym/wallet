import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Account extends Defs {
  int? userId;
  String? title;
  double? amount;
  bool? isTotal;

  Account({
    super.id,
    super.serverId,
    this.userId,
    this.title,
    this.isTotal,
    this.amount
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'server_id': serverId,
    'user_id': userId,
    'title': title,
    'amount': amount,
    'is_total': isTotal.boolToIntOrNull(),
  };

  Map<String, Object?> toCleanMap() {
    Map<String, Object?> map = toMap();
    map.removeWhere((key, value) => value == null);
    return map;
  }

  @override
  String toString(){
    return Convertions.classToString("Account", toMap());
  }
}