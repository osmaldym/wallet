import 'package:wallet/core/utils/convertions.dart';

class Account {
  final int ?id;
  final int ?serverId;
  final int ?userId;
  final String ?title;

  const Account({
    this.id,
    this.serverId,
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