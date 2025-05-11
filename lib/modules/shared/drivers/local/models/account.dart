import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Account extends Defs {
  final int ?userId;
  final String ?title;

  Account({
    super.id,
    super.serverId,
    this.userId,
    this.title,
  });

  Map<String, Object?> toMap() {
    return { 'id': id, 'server_id': serverId, 'user_id': userId, 'title': title, };
  }

  @override
  String toString(){
    return Convertions.classToString("Account", toMap());
  }
}