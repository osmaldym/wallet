import 'package:sqflite/sqflite.dart';
import 'package:wallet/core/constants/app_db.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/db.dart';
import 'package:wallet/modules/shared/drivers/local/models/user.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart';

class Dao {
  late DB _db;

  Dao() { _db = DB(); }

  Future<void> put(String tableName, Map<String, Object?> data) async {
    await (await _db.get()).insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insert(String tableName, Map<String, Object?> data) async {
    await (await _db.get()).insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<void> updateById(String tableName, Map<String, Object?> data, int id) async {
    data.remove("id");
    await (await _db.get()).update(tableName, data, where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteById(String tableName, int id) async {
    await (await _db.get()).delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  // User operations
  Future<List<User>> users() async {
    final List<Map<String, Object?>> users = await (await _db.get()).query(DBTables.user);
    return Convertions.responseToUserList(users);
  }

  Future<User> user(int id) async {
    List<Map<String, Object?>> user = await (await _db.get()).query(DBTables.user, where: "id = ?", whereArgs: [id], limit: 1);
    return Convertions.responseToUserList(user).first;
  }

  // Account operations
  Future<List<Account>> accounts() async {
    final List<Map<String, Object?>> accounts = await (await _db.get()).query(DBTables.account);
    return Convertions.responseToAccountList(accounts);
  }

  Future<Account> account(int id) async {
    List<Map<String, Object?>> account = await (await _db.get()).query(DBTables.account, where: "id = ?", whereArgs: [id], limit: 1);
    return Convertions.responseToAccountList(account).first;
  }
}