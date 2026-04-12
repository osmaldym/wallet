import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/goals/put/put_controller.dart';
import 'package:wallet/modules/scheduled_pays/put/widgets/fragments/input_frecuencies.dart';
import 'package:wallet/modules/shared/drivers/local/models/frecuency.dart';
import 'package:wallet/modules/shared/drivers/local/models/goal.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_goals.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_calculator.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_date.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_icons.dart';
import 'package:wallet/modules/shared/widgets/header.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/widgets/fragments/chip.dart' as component;

class PutPage extends StatefulWidget {
  RelatedGoal? relatedGoal;

  PutPage({ 
    super.key,
    this.relatedGoal,
  });

  @override
  State<StatefulWidget> createState() => _PutPageState();
}

class _PutPageState extends State<PutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  RelatedGoal? goal;
  final PutController _controller = PutController();
  FrecuencyData frecuency = FrecuencyData();
  bool automatic = false;
  bool manual = true;
  bool loading = false;

  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();

  @override
  void initState() {
    goal ??= widget.relatedGoal ?? RelatedGoal();
    super.initState();
    frecuency.clear();
    resetDates();

    title.text = goal!.title ?? '';
    note.text = goal!.note ?? '';
  }

  void resetDates() {
    goal!.dateTo ??= DateTime.now();
    goal!.dateFrom ??= DateTime.now();
  }

  @override
  void dispose() {
    title.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CHeader(
        title: goal?.id != null ? context.l10n!.editGoal : context.l10n!.new_goal,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child:  Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: context.l10n!.title,
                  ),
                  controller: title,
                  onChanged: (val) => goal!.title = val,
                ),
                InputIcon(
                  selectedIcon: goal!.icon,
                  onChange: (icon) {
                    goal!.icon = icon;
                    goal!.iconId = goal!.icon?.id;
                  }
                ),
                InputCalculator(
                  decoration: InputDecoration(
                    labelText: context.l10n!.total
                  ),
                  currentValue: goal!.total,
                  onChange: (double? val) => goal!.total = val,
                ),
                InputCalculator(
                  decoration: InputDecoration(
                    labelText: context.l10n!.saved
                  ),
                  currentValue: goal!.saved,
                  onChange: (double? val) => goal!.saved = val,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  spacing: 15,
                  children: [
                    Expanded(
                      child: component.Chip(
                        selected: automatic,
                        text: context.l10n!.automatic,
                        width: double.maxFinite,
                        txtColor: automatic ? AppTheme.of(context).redDark : AppTheme.of(context).redContrast,
                        onSelected: (bool isSelected) => setState(() {
                          automatic = isSelected;
                          manual = !isSelected;
                        }),
                      ),
                    ),
                    Expanded(
                      child: component.Chip(
                        selected: manual,
                        text: context.l10n!.manual,
                        width: double.maxFinite,
                        txtColor: manual ? AppTheme.of(context).greenDark : AppTheme.of(context).greenContrast,
                        onSelected: (bool isSelected) => setState(() {
                          manual = isSelected;
                          automatic = !isSelected;
                        })
                      ),
                    ),
                  ],
                ),
                if (automatic)
                  InputCalculator(
                    decoration: InputDecoration(
                      labelText: context.l10n!.automaticAdding
                    ),
                    currentValue: goal!.autoSaving,
                    onChange: (double? val) => goal!.autoSaving = val,
                  ),
                
                Text(
                  context.l10n!.dateAndFrecuency,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child:
                        InputDate(
                          title: context.l10n!.from,
                          // enabled: widget.relatedScheduledPay == null,
                          selectedDate: goal!.dateFrom ?? DateTime.now(),
                          onChanged: (val) => goal!.dateFrom = val
                        ),
                    ),
                    Expanded(
                      child:
                      InputDate(
                        title: context.l10n!.to,
                        // enabled: widget.relatedScheduledPay == null,
                        selectedDate: goal!.dateTo ?? DateTime.now(),
                        onChanged: (val) => goal!.dateTo = val
                      ),
                    ),

                  ],
                ),

                if (automatic)
                  InputFrecuencies(
                    value: frecuency,
                    onChange: (data) => frecuency = data,
                  ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: context.l10n!.note,
                  ),
                  controller: note,
                  onChanged: (val) => goal!.note = val,
                ),
              ],
            ),
          ), 
        ),
      ),
      persistentFooterButtons: [
        Container(
          padding: const EdgeInsets.all(10),
          child: CButton(
            isLoading: loading,
            onPressed: () async {
              setState(() { loading = true; });

              RelatedGoal? insertedGoal = await _controller.putGoal(goal!);
              if (goal?.id != null && context.mounted) context.pop(insertedGoal);

              if (insertedGoal != null) {
                resetDates();

                if (goal?.id == null)
                  // If I clear the original instance, doesn't update with the new intance for some reason if editing
                  goal!.clear(); 

                note.clear();
                title.clear();
              }

              setState(() { loading = false; });
            },
            text: context.l10n!.save,
          ),
        )
      ]
    );
  }
}