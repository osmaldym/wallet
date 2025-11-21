import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/scheduled_pays/widgets/scheduled_pay_tile.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/reports/r_week_report.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';

class WeekReportModal extends StatelessWidget {
  RelatedWeekReport? relatedWeekReport;
  int? weekNumber;

  WeekReportModal({
    super.key,
    required this.relatedWeekReport,
    required this.weekNumber,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TextStyle genTextStyle = const TextStyle(
    fontSize: 18
  );

  @override
  Widget build(BuildContext context) {
    double totalIncome = relatedWeekReport?.totalIncome ?? 0;
    double totalExpend = relatedWeekReport?.totalExpend ?? 0;
    double totalVsLastWeek = relatedWeekReport?.totalLastWeek ?? 0;
    double comparationLastWeek = relatedWeekReport?.totalVsLastWeek ?? 0;

    return SingleChildScrollView(
      key: _scaffoldKey,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppTheme.of(context).seedBgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                spacing: 5,
                children: [
                  const Icon(Icons.calendar_month_outlined),
                  Text(
                    "${context.l10n!.week} ${weekNumber ?? "1"}",
                    style: genTextStyle
                  )
                ],
              ),
              Text(
                context.l10n!.inTheWeek,
                style: genTextStyle,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      spacing: 5,
                      children: [
                        Text(
                          context.l10n!.expend,
                          style: genTextStyle
                        ),
                        Text(
                          "${totalExpend > 0 ? "-" : ""}$totalExpend",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.of(context).redContrast
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      spacing: 5,
                      children: [
                        Text(
                          context.l10n!.income,
                          style: genTextStyle
                        ),
                        Text(
                          "${totalIncome > 0 ? "+" : ""}$totalIncome",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.of(context).greenContrast
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
              Text(
                context.l10n!.comparedToPreviousWeek,
                style: genTextStyle,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      spacing: 5,
                      children: [
                        Text(
                          "Total",
                          style: genTextStyle
                        ),
                        Text(
                          "$totalVsLastWeek",
                          style: const TextStyle(
                            fontSize: 18,
                            // color: AppTheme.of(context).redContrast
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      spacing: 5,
                      children: [
                        Text(
                          context.l10n!.comparation,
                          style: genTextStyle
                        ),
                        Text(
                          "$comparationLastWeek",
                          style: TextStyle(
                            fontSize: 18,
                            color: comparationLastWeek > 0 ? AppTheme.of(context).redContrast : AppTheme.of(context).greenContrast
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
              if (relatedWeekReport?.highExpend != null) ...[
                Text(
                  context.l10n!.greaterExpend,
                  style: genTextStyle,
                ),
                ScheduledPayTile(
                  icon: relatedWeekReport?.highExpend?.scheduledPay?.subcategory?.icon != null ? IconData(relatedWeekReport?.highExpend?.scheduledPay?.subcategory?.icon! ?? -1, fontFamily: relatedWeekReport?.highExpend?.scheduledPay?.subcategory?.iconFontFamily!) : null,
                  title: relatedWeekReport?.highExpend?.scheduledPay?.title,
                  amount: relatedWeekReport?.highExpend?.amount,
                  chipAvatar: Icon(
                    relatedWeekReport?.highExpend?.paid ?? false ? Icons.attach_money : Icons.money_off,
                    color: relatedWeekReport?.highExpend?.paid ?? false ? AppTheme.of(context).greenContrast : AppTheme.of(context).redContrast,
                  ),
                  subQuantity: relatedWeekReport?.highExpend?.balance,
                  isIncome: relatedWeekReport?.highExpend?.scheduledPay?.type != null && (relatedWeekReport?.highExpend?.scheduledPay?.type! ?? 0) > 0,
                )
              ],
              if (relatedWeekReport?.lessExpend != null) ...[
                Text(
                  context.l10n!.lessExpend,
                  style: genTextStyle,
                ),
                ScheduledPayTile(
                  icon: relatedWeekReport?.lessExpend?.scheduledPay?.subcategory?.icon != null ? IconData(relatedWeekReport?.lessExpend?.scheduledPay?.subcategory?.icon! ?? -1, fontFamily: relatedWeekReport?.lessExpend?.scheduledPay?.subcategory?.iconFontFamily!) : null,
                  title: relatedWeekReport?.lessExpend?.scheduledPay?.title,
                  amount: relatedWeekReport?.lessExpend?.amount,
                  chipAvatar: Icon(
                    relatedWeekReport?.lessExpend?.paid ?? false ? Icons.attach_money : Icons.money_off,
                    color: relatedWeekReport?.lessExpend?.paid ?? false ? AppTheme.of(context).greenContrast : AppTheme.of(context).redContrast,
                  ),
                  subQuantity: relatedWeekReport?.lessExpend?.balance,
                  isIncome: relatedWeekReport?.lessExpend?.scheduledPay?.type == ScheduledPayTypes.income.index,
                )
              ],      
            ]
          ),
        ),
      )
    );
  }
}