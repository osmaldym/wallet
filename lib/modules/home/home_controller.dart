import 'dart:async';

import 'package:wallet/core/constants/app_db.dart';
import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart' as Model;
import 'package:wallet/modules/shared/drivers/local/models/record.dart' as model;
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/user.dart';
import 'package:wallet/modules/shared/widgets/fragments/account.dart';

class HomeController {
  late Dao daoLocal = Dao();

  Future<void> createSession() async {
    await daoLocal.login();
  }

  Future<void> addAccount(String name) async {
    List<User> users = await daoLocal.users();
    User actualUser = users.first;

    Map<String, Object?> data = { 
      "title": name,
      "user_id": actualUser.serverId ?? actualUser.id
    };
    await daoLocal.insert(DBTables.account, data);
  }

  Future<List<Account>> getAccounts() async {
    List<Model.Account> accounts = await daoLocal.accounts();
    List<Account> accountsToShow = [
      Account(
        isTotal: true,
        quantity: "+180,000",
        onTap: (){},
      ),
    ];

    for (final account in accounts)
      accountsToShow.add(
        Account(
          name: account.title,
          quantity: '+100,000',
          onTap: (){},
        )
      );

    return accountsToShow;
  }

  Future<void> insertRecord({int? scheduledPayId, bool? paid}) async {
    await daoLocal.createRecordsIfNotExist(scheduledPayId: scheduledPayId, paid: paid);
  }

  Future<void> updateLastRecordIfExist({int? scheduledPayId, int? recordId, bool? paid, DateTime? datetime, double? amount}) async {
    if (recordId != null) daoLocal.updateRecord(recordId, model.Record(paid: paid, expired: false, datePaid: datetime, amount: amount).toCleanMap());
    if (scheduledPayId != null) await daoLocal.createRecordsIfNotExist(scheduledPayId: scheduledPayId);
  }

  Future<void> postponeLastRecord({int? scheduledPayId, int? recordId, DateTime? datetime}) async {
    if (recordId != null) daoLocal.updateRecord(recordId, model.Record(date: datetime, datePaid: datetime).toCleanMap(zeroToNull: true));
  }

  Future<List<RelatedRecord?>> getRecords() async {
    List<ScheduledPay> scheduledPays = await daoLocal.scheduledPays();
    List<RelatedRecord?> relatedRecords = [];

    for (final pay in scheduledPays) {
      await daoLocal.createRecordsIfNotExist(scheduledPayId: pay.id);
      RelatedRecord? record = await daoLocal.relatedRecord(scheduledPayId: pay.id!, orderByDatePaidDesc: true);
      if (record != null) relatedRecords.add(record);
    }

    relatedRecords.sort((a, b) => (a?.datePaid ?? a?.date ?? DateTime.now()).compareTo(b?.datePaid ?? b?.date ?? DateTime.now()));

    return relatedRecords;
  }

}