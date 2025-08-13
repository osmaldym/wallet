import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/extensions/datetime_ext.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_calculator.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_date.dart';
import 'package:wallet/modules/shared/widgets/fragments/chip.dart' as component;
import 'package:wallet/modules/shared/widgets/fragments/input_time.dart';

class CustomPayData {
  DateTime? datetime;
  double? amount;
  bool? paid;

  CustomPayData({
    this.datetime,
    this.amount,
    this.paid,
  });
}

class CustomPay extends StatelessWidget {
  CustomPayData dataToReturn = CustomPayData();
  bool loading = false;
  bool? onlyShowDate;
  String? title;

  void Function(CustomPayData data)? onSave;
  DateTime? selectedDate;
  double? lastAmount;
  bool? isPaid;

  final ValueNotifier<bool> _refusedSelected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _paidSelected = ValueNotifier<bool>(false);

  void setSelectedChipByOne({bool? boolean}) {
    _paidSelected.value = (boolean ?? false);
    _refusedSelected.value = !(boolean ?? false);
    dataToReturn.paid = _paidSelected.value;
  }

  CustomPay({
    super.key,
    this.onSave,
    this.selectedDate,
    this.lastAmount,
    this.onlyShowDate,
    this.title,
    this.isPaid,
  });

  @override
  StatelessElement createElement() {
    dataToReturn.amount = lastAmount;
    setSelectedChipByOne(boolean: isPaid);
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              Text(
                title ?? context.l10n!.customPay, 
                style: const TextStyle(
                  fontSize: 28
                ),
              ),
              if (isPaid != null)
                Row(
                  spacing: 10,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _refusedSelected,
                      builder: (context, selected, child) => Expanded(
                        child: component.Chip(
                          selected: selected,
                          text: context.l10n!.refused,
                          width: double.maxFinite,
                          txtColor: selected ? AppTheme.of(context).redDark : AppTheme.of(context).redContrast,
                          onSelected: (bool isSelected) => setSelectedChipByOne(boolean: !isSelected),
                        ),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _paidSelected,
                      builder: (context, selected, child) => Expanded(
                        child: component.Chip(
                          selected: selected,
                          text: context.l10n!.paid,
                          width: double.maxFinite,
                          txtColor: selected ? AppTheme.of(context).greenDark : AppTheme.of(context).greenContrast,
                          onSelected: (bool isSelected) => setSelectedChipByOne(boolean: isSelected),
                        ),
                      ),
                    ),
                  ],
                ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: InputDate(
                      selectedDate: selectedDate ?? DateTime.now(),
                      onChanged: (datetime) => dataToReturn.datetime = datetime,
                    ),
                  ),
                  Expanded(
                    child: InputTime(
                      selectedTime: selectedDate?.getTimeOfDay() ?? DateTime.now().getTimeOfDay(),
                      onChanged: (timeOfDay) => dataToReturn.datetime = dataToReturn.datetime?.setTimeOfDay(timeOfDay),
                    )
                  )
                ],
              ),
              if (!(onlyShowDate ?? false))
                InputCalculator(
                  controllerValue: dataToReturn.amount,
                  onChange: (amount) => dataToReturn.amount = amount,
                ),
              CButton(
                text: context.l10n!.save,
                onPressed: () {
                  if (onSave != null) onSave!(dataToReturn);
                  Navigator.pop(context);
                },
              )
            ]
          ),
        ),
      )
    );
  }
}