import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';
import 'package:wallet/modules/shared/drivers/local/models/record.dart' as model;

class PayInfoController {
  Dao dao = Dao();

  Future<List<RelatedRecord>> insertRecord({int? scheculedPayId, bool? paid}) async {
    await dao.createRecordsIfNotExist(scheduledPayId: scheculedPayId, paid: paid);
    return await dao.relatedRecordList(scheduledPayId: scheculedPayId, orderByDatePaidDesc: true);
  }

  Future<List<RelatedRecord>> updateLastRecordIfExist({int? scheculedPayId, int? recordId, bool? paid, DateTime? datetime, double? amount}) async {
    if (recordId != null) dao.updateRecord(recordId, model.Record(paid: paid, expired: false, datePaid: datetime, amount: amount).toCleanMap());
    if (scheculedPayId != null) await dao.createRecordsIfNotExist(scheduledPayId: scheculedPayId);
    return await dao.relatedRecordList(scheduledPayId: scheculedPayId, orderByDatePaidDesc: true);
  }

  Future<List<RelatedRecord>> postponeLastRecord({int? scheduledPayId, int? recordId, DateTime? datetime}) async {
    if (recordId != null) dao.updateRecord(recordId, model.Record(date: datetime, datePaid: datetime).toCleanMap(zeroToNull: true));
    return await dao.relatedRecordList(scheduledPayId: scheduledPayId, orderByDatePaidDesc: true);
  }
}