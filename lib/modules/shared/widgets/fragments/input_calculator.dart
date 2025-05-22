import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/shared/widgets/modals/calculator.dart';

class InputCalculator extends StatefulWidget {
  final bool? readOnly;
  final InputDecoration? decoration;
  final void Function()? onTap;
  final void Function(double value)? onChange;
  
  final NumberFormat nFormat = NumberFormat("#,##0.00", "en_US");

  String? txtShow = "0";
  Utils utils = Utils(); 

  InputCalculator({
    super.key,
    this.readOnly,
    this.decoration,
    this.onTap,
    this.onChange,
  });

  @override
  State<StatefulWidget> createState() => _InputCalculatorState();
}

class _InputCalculatorState extends State<InputCalculator> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: widget.decoration ?? const InputDecoration(
        labelText: "Amount"
      ),
      controller: TextEditingController(
        text: "\$ ${widget.nFormat.format(widget.txtShow)}",
      ),
      readOnly: widget.readOnly ?? true,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => CalculatorModal(
            onChange: (double value) {
              setState(() {
                widget.txtShow = value.toStringAsFixed(value > value.toInt() ? 2 : 0);
              });
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