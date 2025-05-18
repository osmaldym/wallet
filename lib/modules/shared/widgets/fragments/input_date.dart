import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDate extends StatefulWidget {
  InputDecoration? decoration;
  bool? readOnly;
  TextInputType? keyboardType;
  bool showModal;
  void Function()? onTap;
  
  InputDate({
    super.key,
    this.decoration,
    this.readOnly,
    this.keyboardType,
    this.showModal = true,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    selectedDate ??= DateTime.now();
    String formatedDate = DateFormat("dd/MM/yyyy").format(selectedDate!);

    return TextFormField(
      decoration: widget.decoration ?? const InputDecoration(
        labelText: "Date"
      ),
      controller: TextEditingController(
        text: formatedDate
      ),
      readOnly: widget.readOnly ?? true,
      keyboardType: widget.keyboardType ?? TextInputType.datetime,
      onTap: () {
        if (widget.showModal) _selectDate();
        widget.onTap!();
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5)
    );

    setState(() {
      selectedDate = picked;
    });
  }
}