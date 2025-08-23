import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/core/constants/app_route.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/extensions/datetime_ext.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/records/records_controller.dart';
import 'package:wallet/modules/scheduled_pays/info/widgets/modals/custom_pay.dart';
import 'package:wallet/modules/scheduled_pays/widgets/scheduled_pay_tile.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';
import 'package:wallet/modules/shared/widgets/fragments/expandable_fab.dart';
import 'package:wallet/modules/shared/widgets/fragments/flexible_card.dart';
import 'package:wallet/modules/shared/widgets/fragments/full_size_message.dart';
import 'package:wallet/modules/shared/widgets/header.dart';
import 'package:wallet/modules/shared/widgets/fragments/chip.dart' as component;

class RecordsPage extends StatefulWidget {
  const RecordsPage({
    super.key,
    
  });

  @override
  State<StatefulWidget> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final RecordsController _controller = RecordsController();
  final Utils _utils = Utils();
  List<component.Chip>? _chips;
  Future<List<RelatedRecord>>? _relatedRecords;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool allSelected = true;
  bool incomeSelected = false;
  bool expendSelected = false;

  DateTime? dateFrom;
  DateTime? dateTo;

  List<Widget>? _allWidgetsToShow;

  void selectOnly({ bool? allSelected, bool? incomeSelected, bool? expendSelected }) {
    this.allSelected = allSelected ?? false;
    this.incomeSelected = incomeSelected ?? false;
    this.expendSelected = expendSelected ?? false;
  }

  @override
  void initState() {
    dateFrom = DateTime.now().recreateInTimeZero().recreate(day: 1);
    _relatedRecords = _controller.getRecords(dateFrom: dateFrom);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _chips = [
      component.Chip(
        text: context.l10n!.all,
        selected: allSelected,
        txtColor: allSelected ? Colors.black : AppTheme.of(context).textContrast,
        onSelected: (isSelected) {
          setState(() {
            selectOnly(allSelected: true);
            _relatedRecords = _controller.getRecords(dateFrom: dateFrom);
          });
        },
      ),
      component.Chip(
        text: context.l10n!.income,
        selected: incomeSelected,
        txtColor: incomeSelected ? AppTheme.of(context).greenDark : AppTheme.of(context).greenContrast,
        onSelected: (isSelected) {
          setState(() {
            selectOnly(incomeSelected: true);
            _relatedRecords = _controller.getRecords(type: 1, dateFrom: dateFrom);
          });
        },
      ),
      component.Chip(
        text: context.l10n!.expend,
        selected: expendSelected,
        txtColor: expendSelected ? AppTheme.of(context).redDark : AppTheme.of(context).redContrast,
        onSelected: (isSelected) {
          setState(() {
            selectOnly(expendSelected: true);
            _relatedRecords = _controller.getRecords(type: 0, dateFrom: dateFrom);
          });
        },
      )
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: CHeader(
        title: context.l10n!.records,
      ),
      floatingActionButton: ExpandableFab(
        items: [
          ExpandableFabItem(
            icon: Icons.money,
            helper: context.l10n!.newPay,
            onTapped: () => context.push(AppRoute.scheduledPays),
          )
        ],
      ),
      body:  SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 32,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _chips!.length,
                  itemBuilder: (_, i) => Padding(
                    padding: EdgeInsets.only(left: i > 0 ? 10 : 0),
                    child: _chips![i],
                  ),
                )
              ),
              FlexibleCard(
                forList: true,
                child: FutureBuilder<List<RelatedRecord>>(
                  future: _relatedRecords,
                  builder: (BuildContext context, AsyncSnapshot<List<RelatedRecord>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        DateTime? lastDate;

                        if (snapshot.data!.isNotEmpty) {
                          if (_allWidgetsToShow != null) _allWidgetsToShow!.clear();
                          else _allWidgetsToShow = [];

                          for (int i = 0; i < snapshot.data!.length; i++) {
                            bool printedWeekNumber = false;
                            int? weekPositionOfRecord = snapshot.data?[i].datePaid?.getWeekPositionInMonth();

                            if (lastDate?.getWeekPositionInMonth() != weekPositionOfRecord) {
                              _allWidgetsToShow!.add(
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${context.l10n!.week} $weekPositionOfRecord"
                                      ),
                                    ],
                                  )
                                )
                              );
                              printedWeekNumber = true;
                            }

                            _allWidgetsToShow!.add(
                              Padding(
                                padding: EdgeInsets.only(top: i > 0 && !printedWeekNumber ? 15 : 0, bottom: (i == (snapshot.data?.length ?? 0) - 1) ? 15 : 0),
                                child: ScheduledPayTile(
                                  icon: snapshot.data?[i].scheduledPay?.subcategory?.icon != null ? IconData(snapshot.data?[i].scheduledPay?.subcategory?.icon! ?? -1, fontFamily: snapshot.data?[i].scheduledPay?.subcategory?.iconFontFamily!) : null,
                                  title: snapshot.data?[i].scheduledPay?.title,
                                  amount: snapshot.data?[i].amount,
                                  chipAvatar: Icon(
                                    snapshot.data?[i].paid ?? false ? Icons.attach_money : Icons.money_off,
                                    color: snapshot.data?[i].paid ?? false ? AppTheme.of(context).greenContrast : AppTheme.of(context).redContrast,
                                  ),
                                  subQuantity: snapshot.data?[i].balance,
                                  isIncome: snapshot.data?[i].scheduledPay?.type != null && (snapshot.data?[i].scheduledPay?.type! ?? 0) > 0,
                                  onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: (context) => CustomPay(
                                      isPaid: snapshot.data?[i].paid,
                                      title: context.l10n!.editRecord,
                                      lastAmount: snapshot.data?[i].amount,
                                      selectedDate: snapshot.data?[i].date,
                                      onSave: (data) {
                                        _controller.updateRecord(
                                          scheduledPayId: snapshot.data?[i].scheduledPay?.id,
                                          recordId: snapshot.data?[i].id,
                                          datetime: data.datetime,
                                          amount: data.amount,
                                          paid: data.paid
                                        );
                                        setState(() {
                                          _relatedRecords = _controller.getRecords();
                                        });
                                      }
                                    )
                                  ),
                                ),
                              )
                            );

                            lastDate = snapshot.data?[i].datePaid;
                          }
                        }

                        return snapshot.data!.isEmpty ? FullSizeMessage(
                          iconData: Icons.money_off,
                          title: context.l10n!.theresNoRecordsToShowYet,
                          subtitle: GestureDetector(
                            onTap: () => context.push(AppRoute.scheduledPaysPut).then((_) => setState(() { _relatedRecords = _controller.getRecords(); })),
                            child: Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  context.l10n!.createANewPay,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppTheme.of(context).textContrast
                                  ),
                                ),
                                Icon(
                                  Icons.open_in_new,
                                  color: AppTheme.of(context).textContrast,
                                )
                              ],
                            )
                          ),
                        ) : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, i) => _allWidgetsToShow?[i],
                          itemCount: _allWidgetsToShow?.length,
                        );
                      }

                      if (snapshot.hasError) _utils.showSnackBarMessage(context, "${context.l10n?.errorLoading}: ${snapshot.error}", error: true);

                      return Text(context.l10n!.youDontHaveAnyDataToShow, textAlign: TextAlign.center,);
                    }
                    return const CircularProgressIndicator();
                  },
                ), 
              )
            ],
          ),
        ),
      ),
    );
  }
}