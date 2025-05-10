import 'package:wallet/modules/shared/drivers/local/models/account.dart';
import 'package:wallet/modules/shared/drivers/local/models/user.dart';

class Convertions {
  static List<User> responseToUserList(List<Map<String, Object?>> response) {
    return [
      for (final { 'id': id as int, 'server_id': serverId as int, 'names': names as String, 'email': email as String, 'img': img as String, 'password': password as String } in response)
        User(id: id, serverId: serverId, email: email, img: img, password: password, names: names)
    ];
  }

  static List<Account> responseToAccountList(List<Map<String, Object?>> response) {
    return [
      for (final { 'id': id as int, 'server_id': serverId as int, 'user_id': userId as int, 'title': title as String } in response)
        Account(id: id, serverId: serverId, userId: userId, title: title)
    ];
  }
}