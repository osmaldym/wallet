import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart';
import 'package:wallet/modules/shared/drivers/local/models/category.dart';
import 'package:wallet/modules/shared/drivers/local/models/currency.dart';
import 'package:wallet/modules/shared/drivers/local/models/notifications.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_monthly.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_weekly.dart';
import 'package:wallet/modules/shared/drivers/local/models/subcategories.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/session.dart';
import 'package:wallet/modules/shared/drivers/local/models/user.dart';
import 'package:wallet/modules/shared/drivers/local/models/record.dart' as model;

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
      id: response['id'] as int?,
      serverId: response['server_id'] as int?, 
      userId: response['user_id'] as int?,
      startedAt: DateTime.parse(response['started_at']! as String),
      finishedAt: response['finished_at'] != null ? DateTime.parse(response['finished_at']! as String) : null,
      publicIp: response['public_ip'] as String?,
      token: response['token'] as String?,
      finishedByUser: response['finished_by_user'].intToBool(),
    );
  }

  static List<ScheduledPay> responseToScheculedPayList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToScheculedPay(resp) ];
  }

  static ScheduledPay responseToScheculedPay(Map<String, Object?> response) {
    return ScheduledPay(
      id: response["id"] as int?,
      userId: response["user_id"] as int?,
      serverId: response["server_id"] as int?,
      imageId: response["image_id"] as int?,
      categoryId: response["category_id"] as int?,
      accountId: response["account_id"] as int?,
      budgetId: response["budget_id"] as int?,
      goalId: response["goal_id"] as int?,
      frecuencyId: response["frecuency_id"] as int?,
      paymentMethodId: response["payment_method_id"] as int?,
      notificationId: response["notification_id"] as int?,
      currencyId: response['currency_id'] as int?,
      title: response["title"] as String?,
      automatic: (response['automatic'] as int?) != null && (response['automatic'] as int?)! > 0 ? true : false,
      type: response["type"] as int?,
      amount: response["amount"] as double?,
      date: DateTime.tryParse(response["date"].toString()),
      note: response["note"] as String?,
      beneficiary: response["beneficiary"] as String?,
    );
  }

  static List<Category> responseToCategoryGroupList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToCategoryGroup(resp) ];
  }

  static Category responseToCategoryGroup(Map<String, Object?> response) {
    return Category(
      id: response['id'] as int?,
      serverId: response['server_id'] as int?, 
      userId: response['user_id'] as int?,
      name: response['name'] as String?,
      icon: response['icon'] as int?,
      iconFontFamily: response['icon_font_family'] as String?,
    );
  }

  static List<Subcategories> responseToSubcategoryList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToSubcategory(resp) ];
  }

  static Subcategories responseToSubcategory(Map<String, Object?> response) {
    return Subcategories(
      id: response['id'] as int?,
      serverId: response['server_id'] as int?,
      name: response['name'] as String?,
      icon: response['icon'] as int?,
      iconFontFamily: response['icon_font_family'] as String?,
      categoryId: response['category_id'] as int?,
      isCategoryReference: (response['is_category_reference'] as int?) != null && (response['is_category_reference'] as int?)! > 0 ? true : false,
    );
  }

  static List<RecordRepetition> responseToRecordRepetitionList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToRecordRepetition(resp) ];
  }

  static RecordRepetition responseToRecordRepetition(Map<String, Object?> response) {
    return RecordRepetition(
      id: response['id'] as int?,
      serverId: response['server_id'] as int?,
      timesPlaced: response['times_placed'] as int?,
      forDate: response['for_date'] != null ? DateTime.parse(response['for_date']! as String) : null,
      repeatEvery: response['repeat_every'] != null ? RepeatEvery.values[response['repeat_every'] as int] : null,
      rrFor: response['for'] != null ? RRFor.values[response['for'] as int] : null,
      repeatedTimes: response['repeated_times'] as int?,
    );
  }

  static List<RecordRepetitionWeekly> responseToRecordRepetitionWeeklyList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToRecordRepetitionWeekly(resp) ];
  }

  static RecordRepetitionWeekly responseToRecordRepetitionWeekly(Map<String, Object?> response) {
    return RecordRepetitionWeekly(
      id: response['id'] as int?,
      serverId: response['server_id'] as int?,
      daysOfWeek: (response['days_of_week'] as String?)?.split(",").map((el) => int.parse(el)).toList(),
      recordRepetitionId: response['record_repetition_id'] as int?,
    );
  }
  
  static List<RecordRepetitionMonthly> responseToRecordRepetitionMonthlyList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToRecordRepetitionMonthly(resp) ];
  }

  static RecordRepetitionMonthly responseToRecordRepetitionMonthly(Map<String, Object?> response) {
    return RecordRepetitionMonthly(
      id: response['id'] as int?, 
      serverId: response['server_id'] as int?,
      everyLastDayOfMonth: response['every_last_day_of_month'].intToBool(),
      sameDayOfMonth: response['same_day_of_month'].intToBool(),
      everyNumberDay: response['every_number_day'] as int?,
      weekNumber: response['week_number'] as int?,
    );
  }

  static List<Notifications> responseToNotificationList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToNotification(resp) ];
  }

  static Notifications responseToNotification(Map<String, Object?> response) {
    return Notifications(
      id: response['id'] as int?, 
      serverId: response['server_id'] as int?,
      name: response['name'] as String?,
      localeName: response['locale_name'] as String?,
    );
  }

  static List<Currency> responseToCurrencyList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToCurrency(resp) ];
  }

  static Currency responseToCurrency(Map<String, Object?> response) {
    return Currency(
      id: response['id'] as int?,
      serverId: response['server_id'] as int?,
      iso: response['iso'] as String?,
      symbol: response['symbol'] as String?,
      locale: response['locale'] as String?,
      country: response['country'] as String?,
    );
  }

  static List<model.Record?> responseToRecordList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToRecord(resp) ];
  }

  static model.Record? responseToRecord(Map<String, Object?> response) {
    if (response.isEmpty) return null;
    return model.Record(
      id: response["id"] as int?,
      serverId: response["server_id"] as int?,
      scheduledPayId: response["scheduled_pay_id"] as int?,
      date: DateTime.tryParse(response["date"].toString()),
      paid: response['paid'].intToBool(),
      expired: response['expired'].intToBool(),
    );
  }

  static String classToString(String className, Map<String, Object?> classMap) {
    String toRet = "$className { ";
    int i = 0;
    for (var entry in classMap.entries) {
      toRet += entry.key + ': ' + entry.value.toString() + (i < classMap.entries.length-1 ? ", " : "");
      i++;
    }
    toRet += " }";
    return toRet;
  }
}