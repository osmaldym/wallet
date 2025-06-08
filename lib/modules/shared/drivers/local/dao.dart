import 'package:sqflite/sqflite.dart';
import 'package:wallet/core/constants/app_db.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/http/web_dao.dart';
import 'package:wallet/modules/shared/drivers/local/db.dart';
import 'package:wallet/modules/shared/drivers/local/models/category_group.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/session.dart';
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

  // Session operations
  Future<void> login() async {
    if ((await users()).isEmpty){
      Map<String, Object?> data = { "names": "Guest" };
      await insert(DBTables.user, data);
    }

    if ((await getActualSession()).isEmpty)
      insert(DBTables.session, Session(
        userId: (await users()).first.id,
        startedAt: DateTime.now(),
        publicIp: await WebDao().getPublicIp(),
      ).toMap());
  }

  Future<void> logout() async {
    if ((await users()).isEmpty){
      Map<String, Object?> data = { "names": "Guest" };
      await insert(DBTables.user, data);
    }

    updateById(
      DBTables.session,
      Session(
        finishedAt: DateTime.now(),
        finishedByUser: true,
      ).toMap(),
      (await getActualSession())['id'] as int
    );
  }

  Future<Map<String, Object?>> getActualSession() async {
    final List<Map<String, Object?>> sessionAllData = (await (await _db.get()).query(DBTables.session, limit: 1, where: 'finished_at IS NULL', orderBy: 'started_at desc'));
    if (sessionAllData.isNotEmpty) {
      final Map<String, Object?> sessionData = sessionAllData.first;
      Session session = Convertions.responseToSession(sessionData);
      return { ...sessionData, 'user': (await user(session.userId!)).toMap() };
    }
    return {};
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

  // Scheduled pay operations
  Future<void> insertScheduledPay(Map<String, Object?> pay, {bool orReplace = false}) async {
    User sessionUser = Convertions.responseToUser((await getActualSession())['user'] as Map<String, Object?>);
    pay['user_id'] = sessionUser.id;
    await (orReplace ? put(DBTables.scheduledPay, pay) : insert(DBTables.scheduledPay, pay));
  }

  // Scheduled pay operations
  Future<void> putScheduledPay(Map<String, Object?> pay) async {
    await insertScheduledPay(pay, orReplace: true);
  }

  Future<List<ScheduledPay>> scheduledPays({ int? type }) async {
    String? where = "";
    List<Object?> params = [];

    if (type != null) {
      where += "type = ?";
      params.add(type);
    }

    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.scheduledPay, where: where.isNotEmpty ? where : null, whereArgs: params.isNotEmpty ? params : null);
    return Convertions.responseToScheculedPayList(data);
  }

  Future<ScheduledPay> scheduledPay(int id) async {
    List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.scheduledPay, where: "id = ?", whereArgs: [id], limit: 1);
    return Convertions.responseToScheculedPayList(data).first;
  }

  // Category group operations
  Future<List<CategoryGroup>> categoryGroups() async {
    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.categoryGroup);
    return Convertions.responseToCategoryGroupList(data);
  }

  Future<CategoryGroup> categoryGroup(int id) async {
    List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.categoryGroup, where: "id = ?", whereArgs: [id], limit: 1);
    return Convertions.responseToCategoryGroupList(data).first;
  }
}