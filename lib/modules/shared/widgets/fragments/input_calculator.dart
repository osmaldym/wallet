import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/modules/shared/widgets/modals/calculator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputCalculator extends StatefulWidget {
  final bool? readOnly;
  final InputDecoration? decoration;
  final void Function()? onTap;
  final void Function(double value)? onChange;
  double? controllerValue;
  AppLocalizations? tr;

  double? valueToShow = 0;

  InputCalculator({
    super.key,
    this.readOnly,
    this.decoration,
    this.onTap,
    this.onChange,
    this.controllerValue,
  });

  @override
  State<StatefulWidget> createState() => _InputCalculatorState();
}

class _InputCalculatorState extends State<InputCalculator> {
  TextEditingController? inputController;
  NumberFormat? nFormat;

  @override
  void initState() {
    nFormat = NumberFormat("#,###.##", widget.tr != null ? widget.tr!.localeName : "en_US" );
    inputController = TextEditingController(
      text: "\$ ${nFormat!.format(widget.controllerValue ?? widget.valueToShow)}"
    );
    super.initState();
  }

  @override
  void dispose() {
    inputController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.tr = AppLocalizations.of(context)!;
    return TextFormField(
      decoration: widget.decoration ?? InputDecoration(
        labelText: widget.tr!.amount
      ),
      controller: inputController,
      readOnly: widget.readOnly ?? true,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => CalculatorModal(
            onChange: (double value) {
              if (widget.onChange != null) widget.onChange!(value);
              setState(() {
                widget.valueToShow = widget.controllerValue = value;
                inputController?.text = "\$ ${nFormat!.format(widget.controllerValue ?? widget.valueToShow)}";
              });
            },
            onOkTap: () => Navigator.pop(context),
          ),
        );
        if (widget.onTap != null) widget.onTap!();
      },
    );
  }
}