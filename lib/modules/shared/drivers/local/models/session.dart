import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Session extends Defs {
  int? userId;
  DateTime? startedAt;
  DateTime? finishedAt;
  String? token;
  String? publicIp;
  bool? finishedByUser;

  Session({
    super.id,
    super.serverId,
    this.userId,
    this.startedAt,
    this.finishedAt,
    this.token,
    this.publicIp,
    this.finishedByUser,
  });

  Map<String, Object?> toMap() => {
    'id': id, 
    'server_id': serverId, 
    'user_id': userId, 
    'started_at': startedAt?.microsecondsSinceEpoch, 
    'finished_at': finishedAt?.microsecondsSinceEpoch, 
    'token': token, 
    'public_ip': publicIp, 
    'finished_by_user': finishedByUser.boolToIntOrNull() 
  };

  @override
  String toString() => Convertions.classToString('Session', toMap());
}