import 'package:wallet/modules/shared/drivers/local/models/account.dart';
import 'package:wallet/modules/shared/drivers/local/models/session.dart';
import 'package:wallet/modules/shared/drivers/local/models/user.dart';

class Convertions {
  static List<User> responseToUserList(List<Map<String, Object?>> response) {
    return [
      for (final { 'id': id as int, 'server_id': serverId as int?, 'names': names as String, 'email': email as String?, 'img': img as String?, 'password': password as String? } in response)
        User(id: id, serverId: serverId, email: email, img: img, password: password, names: names)
    ];
  }

  static List<Account> responseToAccountList(List<Map<String, Object?>> response) {
    return [
      for (final { 'id': id as int, 'server_id': serverId as int?, 'user_id': userId as int, 'title': title as String } in response)
        Account(id: id, serverId: serverId, userId: userId, title: title)
    ];
  }

  static Session responseToSession(Map<String, Object?> response) {
    return Session(
      id: response['id'] as int, 
      serverId: response['server_id'] as int?, 
      userId: response['user_id'] as int?,
      startedAt: DateTime.parse(response['started_at']! as String),
      finishedAt: response['finished_at'] != null ? DateTime.parse(response['finished_at']! as String) : null,
      publicIp: response['public_ip'] as String?,
      token: response['token'] as String?,
      finishedByUser: response['finished_by_user'] as bool?,
    );
  }

  static String classToString(String className, Map<String, Object?> classMap) {
    String toRet = "$className {";
    for(var entry in classMap.entries) toRet += entry.key + ': ' + entry.value.toString() + ", ";
    toRet += "}";
    return toRet;
  }
}