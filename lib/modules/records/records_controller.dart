import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/reports/r_week_report.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/record.dart' as model;

class RecordsController {
  Dao dao = Dao();

  Future<void>? updateRecord({int? scheduledPayId, int? recordId, DateTime? datetime, double? amount, bool? paid}) async {
    if (recordId != null) dao.updateRecord(recordId, model.Record(datePaid: datetime, amount: amount, paid: paid).toCleanMap());
    if (scheduledPayId != null) await dao.createRecordsIfNotExist(scheduledPayId: scheduledPayId);
  }

  Future<List<RelatedRecord>>? getRecords({ int? type, DateTime? dateFrom, DateTime? dateTo }) async {
    List<ScheduledPay> scheduledPayList = await dao.scheduledPays(type: type);
    List<RelatedRecord> records = [];

    if (scheduledPayList.isNotEmpty){
      for (final pay in scheduledPayList) {
        records.addAll(await dao.relatedRecordList(
          scheduledPayId: pay.id,
          orderByDatePaidDesc: true,
          expired: false,
          dateFrom: dateFrom,
          dateTo: dateTo,
        ));
      }
    }

    return records;
  }

  Future<RelatedWeekReport>? getWeekReport({ int? weekNumber, DateTime? date }) {
    if (date == null || weekNumber == null) return null;
    return dao.relatedWeekReport(date, weekNumber);
  }
}