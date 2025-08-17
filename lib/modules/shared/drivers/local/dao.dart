import 'package:sqflite/sqflite.dart';
import 'package:wallet/core/constants/app_db.dart';
import 'package:wallet/core/extensions/datetime_ext.dart';
import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/http/web_dao.dart';
import 'package:wallet/modules/shared/drivers/local/db.dart';
import 'package:wallet/modules/shared/drivers/local/models/category.dart';
import 'package:wallet/modules/shared/drivers/local/models/currency.dart';
import 'package:wallet/modules/shared/drivers/local/models/notifications.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_monthly.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_weekly.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_subcategory.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/session.dart';
import 'package:wallet/modules/shared/drivers/local/models/subcategories.dart';
import 'package:wallet/modules/shared/drivers/local/models/user.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart';
import 'package:wallet/modules/shared/drivers/local/models/record.dart' as model;

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

  Future<Map<String, Object?>> getById(String tableName, int id, { String idColumnName = "id" }) async {
    List<Map<String, Object?>> data = (await (await _db.get()).query(tableName, where:  "$idColumnName = ?", whereArgs: [id]));
    return data.isNotEmpty ? data.first : {};
  }

  Future<Map<String, Object?>> getByIdOrFirst(String tableName, int? id, { String idColumnName = "id" }) async {
    List<Map<String, Object?>> data = (await (await _db.get()).query(tableName, where: id == null ? null : "$idColumnName = ?", whereArgs: id == null ? null : [id], limit: 1));
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

  Future<Account?> account(int? id) async {
    if (id == null) return null;
    Map<String, Object?> account = await getById(DBTables.account, id);
    return Convertions.responseToAccount(account);
  }

  Future<void> putAccount(Map<String, Object?> account) async {
    await put(DBTables.account, account);
  }

  Future<void> updateAccount(int? accountId, Map<String, Object> account) async {
    if (accountId == null) return;
    await updateById(DBTables.account, account, accountId);
  }

  Future<double> sumAllAccountTotals() async =>
    (await (await _db.get()).rawQuery("SELECT SUM(amount) as total FROM ${DBTables.account} WHERE id > 1")).first['total'] as double? ?? 0;

  // Scheduled pay operations
  Future<void> insertScheduledPay(Map<String, Object?> pay, {bool orReplace = false}) async {
    User sessionUser = Convertions.responseToUser((await getActualSession())['user'] as Map<String, Object?>);
    pay['user_id'] = sessionUser.id;
    await (orReplace ? put(DBTables.scheduledPay, pay) : insert(DBTables.scheduledPay, pay));
  }

  Future<void> putScheduledPay(Map<String, Object?> pay) async {
    await insertScheduledPay(pay, orReplace: true);
  }

  Future<void> updateScheduledPay(Map<String, Object?> pay, int id) async {
    await updateById(DBTables.scheduledPay, pay, id);
  }

  Future<List<ScheduledPay>> scheduledPays({ int? type }) async {
    String? where = "";
    List<Object?> params = [];

    if (type != null) {
      where += "type = ?";
      params.add(type);
    }

    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.scheduledPay, where: where.isNotEmpty ? where : null, whereArgs: params.isNotEmpty ? params : null);
    return Convertions.responseToscheduledPayList(data);
  }

  Future<ScheduledPay> scheduledPay(int id) async {
    List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.scheduledPay, where: "id = ?", whereArgs: [id], limit: 1);
    return Convertions.responseToscheduledPayList(data).first;
  }

  Future<RelatedScheduledPay> _toRelatedScheduledPay(ScheduledPay scheduledPayData) async => RelatedScheduledPay(
      id: scheduledPayData.id,
      serverId: scheduledPayData.serverId,
      title: scheduledPayData.title,
      type: scheduledPayData.type,
      amount: scheduledPayData.amount,
      automatic: scheduledPayData.automatic,
      beneficiary: scheduledPayData.beneficiary,
      note: scheduledPayData.note,
      date: scheduledPayData.date,
      completedPay: scheduledPayData.completedPay,
      account: await account(scheduledPayData.accountId),
      currency: await currency(id: scheduledPayData.currencyId),
      frecuency: await relatedRecordRepetition(scheduledPayData.frecuencyId),
      notification: await notification(scheduledPayData.notificationId),
      subcategory: await relatedSubcategory(scheduledPayData.categoryId),
    );

  Future<List<RelatedScheduledPay>> relatedScheduledPays({int? type}) async {
    final List<ScheduledPay> scheduledPaysData = await scheduledPays(type: type);
    List<RelatedScheduledPay> datas = [
      for (final scheduledPayData in scheduledPaysData)  await _toRelatedScheduledPay(scheduledPayData)
    ];

    return datas;
  }

  Future<RelatedScheduledPay> relatedScheduledPay(int id) async {
    return _toRelatedScheduledPay(await scheduledPay(id));
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

  Future<RelatedSubcategory?> relatedSubcategory(int? id) async {
    if (id == null) return null;
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

  Future<RelatedRecordRepetition?> relatedRecordRepetition(int? idFrecuency) async {
    if (idFrecuency == null) return null;
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

  Future<RecordRepetitionWeekly?> recordRepetitionWeekly({ int? recordRepetitionId }) async {
    if (recordRepetitionId == null) return null;
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

    Future<RecordRepetitionMonthly?> recordRepetitionMonthly({ int? recordRepetitionId }) async {
    if (recordRepetitionId == null) return null;
    final Map<String, Object?> data = await getById(DBTables.recordRepetitionMonthly, recordRepetitionId, idColumnName: "record_repetition_id");
    return Convertions.responseToRecordRepetitionMonthly(data);
  }

  // Notifications
  Future<List<Notifications>> notifications() async {
    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.notifications);
    return Convertions.responseToNotificationList(data);
  }

  Future<Notifications?> notification(int? id) async {
    if (id == null) return null;
    final Map<String, Object?> data = await getById(DBTables.notifications, id);
    return Convertions.responseToNotification(data);
  }

  // Currency
  Future<List<Currency>> currencies() async {
    final List<Map<String, Object?>> data = await (await _db.get()).query(DBTables.currencies);
    return Convertions.responseToCurrencyList(data);
  }

  Future<Currency?> currency({int? id, bool? getFirst}) async {
    final Map<String, Object?> data = await getByIdOrFirst(DBTables.currencies, id);
    return Convertions.responseToCurrency(data);
  }

  // Record operations
  Future<List<model.Record?>> records({ int? scheduledPayId, bool? orderByDatePaidDesc, DateTime? dateFrom, DateTime? dateTo, bool? expired }) async {
    List<String> where = [];
    List<Object>? whereArgs = [];

    if (scheduledPayId != null) {
      where.add("scheduled_pay_id = ?");
      whereArgs.add(scheduledPayId);
    }

    if (expired != null) {
      where.add("expired = ?");
      whereArgs.add(expired);
    }

    if (dateFrom != null) {
      where.add("(date_paid >= ? OR date >= ?)");
      whereArgs.addAll([dateFrom.microsecondsSinceEpoch, dateFrom.microsecondsSinceEpoch]);
    }

    if (dateTo != null) {
      where.add("(date_paid <= ? OR date <= ?)");
      whereArgs.addAll([dateTo.microsecondsSinceEpoch, dateTo.microsecondsSinceEpoch]);
    }

    List<Map<String, Object?>> records = await (await _db.get()).query(DBTables.record, where: where.isNotEmpty ? where.join(" AND ") : null, whereArgs: whereArgs, orderBy: orderByDatePaidDesc.toBool() ? "date_paid DESC" : null);
    return Convertions.responseToRecordList(records);
  }

  Future<model.Record?> record({int? id, int? scheduledPayId, bool? orderByDatePaidDesc}) async {
    List<String> wheres = [];
    List<Object?> whereArgs = [];

    if (id != null) {
      wheres.add("id = ?");
      whereArgs.add(id);
    }

    if (scheduledPayId != null) {
      wheres.add("scheduled_pay_id = ?");
      whereArgs.add(scheduledPayId);
    }

    List<Map<String, Object?>> allData = await (await _db.get()).query(
      DBTables.record, 
      where: wheres.join(" AND "), 
      whereArgs: whereArgs, 
      limit: 1,
      orderBy: orderByDatePaidDesc.toBool() ? "date_paid DESC" : null,
    );
    return Convertions.responseToRecord(allData.isEmpty ? {} : allData.first);
  }

  Future<int> insertRecord(Map<String, Object?> record) => insert(DBTables.record, record);

  Future<RelatedRecord?> relatedRecord({int? id, int? scheduledPayId, bool? orderByDatePaidDesc}) async {
    model.Record? recordData = await record(id: id, scheduledPayId: scheduledPayId, orderByDatePaidDesc: orderByDatePaidDesc);
    if (recordData == null) return null;
    return RelatedRecord(
      id: recordData.id,
      serverId: recordData.serverId,
      paid: recordData.paid,
      date: recordData.date,
      datePaid: recordData.datePaid,
      expired: recordData.expired,
      scheduledPay: await relatedScheduledPay(recordData.scheduledPayId ?? -1)
    );
  }

  Future<List<RelatedRecord>> relatedRecordList({ int? scheduledPayId, bool? orderByDatePaidDesc, DateTime? dateFrom, DateTime? dateTo, bool? expired }) async {
    List<model.Record?> recordsData = await records(
      scheduledPayId: scheduledPayId, 
      orderByDatePaidDesc: orderByDatePaidDesc,
      expired: expired,
      dateFrom: dateFrom,
      dateTo: dateTo
    );
    return [
      for (final recordData in recordsData)
        RelatedRecord(
          id: recordData?.id,
          serverId: recordData?.serverId,
          paid: recordData?.paid,
          date: recordData?.date,
          datePaid: recordData?.datePaid,
          amount: recordData?.amount,
          expired: recordData?.expired,
          scheduledPay: await relatedScheduledPay(recordData?.scheduledPayId ?? -1)
        )
    ];
  }

  Future<void> updateRecord(int id, Map<String, Object?> data) async => await updateById(DBTables.record, data, id);

  Future<int> getRecordsCount({ int? scheduledPayId }) async {
    List<String> wheres = [];
    List<Object> whereArgs = [];

    if (scheduledPayId != null) {
      wheres.add("scheduled_pay_id = ?");
      whereArgs.add(scheduledPayId);
    }

    return (await (await _db.get()).rawQuery(
      "SELECT COUNT(*) as c FROM ${DBTables.record} ${wheres.isEmpty ? "" : "WHERE"} ${wheres.join(" AND ")}", 
      whereArgs
    )).first['c'] as int;
  }
  
  Future<void> createRecordsIfNotExist({int? scheduledPayId, bool? paid, DateTime? datePaid}) async {
    List<RelatedScheduledPay> pays = [];
    RelatedRecord? lastRecord;

    if (scheduledPayId != null) {
      lastRecord = await relatedRecord(scheduledPayId: scheduledPayId, orderByDatePaidDesc: true);
      RelatedScheduledPay? pay;

      if (lastRecord != null && lastRecord.scheduledPay != null) pay = lastRecord.scheduledPay;

      pay ??= await relatedScheduledPay(scheduledPayId);
      pays.add(pay);
    }
    
    if (pays.isEmpty) pays = await relatedScheduledPays();

    for (final pay in pays) {
      DateTime recordDateToSet = lastRecord?.date ?? pay.date ?? DateTime.now();

      List<int>? daysOfWeek = pay.frecuency?.recordRepetitionWeekly?.daysOfWeek;

      /// If has 0 replacing it with 7 because the first day of week 
      /// showing in "scheduled pay put" is Sunday instead of Monday
      /// and his position is 0
      int? indexOfZero = daysOfWeek?.indexOf(0);
      if (indexOfZero != null && indexOfZero > -1) daysOfWeek?[indexOfZero] = 7;
      daysOfWeek?.sort();

      /// Getting list min and this never returns 0 because the previus
      int? minDayOfWeekToRepeat = daysOfWeek?.first;

      if (lastRecord != null) {
        // Continue to avoid creating new records
        if (lastRecord.expired.toBool()) continue;

        int timesPlaced = (pay.frecuency?.timesPlaced ?? 1);

        switch (pay.frecuency?.repeatEvery){
          case RepeatEvery.once: continue;
          case RepeatEvery.day:
          case RepeatEvery.anual:
            if (pay.automatic.toBool() && DateTime.now().difference(recordDateToSet).inDays < (pay.frecuency!.timesPlaced ?? 1)) continue;
            bool isDay = pay.frecuency?.repeatEvery == RepeatEvery.day;

            recordDateToSet = recordDateToSet.addx(
              days: isDay ? timesPlaced : null,
              years: !isDay ? timesPlaced : null
            );
            break;
          case RepeatEvery.week:
            /// Getting list max
            int maxDayofWeekToRepeat = daysOfWeek?.last ?? 0;
            int weekday = recordDateToSet.weekday;

            int quantityOfWeeksInDays = (7 * timesPlaced);
            DateTime recordDateToSetWithQuantityOfWeeks = recordDateToSet.add(Duration(days: quantityOfWeeksInDays));

            if (weekday >= maxDayofWeekToRepeat && recordDateToSetWithQuantityOfWeeks.difference(recordDateToSet).inDays > 0) {
              recordDateToSet = recordDateToSet.add(Duration(days: quantityOfWeeksInDays - recordDateToSet.weekday + (minDayOfWeekToRepeat ?? 0)));
            } else if (minDayOfWeekToRepeat != null && weekday >= minDayOfWeekToRepeat) {
              int? daysToAdd = daysOfWeek?.firstWhere((el) => el > weekday);
              recordDateToSet = recordDateToSet.add(Duration(days: (daysToAdd ?? 0) - weekday));
            } 
            break;
          case RepeatEvery.month:
            RecordRepetitionMonthly? monthlyFrecuency = pay.frecuency?.recordRepetitionMonthly;
            if (monthlyFrecuency?.everyLastDayOfMonth ?? false) {
              recordDateToSet = recordDateToSet.recreate(
                month: (recordDateToSet.month + timesPlaced) + 1,
                day: 0,
              );
            } else if (monthlyFrecuency?.sameDayOfMonth ?? false) {
              recordDateToSet = recordDateToSet.addx(months: timesPlaced);
            } else if ((monthlyFrecuency?.weekNumber ?? 0) > 0) {
              int? weekday = monthlyFrecuency?.everyNumberDay;
              int weekPosition = (monthlyFrecuency?.weekNumber ?? 1) - 1;

              DateTime nextMonthWithLastPosition = recordDateToSet.recreate(
                month: recordDateToSet.month + timesPlaced,
                day: 1
              );

              while (true) {
                DateTime nextMonthWithLastPositionBefore = nextMonthWithLastPosition;
                nextMonthWithLastPosition = nextMonthWithLastPosition.add(Duration(days: ((7 * weekPosition) + (weekday ?? 0)) - nextMonthWithLastPosition.weekday));

                if (nextMonthWithLastPosition.getWeekPositionInMonth() - 1 == weekPosition) {
                  recordDateToSet = nextMonthWithLastPosition;
                  break;
                }

                nextMonthWithLastPosition = nextMonthWithLastPositionBefore.recreate(
                  month: nextMonthWithLastPositionBefore.month + timesPlaced,
                  day: 1
                );
              }
            }
            break;
          default: // NOTHING
        }
      } else {
        if (pay.frecuency?.repeatEvery == RepeatEvery.week) {
          recordDateToSet = pay.date ?? DateTime.now();

          if (minDayOfWeekToRepeat != null) {
            if (recordDateToSet.weekday >= minDayOfWeekToRepeat) {
              recordDateToSet = recordDateToSet.subtract(Duration(days: recordDateToSet.weekday - minDayOfWeekToRepeat));
            } else {
              recordDateToSet = recordDateToSet.add(Duration(days: minDayOfWeekToRepeat - recordDateToSet.weekday));
            }
          }
        }
      }

      if (pay.completedPay!
        || (pay.frecuency?.forDate?.difference(recordDateToSet).inMilliseconds ?? 0) < 0
        || pay.frecuency?.repeatedTimes != null && (pay.frecuency?.repeatedTimes ?? 0) <= await getRecordsCount(scheduledPayId: pay.id)) {
        updateScheduledPay(ScheduledPay(completedPay: true).toCleanMap(), pay.id!);
        continue;
      }

      model.Record newRecord = model.Record(
        date: recordDateToSet,
        datePaid: datePaid ?? recordDateToSet,
        expired: paid != null ? false : !pay.automatic.toBool(),
        amount: pay.amount,
        paid: paid ?? pay.automatic.toBool(),
        scheduledPayId: scheduledPayId,
      );
      insertRecord(newRecord.toMap());
    }
  }
}