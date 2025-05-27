import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/scheduled_pays/put/put_controller.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/chip.dart' as component;
import 'package:wallet/modules/shared/widgets/fragments/input_calculator.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_time.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_date.dart';
import 'package:wallet/modules/shared/widgets/fragments/select.dart';
import 'package:wallet/modules/shared/widgets/header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Put extends StatefulWidget {
  const Put({ super.key });

  @override
  State<StatefulWidget> createState() => _PutState();
}

class _PutState extends State<Put> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final PutController _controller = PutController();
  final Utils _utils = Utils();
  ScheduledPay pay = ScheduledPay();

  bool incomeSelected = false;
  bool expendSelected = true;
  bool loading = false;

  DateTime? date;
  TimeOfDay? time;

  List<String> optionsExample = ["One", "Two", "Three"];

  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;
    pay.type = incomeSelected ? ScheduledPayTypes.income.index : ScheduledPayTypes.expend.index;
    pay.date ??= DateTime.now();
    return Scaffold(
      key: _scaffoldKey,
      appBar: CHeader(
        title: tr.newPay,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 15
          ),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: tr.title,
                ),
                controller: TextEditingController(
                  text: pay.title,
                ),
                onChanged: (val) => pay.title = val,
              ),
              Text(
                tr.type,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 15,
                children: [
                  Expanded(
                    child: component.Chip(
                      selected: expendSelected,
                      text: tr.expend,
                      width: double.maxFinite,
                      txtColor: expendSelected ? AppTheme.of(context).redDark : AppTheme.of(context).redContrast,
                      onSelected: (bool isSelected) => setState(() {
                        expendSelected = isSelected;
                        incomeSelected = !isSelected;
                      }),
                    ),
                  ),
                  Expanded(
                    child: component.Chip(
                      selected: incomeSelected,
                      text: tr.income,
                      width: double.maxFinite,
                      txtColor: incomeSelected ? AppTheme.of(context).greenDark : AppTheme.of(context).greenContrast,
                      onSelected: (bool isSelected) => setState(() {
                        incomeSelected = isSelected;
                        expendSelected = !isSelected;
                      })
                    ),
                  ),
                ],
              ),
              Select(
                decoration: InputDecoration(
                  labelText: tr.category
                ),
                items: optionsExample,
              ),
              Select(
                decoration: InputDecoration(
                  labelText: tr.account
                ),
                items: optionsExample,
              ),
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: InputCalculator(
                      controllerValue: pay.amount,
                      onChange: (val) => pay.amount = val,
                    ),
                  ),
                  Expanded(
                    child: Select(
                      expand: false,
                      decoration: InputDecoration(
                        labelText: tr.currency
                      ),
                      items: optionsExample,
                    )
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: tr.beneficiary,
                ),
                controller: TextEditingController(
                  text: pay.beneficiary,
                ),
                onChanged: (val) => pay.beneficiary = val,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: tr.note,
                ),
                controller: TextEditingController(
                  text: pay.note,
                ),
                minLines: 1,
                maxLines: 10,
                onChanged: (val) => pay.note = val,
              ),
              Text(
                tr.dateAndFrecuency,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: InputDate(
                      selectedDate: pay.date!,
                      onChanged: (val) {
                        date = val;
                        pay.date = _utils.toDateTime(date, time);
                      }
                    )
                  ),
                  Expanded(
                    child: InputTime(
                      selectedTime: TimeOfDay(hour: pay.date!.hour, minute: pay.date!.minute),
                      onChanged: (val) {
                        time = val;
                        pay.date = _utils.toDateTime(date, time);
                      }
                    )
                  ),
                ],
              ),
              Select(
                decoration: InputDecoration(
                  labelText: tr.notifications,
                ),
                items: optionsExample,
              ),
              Select(
                decoration: InputDecoration(
                  labelText: tr.frecuency,
                ),
                items: optionsExample,
              ),
            ],
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
              await _controller.createPay(pay);
              Map<String, Object?> payMap = pay.toMap();
              payMap.clear();
              pay = Convertions.responseToScheculedPay(payMap);
              setState(() {
                pay.date = DateTime.now();
                loading = false;
              });
            },
            text: "Save",
          ),
        )
      ],
    );
  }
}