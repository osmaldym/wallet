import 'package:sqflite/sqflite.dart';
import 'package:wallet/core/constants/app_db.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/http/web_dao.dart';
import 'package:wallet/modules/shared/drivers/local/db.dart';
import 'package:wallet/modules/shared/drivers/local/models/category.dart';
import 'package:wallet/modules/shared/drivers/local/models/currency.dart';
import 'package:wallet/modules/shared/drivers/local/models/notifications.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_monthly.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_weekly.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_subcategory.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/session.dart';
import 'package:wallet/modules/shared/drivers/local/models/subcategories.dart';
import 'package:wallet/modules/shared/drivers/local/models/user.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart';

class Dao {
  late DB _db;

  Dao() { _db = DB(); }

  Future<int> put(String tableName, Map<String, Object?> data) async {
    return await (await _db.get()).insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insert(String tableName, Map<String, Object?> data) async {
    return await (await _db.get()).insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<void> updateById(String tableName, Map<String, Object?> data, int id) async {
    data.remove("id");
    await (await _db.get()).update(tableName, data, where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteById(String tableName, int id) async {
    await (await _db.get()).delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<Map<String, Object?>> getById(String tableName, int? id, { String idColumnName = "id" }) async {
    if (id == null) return {};
    List<Map<String, Object?>> data = (await (await _db.get()).query(tableName, where:  "$idColumnName = ?", whereArgs: [id]));
    return data.isNotEmpty ? data.first : {};
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
    Map<String, Object?> account = await getById(DBTables.account, id);
    return Convertions.responseToAccount(account);
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

  Future<List<RelatedScheduledPay>> relatedScheduledPays({int? type}) async {
    final List<ScheduledPay> scheduledPaysData = await scheduledPays(type: type);
    List<RelatedScheduledPay> datas = [
      for (final scheduledPayData in scheduledPaysData)
        RelatedScheduledPay(
          id: scheduledPayData.id,
          serverId: scheduledPayData.serverId,
          title: scheduledPayData.title,
          type: scheduledPayData.type,
          amount: scheduledPayData.amount,
          automatic: scheduledPayData.automatic,
          beneficiary: scheduledPayData.beneficiary,
          note: scheduledPayData.note,
          date: scheduledPayData.date,
          account: await account(scheduledPayData.accountId ?? -1),
          currency: await currency(id: scheduledPayData.currencyId),
          frecuency: await relatedRecordRepetition(scheduledPayData.frecuencyId ?? -1),
          notification: await notification(scheduledPayData.notificationId),
          subcategory: await relatedSubcategory(scheduledPayData.categoryId ?? -1),
        )
    ];

    return datas;
  }

  // Category group operations
  Future<List<Category>> categoryGroups() async {
    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.category);
    return Convertions.responseToCategoryGroupList(data);
  }

  Future<Category> categoryGroup(int id) async {
    List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.category, where: "id = ?", whereArgs: [id], limit: 1);
    return Convertions.responseToCategoryGroupList(data).first;
  }

  // Subcategory operations
  Future<List<Subcategories>> subcategories() async {
    final List<Map<String, Object?>> data = await (await _db.get()).rawQuery(
      """
      SELECT * FROM ${DBTables.subcategory} WHERE is_category_reference = false 
      UNION
      SELECT s.id, 
             s.server_id,
             c.name,
             c.icon,
             c.icon_font_family,
             s.category_id,
             s.is_category_reference
      FROM ${DBTables.subcategory} s 
      JOIN ${DBTables.category} c ON s.category_id = c.id WHERE s.is_category_reference = true
      """
    );
    return Convertions.responseToSubcategoryList(data);
  }

  Future<Subcategories> subcategory(int id) async {
    List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.subcategory, where: "id = ?", whereArgs: [id], limit: 1);
    return Convertions.responseToSubcategoryList(data).first;
  }

  Future<RelatedSubcategory> relatedSubcategory(int id) async {
    Subcategories subcategoryData = await subcategory(id);
    return RelatedSubcategory(
      id: subcategoryData.id,
      serverId: subcategoryData.serverId,
      icon: subcategoryData.icon,
      iconFontFamily: subcategoryData.iconFontFamily,
      isCategoryReference: subcategoryData.isCategoryReference,
      name: subcategoryData.name,
      category: await categoryGroup(subcategoryData.categoryId ?? -1)
    );
  }

  // Record repetition
  Future<int> insertRecordRepetition(Map<String, Object?> recordRepetition, {bool orReplace = false}) async {
    return await (orReplace ? put(DBTables.recordRepetition, recordRepetition) : insert(DBTables.recordRepetition, recordRepetition));
  }

  Future<void> putRecordRepetition(Map<String, Object?> recordRepetition) async {
    await insertRecordRepetition(recordRepetition, orReplace: true);
  }

  Future<List<RecordRepetition>> recordRepetitions() async {
    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.recordRepetition);
    return Convertions.responseToRecordRepetitionList(data);
  }

  Future<RecordRepetition> recordRepetition(int id) async {
    List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.recordRepetition, where: "id = ?", whereArgs: [id], limit: 1);
    return Convertions.responseToRecordRepetitionList(data).first;
  }

  Future<RelatedRecordRepetition> relatedRecordRepetition(int idFrecuency) async {
    final RecordRepetition recordRepetitionData = await recordRepetition(idFrecuency);

    RelatedRecordRepetition relatedRecordRepetition = RelatedRecordRepetition(
      id: recordRepetitionData.id,
      serverId: recordRepetitionData.serverId,
      forDate: recordRepetitionData.forDate,
      timesPlaced: recordRepetitionData.timesPlaced,
      repeatEvery: recordRepetitionData.repeatEvery,
      repeatedTimes: recordRepetitionData.repeatedTimes,
      rrFor: recordRepetitionData.rrFor,
    );

    switch (recordRepetitionData.repeatEvery) {
      case RepeatEvery.week:
        relatedRecordRepetition.recordRepetitionWeekly = await recordRepetitionWeekly(recordRepetitionId: idFrecuency);
        break;
      case RepeatEvery.month:
        relatedRecordRepetition.recordRepetitionMonthly = await recordRepetitionMonthly(recordRepetitionId: idFrecuency);
        break;
      default:
        // Nothing
    }

    return relatedRecordRepetition;
  }
  
  // Record repetition weekly
  Future<int> insertRecordRepetitionWeekly(Map<String, Object?> recordRepetitionWeekly, {bool orReplace = false}) async {
    return await (orReplace ? put(DBTables.recordRepetitionWeekly, recordRepetitionWeekly) : insert(DBTables.recordRepetitionWeekly, recordRepetitionWeekly));
  }

  Future<List<RecordRepetitionWeekly>> recordRepetitionsWeekly() async {
    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.recordRepetitionWeekly);
    return Convertions.responseToRecordRepetitionWeeklyList(data);
  }

