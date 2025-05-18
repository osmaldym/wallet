import 'package:wallet/modules/shared/drivers/local/models/account.dart';
import 'package:wallet/modules/shared/drivers/local/models/session.dart';
import 'package:wallet/modules/shared/drivers/local/models/user.dart';

class Convertions {
  static List<User> responseToUserList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToUser(resp) ];
  }

  static User responseToUser(Map<String, Object?> response) {
    return User(
      id: response['id'] as int?,
      serverId: response['server_id'] as int?,
      names: response['names'] as String?,
      email: response['email'] as String?,
      img: response['img'] as String?,
      password: response['password'] as String?,
    );
  }

  static List<Account> responseToAccountList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToAccount(resp) ];
  }

  static Account responseToAccount(Map<String, Object?> response) {
    return Account(
      id: response['id'] as int?,
      serverId: response['server_id'] as int?,
      userId: response['user_id'] as int?,
      title: response['title'] as String?,
    );
  }

  static List<Session> responseToSessionList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToSession(resp) ];
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