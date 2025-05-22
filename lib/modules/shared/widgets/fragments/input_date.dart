import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDate extends StatefulWidget {
  InputDecoration? decoration;
  bool? readOnly;
  TextInputType? keyboardType;
  bool showModal;
  void Function()? onTap;
  void Function(DateTime value)? onChanged;
  DateTime selectedDate;
  
  InputDate({
    super.key,
    required this.selectedDate,
    this.decoration,
    this.readOnly,
    this.keyboardType,
    this.showModal = true,
    this.onTap,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  @override
  Widget build(BuildContext context) {
    String formatedDate = DateFormat("dd/MM/yyyy").format(widget.selectedDate);

    if (widget.onChanged != null) widget.onChanged!(widget.selectedDate);

    return TextFormField(
      decoration: widget.decoration ?? const InputDecoration(
        labelText: "Date"
      ),
      controller: TextEditingController(
        text: formatedDate,
      ),
      readOnly: widget.readOnly ?? true,
      keyboardType: widget.keyboardType ?? TextInputType.datetime,
      onTap: () {
        if (widget.showModal) _selectDate();
        if (widget.onTap != null) widget.onTap!();
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5)
    );

    setState(() {
      widget.selectedDate = picked!;
    });
  }
}