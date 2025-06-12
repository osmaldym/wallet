import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/scheduled_pays/put/put_controller.dart';
import 'package:wallet/modules/shared/drivers/local/models/subcategories.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_categories.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart';
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
  Subcategories? selectedSubcategory;

  DateTime? date;
  TimeOfDay? time;

  dynamic _valueAccountsSelect;

  final List<DropdownMenuItem> _itemsExamples = [
    const DropdownMenuItem(
      value: "one",
      child: Text("one"),
    ),
    const DropdownMenuItem(
      value: "two",
      child: Text("two"),
    ),
    const DropdownMenuItem(
      value: "three",
      child: Text("three"),
    )
  ];

  final List<DropdownMenuItem> _itemsAccountsSelect = [
    DropdownMenuItem(
      value: Account(title: "Total"),
      child: const Text("Total"),
    )
  ];

  @override
  void initState() {
    super.initState();
    _getAll();
    _resetAllSelects();
  }

  void _resetAllSelects() {
    _valueAccountsSelect = _itemsAccountsSelect[0].value;
  }

  Future<void> _getAll() async {
    List<Account> accs = await _controller.getAllAccounts();
    
    for (final account in accs){
      _itemsAccountsSelect.add(
        DropdownMenuItem(
          value: account,
          child: Text(account.title!),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;
    pay.type = incomeSelected ? ScheduledPayTypes.income.index : ScheduledPayTypes.expend.index;
    pay.date ??= DateTime.now();
    pay.automatic ??= false;
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
              CheckboxListTile(
                value: pay.automatic,
                onChanged: (isChecked) => setState(() { pay.automatic = isChecked!; }),
                dense: false,
                enabled: true,
                enableFeedback: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Automatic pay"),
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
              InputCategories(
                decoration: InputDecoration(
                  labelText: tr.category,
                ),
                controllerValue: selectedSubcategory,
                onChange: (subcategory) {
                  selectedSubcategory = subcategory;
                  pay.categoryId = subcategory.id;
                }
              ),
              Select(
                value: _valueAccountsSelect,
                decoration: InputDecoration(
                  labelText: tr.account
                ),
                items: _itemsAccountsSelect,
                onChanged: (value) {
                  _valueAccountsSelect = value;
                  Account acc = value as Account;
                  pay.accountId = acc.id;
                },
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
                      items: _itemsExamples,
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
                items: _itemsExamples,
              ),
              Select(
                decoration: InputDecoration(
                  labelText: tr.frecuency,
                ),
                items: _itemsExamples,
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
                pay.automatic = false;
                incomeSelected = false;
                expendSelected = true;
                selectedSubcategory = null;
                _resetAllSelects();
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