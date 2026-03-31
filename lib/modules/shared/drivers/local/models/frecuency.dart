import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';

enum FrecuencyMontlyOption { sameDay, everySemanalDay, everyLastDay }

class FrecuencyData {
  String? title;
  RepeatEvery? repeatEvery;
  RRFor? rrFor;
  FrecuencyMontlyOption? selectedMonthlyOption;
  int? timesPlaced;
  int? repeatedTimes;
  List<int>? selectedDaysOfWeek;
  DateTime? forDate;
  int? weekNumber;
  int? everyNumberDay;

  FrecuencyData({
    this.title,
    this.repeatEvery,
    this.timesPlaced,
    this.selectedDaysOfWeek,
    this.rrFor,
    this.selectedMonthlyOption,
    this.repeatedTimes,
    this.forDate,
  });

  void clear() {
    repeatEvery = RepeatEvery.once;
    rrFor = RRFor.ever;
    timesPlaced = 1;
    everyNumberDay = null;
    forDate = null;
    repeatedTimes = null;
    selectedDaysOfWeek = null;
    selectedMonthlyOption = null;
    weekNumber = null;
    title = null;
  }

  @override
  String toString() {
    return """
      FrecuenciesModalData {
        title: $title,
        selectedConstancy: $repeatEvery,
        every: $timesPlaced,
        selectedDaysOfWeek: $selectedDaysOfWeek,
        selectedRepetition: $rrFor,
        selectedMontlyOption: $selectedMonthlyOption,
        quantityOfTimes: $repeatedTimes,
        toMaxDate: $forDate,
      }
    """.replaceAll(RegExp(r"[ ]{2,}"), " ").trim().replaceFirst(RegExp(r" }$"), "}");
  }
}