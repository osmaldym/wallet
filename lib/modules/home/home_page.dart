import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/home/home_controller.dart';
import 'package:wallet/modules/scheduled_pays/info/widgets/modals/custom_pay.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_record.dart';
import 'package:wallet/modules/shared/widgets/fragments/expandable_fab.dart';
import 'package:wallet/modules/shared/widgets/fragments/account.dart';
import 'package:wallet/modules/shared/widgets/fragments/flexible_card.dart';
import 'package:wallet/modules/shared/widgets/fragments/full_size_message.dart';
import 'package:wallet/modules/shared/widgets/fragments/next_pay_tile.dart';
import 'package:wallet/modules/shared/widgets/header.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/modules/shared/widgets/menu.dart';
import 'package:wallet/modules/home/presenters/widgets/account.dart';

class Home extends StatefulWidget {
  const Home({ super.key });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final Utils _utils = Utils();

  late Future<List<Account>> _accs;
  Future<List<RelatedRecord?>>? _records;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _updateAccounts();
    _reloadRecords();
    _controller.createSession();
  }

  void _updateAccounts() => setState(() {
    _accs = _controller.getAccounts();
  });

  void _reloadRecords() => _records = _controller.getRecords();

  @override
  Widget build(BuildContext context){
    AppLocalizations? tr = AppLocalizations.of(context)!;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CHeader(
        title: tr.account,
        leadingIcon: Icons.menu,
        onLeadingPressed: () => _scaffoldKey.currentState!.openDrawer(),
        onTrailingPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) => AccountModal(
            onSave: (String name) async {
              await _controller.addAccount(name);
              _updateAccounts();
            }
          )
        ),
      ),
      floatingActionButton: ExpandableFab(
        items: [
          ExpandableFabItem(
            icon: Icons.money,
            helper: tr.newPay,
            onTapped: () => context.push("/scheduled_pays").then((_) => setState(() { _reloadRecords(); })),
          )
        ],
      ),
      drawer: Menu(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                alignment: Alignment.center,
                child: FutureBuilder<List<Account>>(
                  future: _accs,
                  builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, i) => Padding(
                          padding: EdgeInsets.only(left: i > 0 ? 5 : 0),
                          child: snapshot.data?[i],
                        ),
                        itemCount: snapshot.data?.length,
                      );
                    }
                    return Text(tr.youDontHaveAnyDataToShow);
                  },
                )
              ),
              GestureDetector(
                onTap: () => context.push("/scheduled_pays/put").then((_) => setState(() { _reloadRecords(); })),
                child: Text(
                  context.l10n!.nextPays,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 34
                  ),
                ),
              ),
              FutureBuilder<List<RelatedRecord?>>(
                future: _records,
                builder: (BuildContext context, AsyncSnapshot<List<RelatedRecord?>> snapshot) {
                  if (snapshot.hasData) {
                    return FlexibleCard(
                      color: AppTheme.of(context).primary,
                      child: SizedBox(
                        height: 300,
                        child: snapshot.data!.isEmpty ? FullSizeMessage(
                          iconData: Icons.money_off,
                          title: context.l10n!.theresNoRecordsToShowYet,
                          iconColor: AppTheme.of(context).primary,
                          fillColor: AppTheme.of(context).seedBgColor,
                          subtitle: GestureDetector(
                            onTap: () => context.push("/scheduled_pays/put").then((_) => setState(() { _reloadRecords(); })),
                            child: Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  context.l10n!.createANewPay,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                  ),
                                ),
                                const Icon(
                                  Icons.open_in_new,
                                  color: Colors.black,
                                )
                              ],
                            )
                          ),
                        ) : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            RelatedRecord? record = snapshot.data?[i];
                            return NextPayTile(
                              backgroundColor: Colors.transparent,
                              icon: record?.scheduledPay?.subcategory?.icon != null ? IconData(record?.scheduledPay?.subcategory?.icon! ?? -1, fontFamily: record?.scheduledPay?.subcategory?.iconFontFamily!) : null,
                              title: record?.scheduledPay?.title,
                              amount: record?.scheduledPay?.amount,
                              isIncome: record?.scheduledPay?.type != null && (record?.scheduledPay?.type! ?? 0) > 0,
                              date: record?.datePaid ?? record?.date,
                              onTap: () => context.push("/scheduled_pays/pay_info", extra: snapshot.data?[i]?.scheduledPay).then((_) => setState(() { _reloadRecords(); })),
                              onOptionPostponePressed: () => showModalBottomSheet(
                                context: context,
                                builder: (context) => CustomPay(
                                  title: context.l10n!.postponePay,
                                  onlyShowDate: true,
                                  lastAmount: record?.scheduledPay?.amount,
                                  selectedDate: record?.date,
                                  onSave: (data) async {
                                    await _controller.postponeLastRecord(
                                      scheduledPayId: record?.scheduledPay?.id,
                                      recordId: record?.id,
                                      datetime: data.datetime
                                    );
                                    setState(() { _reloadRecords(); });
                                  }
                                ),
                              ),
                              onOptionCustomPayPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (context) => CustomPay(
                                  lastAmount: record?.scheduledPay?.amount,
                                  selectedDate: record?.date,
                                  onSave: (data) async  {
                                    await _controller.updateLastRecordIfExist(
                                      scheduledPayId: record?.scheduledPay?.id,
                                      recordId: record?.id,
                                      paid: true,
                                      datetime: data.datetime,
                                      amount: data.amount
                                    );

                                    setState(() { _reloadRecords(); });
                                  }
                                )
                              ),
                              onOptionPayPressed: () async {
                                await _controller.updateLastRecordIfExist(
                                  scheduledPayId: record?.scheduledPay?.id,
                                  recordId: record?.id,
                                  paid: true,
                                );
                                
                                setState(() { _reloadRecords(); });
                              },
                              onOptionRefusePressed: () async  {
                                await _controller.updateLastRecordIfExist(
                                  scheduledPayId: record?.scheduledPay?.id,
                                  recordId: record?.id,
                                  paid: false,
                                );
                                setState(() { _reloadRecords(); });
                              },
                            );
                          },
                          itemCount: snapshot.data?.length,
                        ),
                      )
                    );
                  }

                  if (snapshot.hasError)
                    _utils.showSnackBarMessage(context, snapshot.error.toString());

                  return const CircularProgressIndicator();
                }
              ),
            ],
          ),
        )
      ),
    );
  }
}