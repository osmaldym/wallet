import 'dart:async';

import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart' as Model;
import 'package:wallet/modules/shared/drivers/local/models/record.dart' as model;
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';

class HomeController {
  late Dao daoLocal = Dao();

  Future<void> createSession() async {
    await daoLocal.login();
  }

  Future<void> putAccount(Model.Account account) async {
    await daoLocal.putAccount(account.toCleanMap());
    if (account.id == null || (account.id ?? -1) > 1) await daoLocal.updateAccount(1, {'amount': await daoLocal.sumAllAccountTotals() });
  }

  Future<List<Model.Account>> getAccounts() async {
    return daoLocal.accounts();
  }

  Future<void> insertRecord({int? scheduledPayId, bool? paid}) async {
    await daoLocal.createRecordsIfNotExist(scheduledPayId: scheduledPayId, paid: paid);
  }

  Future<void> updateLastRecordIfExistAndAccount({
    int? scheduledPayId,
    int? recordId,
    bool? paid,
    DateTime? datetime,
    double? amount,
    int? accountId,
    bool? isExpense,
  }) async {
    if (recordId != null) {
      daoLocal.updateRecord(
        recordId, 
        model.Record(
          paid: paid, 
          expired: false, 
          datePaid: datetime,
          amount: amount, 
          balance: accountId != null && (paid ?? false) ? await daoLocal.updateAccountBalance(accountId, amount, substract: isExpense) : null,
        ).toCleanMap()
      );
    }

    if (scheduledPayId != null) await daoLocal.createRecordsIfNotExist(scheduledPayId: scheduledPayId);
  }

  Future<void> postponeLastRecord({int? scheduledPayId, int? recordId, DateTime? datetime}) async {
    if (recordId != null) daoLocal.updateRecord(recordId, model.Record(date: datetime, datePaid: datetime).toCleanMap());
  }

  Future<List<RelatedRecord?>> getRecords() async {
    List<ScheduledPay> scheduledPays = await daoLocal.scheduledPays();
    List<RelatedRecord?> relatedRecords = [];

    for (final pay in scheduledPays) {
      await daoLocal.createRecordsIfNotExist(scheduledPayId: pay.id);
      RelatedRecord? record = await daoLocal.relatedRecord(scheduledPayId: pay.id!, orderByDatePaidDesc: true);
      if (record != null && (pay.completedPay ?? false) && record.paid!) continue;
      relatedRecords.add(record);
    }

    relatedRecords.sort((a, b) => (a?.datePaid ?? a?.date ?? DateTime.now()).compareTo(b?.datePaid ?? b?.date ?? DateTime.now()));

    return relatedRecords;
  }

}