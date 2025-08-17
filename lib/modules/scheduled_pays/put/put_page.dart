import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/scheduled_pays/put/put_controller.dart';
import 'package:wallet/modules/scheduled_pays/put/widgets/fragments/input_currency.dart';
import 'package:wallet/modules/scheduled_pays/put/widgets/fragments/input_frecuencies.dart';
import 'package:wallet/modules/shared/drivers/local/models/currency.dart';
import 'package:wallet/modules/shared/drivers/local/models/frecuency.dart';
import 'package:wallet/modules/shared/drivers/local/models/notifications.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition_monthly.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_scheduled_pay.dart';
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
  RelatedScheduledPay? relatedScheduledPay;

  Put({
    super.key,
    this.relatedScheduledPay,
  });

  @override
  State<StatefulWidget> createState() => _PutState();
}

class _PutState extends State<Put> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); 
  final PutController _controller = PutController();
  final Utils _utils = Utils();
  ScheduledPay pay = ScheduledPay();
  FrecuencyData frecuency = FrecuencyData();

  bool incomeSelected = false;
  bool expendSelected = true;
  bool loading = false;
  Subcategories? selectedSubcategory;
  Currency? selectedCurrency;

  DateTime? date;
  TimeOfDay? time;

  ValueNotifier<DateTime?> dateMergedNotifier = ValueNotifier(null);

  late List<Currency> currencies;

  final List<DropdownMenuItem> _itemsAccountsSelect = [];
  dynamic _valueAccountsSelect;

  final List<DropdownMenuItem> _itemsNotificationsSelect = [];
  dynamic _valueNotificationSelect;

  @override
  void initState() {
    _getAll();
    _resetFrecency();
    if (widget.relatedScheduledPay != null) setAllDataFromRscheduledPay();
    super.initState();
  }

  void _resetAllSelects() {
    _valueAccountsSelect = _itemsAccountsSelect[0].value;
    if (_itemsNotificationsSelect.isNotEmpty) _valueNotificationSelect = _itemsNotificationsSelect[0].value;
  }

  void _resetFrecency() {
    frecuency.repeatEvery = RepeatEvery.once;
    frecuency.rrFor = RRFor.ever;
    frecuency.timesPlaced = 1;
    frecuency.everyNumberDay = null;
    frecuency.forDate = null;
    frecuency.repeatedTimes = null;
    frecuency.selectedDaysOfWeek = null;
    frecuency.selectedMonthlyOption = null;
    frecuency.weekNumber = null;
    frecuency.title = null;
  }

  Future<void> _getAll() async {
    List<Account> accs = await _controller.getAllAccounts();
    List<Notifications> notifications = await _controller.getAllNotifications();
    selectedCurrency = await _controller.getFirstCurrency();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      for (final account in accs) {
        _itemsAccountsSelect.add(
          DropdownMenuItem(
            value: account,
            child: Text(account.title!),
          )
        );
      }

      for (final notification in notifications) {
        _itemsNotificationsSelect.add(
          DropdownMenuItem(
            value: notification,
            child: Text(context.l10n!.getByString(notification.localeName)),
          )
        );
      }

      _resetAllSelects();
    }));
  }

  void setAllDataFromRscheduledPay() {
    pay.id = widget.relatedScheduledPay?.id;

    pay.title = widget.relatedScheduledPay?.title ?? "";
    pay.automatic = widget.relatedScheduledPay?.automatic ?? false;

    int typeIndex = (widget.relatedScheduledPay?.type ?? ScheduledPayTypes.expend.index);
    expendSelected = typeIndex == ScheduledPayTypes.expend.index;
    incomeSelected = typeIndex == ScheduledPayTypes.income.index;

    pay.categoryId = widget.relatedScheduledPay?.subcategory?.categoryId;    
    selectedSubcategory = widget.relatedScheduledPay?.subcategory;    

    pay.accountId = widget.relatedScheduledPay?.account?.id;
    pay.amount = widget.relatedScheduledPay?.amount;

    pay.currencyId = widget.relatedScheduledPay?.currency?.id;
    selectedCurrency = widget.relatedScheduledPay?.currency;

    pay.beneficiary = widget.relatedScheduledPay?.beneficiary;
    pay.note = widget.relatedScheduledPay?.note;

    pay.date = widget.relatedScheduledPay?.date;

    pay.notificationId = widget.relatedScheduledPay?.notification?.id;

    pay.frecuencyId = widget.relatedScheduledPay?.frecuency?.id;
    frecuency.forDate = widget.relatedScheduledPay?.frecuency?.forDate;
    frecuency.repeatEvery = widget.relatedScheduledPay?.frecuency?.repeatEvery;
    frecuency.repeatedTimes = widget.relatedScheduledPay?.frecuency?.repeatedTimes;
    frecuency.rrFor = widget.relatedScheduledPay?.frecuency?.rrFor;
    frecuency.selectedDaysOfWeek = widget.relatedScheduledPay?.frecuency?.recordRepetitionWeekly?.daysOfWeek;

    RecordRepetitionMonthly? recordRepetitionMonthly = widget.relatedScheduledPay?.frecuency?.recordRepetitionMonthly;

    frecuency.everyNumberDay = recordRepetitionMonthly?.everyNumberDay;
    frecuency.weekNumber = recordRepetitionMonthly?.weekNumber;

    if (recordRepetitionMonthly?.sameDayOfMonth ?? false) frecuency.selectedMonthlyOption = FrecuencyMontlyOption.sameDay;
    if (recordRepetitionMonthly?.everyLastDayOfMonth ?? false) frecuency.selectedMonthlyOption = FrecuencyMontlyOption.everyLastDay;
    if ((recordRepetitionMonthly?.weekNumber ?? -1) > 0) frecuency.selectedMonthlyOption = FrecuencyMontlyOption.everySemanalDay;

    frecuency.timesPlaced = widget.relatedScheduledPay?.frecuency?.timesPlaced;
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
        title: widget.relatedScheduledPay != null ? tr.editPay : tr.newPay,
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
                title: Text(tr.automaticPay),
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
                    child: InputCurrency(
                      controllerValue: selectedCurrency,
                      onChange: (currency) {
                        selectedCurrency = currency;
                        pay.currencyId = currency.id;
                      },
                    ),
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
                      enabled: widget.relatedScheduledPay == null,
                      selectedDate: pay.date!,
                      onChanged: (val) {
                        date = val;
                        pay.date = _utils.toDateTime(date, time);
                        dateMergedNotifier.value = pay.date;
                      }
                    )
                  ),
                  Expanded(
                    child: InputTime(
                      enabled: widget.relatedScheduledPay == null,
                      selectedTime: TimeOfDay(hour: dateMergedNotifier.value != null ? dateMergedNotifier.value!.hour : pay.date!.hour, minute: dateMergedNotifier.value != null ? dateMergedNotifier.value!.minute : pay.date!.minute),
                      onChanged: (val) {
                        time = val;
                        pay.date = _utils.toDateTime(date, time);
                        dateMergedNotifier.value = pay.date;
                      }
                    )
                  ),
                ],
              ),
              Select(
                value: _valueNotificationSelect,
                decoration: InputDecoration(
                  labelText: tr.notifications,
                ),
                items: _itemsNotificationsSelect,
                onChanged: (value) {
                  _valueNotificationSelect = value;
                  Notifications notification = value as Notifications;
                  pay.notificationId = notification.id;
                },
              ),
              InputFrecuencies(
                value: frecuency,
                onChange: (data) => frecuency = data,
                dateTimeBasedNotifier: dateMergedNotifier,
              )
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
              pay.frecuencyId = await _controller.createFrecuency(frecuency);
              RelatedScheduledPay? newPay = await _controller.putPay(pay);
              if (pay.id != null && context.mounted) context.pop(newPay);
              Map<String, Object?> payMap = pay.toMap();
              payMap.clear();
              pay = Convertions.responseToscheduledPay(payMap);
              setState(() {
                pay.date = DateTime.now();
                pay.automatic = false;
                incomeSelected = false;
                expendSelected = true;
                selectedSubcategory = null;
                _resetAllSelects();
                _resetFrecency();
                loading = false;
              });
            },
            text: tr.save,
          ),
        )
      ],
    );
  }
}