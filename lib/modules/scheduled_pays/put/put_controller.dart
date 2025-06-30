import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart';
import 'package:wallet/modules/shared/drivers/local/models/frecuency.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_monthly.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_weekly.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';

class PutController {
  late Dao dao = Dao();

  Future<void> createPay(ScheduledPay pay) async {
    await dao.putScheduledPay(pay.toMap());
  }

  Future<int> createFrecuency(FrecuencyData frecuency) async {
    RecordRepetition recordRepetition = RecordRepetition(
      rrFor: frecuency.rrFor,
      repeatEvery: frecuency.repeatEvery,
      forDate: frecuency.forDate,
      timesPlaced: frecuency.timesPlaced,
      repeatedTimes: frecuency.repeatedTimes,
    );

    int? recordRepetitionId = await createRecordRepetition(recordRepetition);

    switch (frecuency.repeatEvery) {
      case RepeatEvery.week:
        RecordRepetitionWeekly recordRepetitionWeekly = RecordRepetitionWeekly(
          recordRepetitionId: recordRepetitionId,
          daysOfWeek: frecuency.selectedDaysOfWeek,
        );

        await dao.insertRecordRepetitionWeekly(recordRepetitionWeekly.toMap());
        break;

      case RepeatEvery.month:
        RecordRepetitionMonthly recordRepetitionMonthly = RecordRepetitionMonthly(
          recordRepetitionId: recordRepetitionId,
        );
        if (frecuency.selectedMonthlyOption != null) {
          switch (frecuency.selectedMonthlyOption) {
            case FrecuencyMontlyOption.everyLastDay:
              recordRepetitionMonthly.everyLastDayOfMonth = true;
              break;

            case FrecuencyMontlyOption.sameDay:
              recordRepetitionMonthly.sameDayOfMonth = true;
              break;

            default: // EMPTY
          }

          if (frecuency.selectedMonthlyOption == FrecuencyMontlyOption.everySemanalDay){
            recordRepetitionMonthly.weekNumber = frecuency.weekNumber;
            recordRepetitionMonthly.everyNumberDay = frecuency.everyNumberDay;
          }
        }

        await dao.insertRecordRepetitionMonthly(recordRepetitionMonthly.toMap());
        break;

      default: // EMPTY
    }

    return recordRepetitionId;
  }

  Future<int> createRecordRepetition(RecordRepetition recordRepetition) async {
    return await dao.insertRecordRepetition(recordRepetition.toMap());
  }

  Future<List<Account>> getAllAccounts() async {
    return await dao.accounts();
  }
}