import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/modules/shared/widgets/modals/calculator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputCalculator extends StatefulWidget {
  final bool? readOnly;
  final InputDecoration? decoration;
  final void Function()? onTap;
  final void Function(double value)? onChange;
  TextEditingController? controller;
  AppLocalizations? tr;

  InputCalculator({
    super.key,
    this.readOnly,
    this.decoration,
    this.onTap,
    this.onChange,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => _InputCalculatorState();
}

class _InputCalculatorState extends State<InputCalculator> {
  NumberFormat? nFormat;
  double? currentValue;

  void setControllerValue() {
    String txt = widget.controller?.text ?? '';
    if (txt.isEmpty || txt == '0') currentValue = 0;
    widget.controller?.text = "\$ ${nFormat?.format(currentValue) ?? currentValue ?? 0}";
  }

  @override
  void initState() {
    nFormat = NumberFormat("#,###.##", widget.tr != null ? widget.tr!.localeName : "en_US" );
    widget.controller ??= TextEditingController();
    widget.controller?.addListener(setControllerValue);
    widget.controller?.text = '';

    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.tr = AppLocalizations.of(context)!;
    return TextFormField(
      decoration: widget.decoration ?? InputDecoration(
        labelText: widget.tr!.amount
      ),
      controller: widget.controller,
      readOnly: widget.readOnly ?? true,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => CalculatorModal(
            value: currentValue,
            onChange: (double value) {
              currentValue = value;
              widget.controller?.text = currentValue.toString();
              if (widget.onChange != null) widget.onChange!(value);
            },
            onOkTap: () => Navigator.pop(context),
          ),
        );
        if (widget.onTap != null) widget.onTap!();
      },
    );
  }
}