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
  double? currentValue;
  AppLocalizations? tr;

  InputCalculator({
    super.key,
    this.readOnly,
    this.decoration,
    this.onTap,
    this.onChange,
    this.controller,
    this.currentValue,
  });

  @override
  State<StatefulWidget> createState() => _InputCalculatorState();
}

class _InputCalculatorState extends State<InputCalculator> {
  NumberFormat? nFormat;
  TextEditingController? controller;
  bool controllerWasNull = false;

  void setControllerValue(double? value) {
    controller?.text = "\$ ${value != null ? nFormat?.format(value) : 0}";
  }

  @override
  void initState() {
    nFormat = NumberFormat("#,###.##", widget.tr != null ? widget.tr!.localeName : "en_US" );
    controllerWasNull = widget.controller == null;
    widget.currentValue ??= 0;
    controller = widget.controller ?? TextEditingController();
    setControllerValue(widget.currentValue);

    super.initState();
  }

  @override
  void dispose() {
    if (controllerWasNull) controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InputCalculator oldWidget) {
    if (controllerWasNull) setControllerValue(widget.currentValue);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    widget.tr = AppLocalizations.of(context)!;
    return TextFormField(
      decoration: widget.decoration ?? InputDecoration(
        labelText: widget.tr!.amount
      ),
      controller: controller,
      readOnly: widget.readOnly ?? true,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => CalculatorModal(
            value: widget.currentValue,
            onChange: (double value) {
              widget.currentValue = value;
              setControllerValue(widget.currentValue);
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