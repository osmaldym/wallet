import 'package:flutter/material.dart';

class InputTime extends StatefulWidget {
  InputDecoration? decoration;
  bool? readOnly;
  TextInputType? keyboardType;
  bool showModal;
  void Function()? onTap;
  void Function(TimeOfDay value)? onChanged;
  TimeOfDay? selectedTime;
  
  InputTime({
    super.key,
    this.decoration,
    this.readOnly,
    this.keyboardType,
    this.showModal = true,
    this.onTap,
    this.onChanged,
    this.selectedTime,
  });

  @override
  State<StatefulWidget> createState() => _InputTimeState();
}

class _InputTimeState extends State<InputTime> {
  @override
  Widget build(BuildContext context) {
    widget.selectedTime ??= TimeOfDay.now();
    String formatedTime = widget.selectedTime!.format(context);

    if (widget.onChanged != null) widget.onChanged!(widget.selectedTime!);

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
        if (widget.onTap != null) widget.onTap!();
      },
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      widget.selectedTime = picked;
    });
  }
}