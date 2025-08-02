import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/scheduled_pays/scheduled_pays_controller.dart';
import 'package:wallet/modules/scheduled_pays/widgets/scheduled_pay_tile.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_scheduled_pay.dart';
import 'package:wallet/modules/shared/widgets/header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/modules/shared/widgets/fragments/chip.dart' as component;

class ScheduledPays extends StatefulWidget {
  const ScheduledPays({ super.key, });

  @override
  State<StatefulWidget> createState() => _ScheduledPaysState();
}

class _ScheduledPaysState extends State<ScheduledPays> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late Future<List<RelatedScheduledPay>> _pays;
  late  ScheduledPaysController _controller;

  bool allSelected = true;
  bool incomeSelected = false;
  bool expendSelected = false;

  List<component.Chip> chips = [];

  @override
  void initState() {
    super.initState();
    _controller = ScheduledPaysController();
    _pays = _controller.getScheduledPays();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;

    chips = [
      component.Chip(
        text: tr.all,
        selected: allSelected,
        txtColor: allSelected ? Colors.black : AppTheme.of(context).textContrast,
        onSelected: (isSelected) {
          setState(() {
            allSelected = true;
            incomeSelected = false;
            expendSelected = false;
            _pays = _controller.getScheduledPays();
          });
        },
      ),
      component.Chip(
        text: tr.income,
        selected: incomeSelected,
        txtColor: incomeSelected ? AppTheme.of(context).greenDark : AppTheme.of(context).greenContrast,
        onSelected: (isSelected) {
          setState(() {
            allSelected = false;
            incomeSelected = true;
            expendSelected = false;
            _pays = _controller.getScheduledPays(type: 1);
          });
        },
      ),
      component.Chip(
        text: tr.expend,
        selected: expendSelected,
        txtColor: expendSelected ? AppTheme.of(context).redDark : AppTheme.of(context).redContrast,
        onSelected: (isSelected) {
          setState(() {
            allSelected = false;
            incomeSelected = false;
            expendSelected = true;
            _pays = _controller.getScheduledPays(type: 0);
          });
        },
      )
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: CHeader(
        title: tr.pays,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push("/scheduled_pays/put"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            spacing: 15,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 32,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: chips.length,
                  itemBuilder: (_, i) => Padding(
                    padding: EdgeInsets.only(left: i > 0 ? 10 : 0),
                    child: chips[i],
                  ),
                )
              ),
              Flexible(
                child: Card(
                  elevation: 0,
                  color: AppTheme.of(context).seedBgColor,
                  child: FutureBuilder<List<RelatedScheduledPay>>(
                    future: _pays,
                    builder: (BuildContext context, AsyncSnapshot<List<RelatedScheduledPay>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, i) => Padding(
                              padding: EdgeInsets.only(top: i > 0 ? 15 : 0, bottom: (i == (snapshot.data?.length ?? 0) - 1) ? 15 : 0),
                              child: ScheduledPayTile(
                                icon: snapshot.data?[i].subcategory?.icon != null ? IconData(snapshot.data?[i].subcategory?.icon! ?? -1, fontFamily: snapshot.data?[i].subcategory?.iconFontFamily!) : null,
                                title: snapshot.data?[i].title,
                                amount: snapshot.data?[i].amount,
                                isIncome: snapshot.data?[i].type != null && (snapshot.data?[i].type! ?? 0) > 0,
                                onTap: () => context.push("/scheduled_pays/pay_info", extra: snapshot.data?[i]),
                              ),
                            ),
                            itemCount: snapshot.data?.length,
                          );
                        }
                        return Text(tr.youDontHaveAnyDataToShow, textAlign: TextAlign.center,);
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }
}