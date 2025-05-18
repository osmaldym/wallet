import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Session extends Defs {
  final int? userId;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final String? token;
  final String? publicIp;
  final bool? finishedByUser;

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

  Map<String, Object?> toMap() =>
    { 'id': id, 'server_id': serverId, 'user_id': userId, 'started_at': startedAt!.toIso8601String(), 'finished_at': finishedAt?.toIso8601String(), 'token': token, 'public_ip': publicIp, 'finished_by_user': finishedByUser };

  @override
  String toString() => Convertions.classToString('Session', toMap());
}