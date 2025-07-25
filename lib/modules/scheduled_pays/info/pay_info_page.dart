import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/scheduled_pays/info/pay_info_controller.dart';
import 'package:wallet/modules/scheduled_pays/info/widgets/modals/custom_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_scheduled_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';
import 'package:wallet/modules/shared/widgets/fragments/bordered_container.dart';
import 'package:wallet/modules/shared/widgets/header.dart';

class PayInfoPage extends StatefulWidget {
  RelatedScheduledPay? relatedScheduledPay;

  PayInfoPage({
    super.key,
    this.relatedScheduledPay,
  });

  @override
  State<StatefulWidget> createState() => _PayInfoPageState();
}

class _PayInfoPageState extends State<PayInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final PayInfoController _controller = PayInfoController();
  Future<List<RelatedRecord>>? _records;

  @override
  void initState() {
    _records = _controller.insertRecord(scheculedPayId: widget.relatedScheduledPay?.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isIncome = ScheduledPayTypes.values[widget.relatedScheduledPay?.type! ?? 0] == ScheduledPayTypes.income;

    String every = context.l10n!.every;
    int? timesPlaced = widget.relatedScheduledPay?.frecuency?.timesPlaced;
    bool timesPLacedGreatherThanOne = timesPlaced.toBool() && timesPlaced! > 1;

    if (timesPLacedGreatherThanOne) every += " ${timesPlaced.toString()}";

    switch (widget.relatedScheduledPay?.frecuency?.repeatEvery) {
      case RepeatEvery.day:
        every = timesPLacedGreatherThanOne ? "$every ${context.l10n!.days}" : context.l10n!.everyDay;
        break;
      case RepeatEvery.week:
        every = timesPLacedGreatherThanOne ? "$every ${context.l10n!.weeks}" : context.l10n!.everyWeek;
        break;
      case RepeatEvery.month:
        every = timesPLacedGreatherThanOne ? "$every ${context.l10n!.months}" : context.l10n!.everyMonth;
        break;
      case RepeatEvery.anual:
        every = timesPLacedGreatherThanOne ? "$every ${context.l10n!.years}" : context.l10n!.everyYear;
        break;
      default:
        every = context.l10n!.once;
        // NOTHING
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: CHeader(
        title: context.l10n!.payData
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppTheme.of(context).primary,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.relatedScheduledPay?.title ?? "",
                        style: TextStyle(
                          fontSize: 32,
                          color: AppTheme.of(context).textBlack
                        ),
                      ),
                      BorderedContainer(
                        children: [
                          Text(
                            isIncome ? context.l10n!.income : context.l10n!.expend,
                            style: TextStyle(
                              fontSize: 16,
                              color: isIncome ? AppTheme.of(context).greenContrast : AppTheme.of(context).redContrast
                            ),
                          ),
                          if (widget.relatedScheduledPay?.automatic ?? false)
                            Text(
                              "- ${context.l10n!.automaticPay}",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.of(context).textContrast
                              ),
                            )
                        ],
                      ),
                      Text(
                        "${context.l10n!.from} ${DateFormat.LLLL().format(widget.relatedScheduledPay?.date ?? DateTime.now())} ${context.l10n!.ofDel} ${widget.relatedScheduledPay?.date?.year} • $every",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.of(context).textBlack
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                "${context.l10n!.records}:",
                style: TextStyle(
                  fontSize: 24,
                  color: AppTheme.of(context).textContrast,
                ),
              ),

              FutureBuilder<List<RelatedRecord>>(
                  future: _records,
                  builder: (BuildContext context, AsyncSnapshot<List<RelatedRecord>> snapshotRecords) {
                    if (snapshotRecords.hasData) {
                      if (snapshotRecords.data!.isNotEmpty){
                        DateTime now = DateTime.now();

                        List<ListTile> allTiles = [];
                        for (final record in snapshotRecords.data!) {
                          int diff = now.day - (record.date?.day ?? 0);
                          bool lessThanToday = now.day > (record.date?.day ?? 0);
                          bool isToday = record.date?.day == now.day;

                          allTiles.add(
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                              shape: Border(
                                top: BorderSide(
                                  color: AppTheme.of(context).textContrast,
                                  width: 1,   
                                )
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat.yMd(context.l10n!.localeName).format(record.datePaid ?? record.date!),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.of(context).textContrast
                                        ),
                                      ),
                                      Text(
                                        context.l10n!.getByString(record.expired.toBool() ? "pending" : (record.paid.toBool() ? "paid" : "refused")).toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: record.expired.toBool() ? AppTheme.of(context).yellowBlack : (record.paid.toBool() ? AppTheme.of(context).greenContrast : AppTheme.of(context).redContrast),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (record.expired.toBool())
                                        Row(
                                          spacing: 5,
                                          children: [
                                            if (widget.relatedScheduledPay?.frecuency?.repeatEvery != RepeatEvery.once && !isToday)
                                              ...[
                                                Icon(
                                                  Icons.alarm,
                                                  color: lessThanToday ? AppTheme.of(context).redContrast : AppTheme.of(context).yellowBlack,
                                                ),
                                                Text(
                                                  "${diff.abs()} ${context.l10n!.getByString("day${diff.abs() > 1 ? "s" : ""}").toLowerCase()}",
                                                  style: TextStyle(
                                                    color: lessThanToday ? AppTheme.of(context).redContrast : AppTheme.of(context).yellowBlack
                                                  ),
                                                ),
                                              ],
                                              PopupMenuButton(
                                                icon: const Icon(Icons.more_vert),
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    onTap: () => showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) => CustomPay(
                                                        lastAmount: record.scheduledPay?.amount,
                                                        selectedDate: record.date,
                                                        onSave: (data) => setState(() {                                                          
                                                          _records = _controller.updateLastRecordIfExist(
                                                            scheculedPayId: widget.relatedScheduledPay?.id,
                                                            recordId: record.id,
                                                            paid: true,
                                                            datetime: data.datetime,
                                                            amount: data.amount
                                                          );
                                                        })
                                                      )
                                                    ),
                                                    child: Row(
                                                      spacing: 10,
                                                      children: [
                                                        Icon(Icons.edit, color: AppTheme.of(context).greenContrast,),
                                                        Text(
                                                          context.l10n!.customPay,
                                                          style: TextStyle(
                                                            color: AppTheme.of(context).greenContrast
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                  PopupMenuItem(
                                                    onTap: () => setState(() {
                                                      _records = _controller.updateLastRecordIfExist(
                                                        scheculedPayId: widget.relatedScheduledPay?.id,
                                                        recordId: record.id,
                                                        paid: true,
                                                      );
                                                    }),
                                                    child: Row(
                                                      spacing: 10,
                                                      children: [
                                                        Icon(Icons.done, color: AppTheme.of(context).greenContrast,),
                                                        Text(
                                                          context.l10n!.pay,
                                                          style: TextStyle(
                                                            color: AppTheme.of(context).greenContrast
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                  PopupMenuItem(
                                                    onTap: () => setState(() {
                                                      _records = _controller.updateLastRecordIfExist(
                                                        scheculedPayId: widget.relatedScheduledPay?.id,
                                                        recordId: record.id,
                                                        paid: false,
                                                      );
                                                    }),
                                                    child: Row(
                                                      spacing: 10,
                                                      children: [
                                                        Icon(Icons.delete_sharp, color: AppTheme.of(context).redContrast,),
                                                        Text(
                                                          context.l10n!.refuse,
                                                          style: TextStyle(
                                                            color: AppTheme.of(context).redContrast
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                ] ,
                                              )
                                          ],
                                        ),
                                      if (record.paid.toBool())
                                        Text(
                                          "${isIncome ? "+" : "-"}${record.amount}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isIncome ? AppTheme.of(context).greenContrast : AppTheme.of(context).redContrast
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              )
                            )
                          );
                        }
                        
                        return Flexible(
                          child: Card(
                            elevation: 0,
                            color: AppTheme.of(context).seedBgColor,
                            child: ListView.builder(
                                itemCount: allTiles.length,
                                shrinkWrap: true,
                                itemBuilder: (context, i) => allTiles[i]
                            ),
                          )
                        );
                      } else return Text(context.l10n!.youDontHaveAnyDataToShow);
                    }
                
                    return const Center(
                      child: CircularProgressIndicator()
                    );
                  }
                ),
            ]
          ),
        )
      )
    );
  }
}