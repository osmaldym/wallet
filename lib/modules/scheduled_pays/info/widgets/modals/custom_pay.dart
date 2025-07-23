import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_calculator.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_date.dart';

class CustomPayData {
  DateTime? datetime;
  double? amount;

  CustomPayData({
    this.datetime,
    this.amount,
  });
}

class CustomPay extends StatefulWidget {
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
  State<StatefulWidget> createState() => _CustomPayState();
}

class _CustomPayState extends State<CustomPay> {
  CustomPayData dataToReturn = CustomPayData();
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    dataToReturn.amount = widget.lastAmount;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: _scaffoldKey,
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
              InputDate(
                selectedDate: widget.selectedDate ?? DateTime.now(),
                onChanged: (datetime) => dataToReturn.datetime = datetime,
              ),
              InputCalculator(
                controllerValue: dataToReturn.amount,
                onChange: (amount) => setState(() { dataToReturn.amount = amount; }),
              ),
              CButton(
                text: context.l10n!.save,
                onPressed: () {
                  if (widget.onSave != null) widget.onSave!(dataToReturn);
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