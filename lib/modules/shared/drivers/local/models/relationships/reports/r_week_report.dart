import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';

class RelatedWeekReport {
  double? totalOfAccount;
  double? total;
  String? totalOfAccountName;
  double? totalIncome;
  double? totalExpend;
  double? totalLastWeek;
  double? totalVsLastWeek;
  RelatedRecord? lessExpend;
  RelatedRecord? highExpend;

  RelatedWeekReport({
    this.total,
    this.totalExpend,
    this.totalIncome,
    this.totalOfAccount,
    this.totalOfAccountName,
    this.totalLastWeek,
    this.totalVsLastWeek,
    this.highExpend,
    this.lessExpend,
  });

  Map<String, Object?> toMap() => {
    'total': total,
    'total_expend': totalExpend,
    'total_income': totalIncome,
    'total_of_account': totalOfAccount,
    'total_of_account_name': totalOfAccountName,
    'total_last_week': totalLastWeek,
    'total_vs_last_week': totalVsLastWeek,
    'high_expend': highExpend,
    'less_expend': lessExpend,
  };

  @override
  String toString() => Convertions.classToString("RelatedWeekReport", toMap());
}