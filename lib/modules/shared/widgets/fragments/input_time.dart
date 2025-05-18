import 'package:flutter/material.dart';

class InputTime extends StatefulWidget {
  InputDecoration? decoration;
  bool? readOnly;
  TextInputType? keyboardType;
  bool showModal;
  void Function()? onTap;
  
  InputTime({
    super.key,
    this.decoration,
    this.readOnly,
    this.keyboardType,
    this.showModal = true,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _InputTimeState();
}

class _InputTimeState extends State<InputTime> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    selectedTime ??= TimeOfDay.now();
    String formatedTime = selectedTime!.format(context);

    return TextFormField(
      decoration: widget.decoration ?? const InputDecoration(
        labelText: "Time"
      ),
      controller: TextEditingController(
        text: formatedTime
      ),
      readOnly: widget.readOnly ?? true,
      keyboardType: widget.keyboardType ?? TextInputType.datetime,
      onTap: () {
        if (widget.showModal) _selectTime();
        widget.onTap!();
      },
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      selectedTime = picked;
    });
  }
}