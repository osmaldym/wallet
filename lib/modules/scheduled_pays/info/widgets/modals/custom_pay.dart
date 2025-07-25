import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/extensions/datetime_ext.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_calculator.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_date.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_time.dart';

class CustomPayData {
  DateTime? datetime;
  double? amount;

  CustomPayData({
    this.datetime,
    this.amount,
  });
}

class CustomPay extends StatelessWidget {
  CustomPayData dataToReturn = CustomPayData();
  bool loading = false;

  void Function(CustomPayData data)? onSave;
  DateTime? selectedDate;
  double? lastAmount;

  CustomPay({
    super.key,
    this.onSave,
    this.selectedDate,
    this.lastAmount
  });

  @override
  StatelessElement createElement() {
    dataToReturn.amount = lastAmount;
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
                context.l10n!.customPay, 
                style: const TextStyle(
                  fontSize: 28
                ),
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