import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';
import 'package:wallet/modules/shared/drivers/local/models/record.dart' as model;

class PayInfoController {
  Dao dao = Dao();

  Future<List<RelatedRecord>> insertRecord({int? scheduledPayId, bool? paid}) async {
    await dao.createRecordsIfNotExist(scheduledPayId: scheduledPayId, paid: paid);
    return await dao.relatedRecordList(scheduledPayId: scheduledPayId, orderByDatePaidDesc: true);
  }

  Future<List<RelatedRecord>> updateLastRecordIfExist({int? scheduledPayId, int? recordId, bool? paid, DateTime? datetime, double? amount}) async {
    if (recordId != null) dao.updateRecord(recordId, model.Record(paid: paid, expired: false, datePaid: datetime, amount: amount).toCleanMap());
    if (scheduledPayId != null) await dao.createRecordsIfNotExist(scheduledPayId: scheduledPayId);
    return await dao.relatedRecordList(scheduledPayId: scheduledPayId, orderByDatePaidDesc: true);
  }

  Future<List<RelatedRecord>> postponeLastRecord({int? scheduledPayId, int? recordId, DateTime? datetime}) async {
    if (recordId != null) dao.updateRecord(recordId, model.Record(date: datetime, datePaid: datetime).toCleanMap());
    return await dao.relatedRecordList(scheduledPayId: scheduledPayId, orderByDatePaidDesc: true);
  }
}