  Future<RecordRepetitionWeekly> recordRepetitionWeekly({ int? recordRepetitionId }) async {
    final Map<String, Object?> data = await getById(DBTables.recordRepetitionWeekly, recordRepetitionId, idColumnName: "record_repetition_id");
    return Convertions.responseToRecordRepetitionWeekly(data);
  }

  // Record repetition monthly
  Future<int> insertRecordRepetitionMonthly(Map<String, Object?> recordRepetitionMonthly, {bool orReplace = false}) async {
    return await (orReplace ? put(DBTables.recordRepetitionMonthly, recordRepetitionMonthly) : insert(DBTables.recordRepetitionMonthly, recordRepetitionMonthly));
  }

  Future<List<RecordRepetitionMonthly>> recordRepetitionsMonthly() async {
    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.recordRepetitionMonthly);
    return Convertions.responseToRecordRepetitionMonthlyList(data);
  }

    Future<RecordRepetitionMonthly> recordRepetitionMonthly({ int? recordRepetitionId }) async {
    final Map<String, Object?> data = await getById(DBTables.recordRepetitionMonthly, recordRepetitionId, idColumnName: "record_repetition_id");
    return Convertions.responseToRecordRepetitionMonthly(data);
  }

  // Notifications
  Future<List<Notifications>> notifications() async {
    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.notifications);
    return Convertions.responseToNotificationList(data);
  }

  Future<Notifications> notification(int? id) async {
    final Map<String, Object?> data = await getById(DBTables.notifications, id);
    return Convertions.responseToNotification(data);
  }

  // Currency
  Future<List<Currency>> currencies() async {
    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.currencies);
    return Convertions.responseToCurrencyList(data);
  }

  Future<Currency> currency({ int? id }) async {  
    String? where;
    List<Object>? whereArgs;

    if (id != null) {
      where = "id = ?";
      whereArgs = [id as Object];
    }

    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.currencies, where: where, limit: 1, whereArgs: whereArgs);
    return Convertions.responseToCurrency(data.first);
  }
}