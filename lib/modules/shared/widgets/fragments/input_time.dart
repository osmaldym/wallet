import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputTime extends StatefulWidget {
  InputDecoration? decoration;
  bool? readOnly;
  bool? enabled;
  TextInputType? keyboardType;
  bool showModal;
  void Function()? onTap;
  void Function(TimeOfDay value)? onChanged;
  TimeOfDay selectedTime;
  
  InputTime({
    super.key,
    required this.selectedTime,
    this.decoration,
    this.readOnly,
    this.keyboardType,
    this.showModal = true,
    this.enabled,
    this.onTap,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _InputTimeState();
}

class _InputTimeState extends State<InputTime> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;
    String formatedTime = widget.selectedTime.format(context);

    if (widget.onChanged != null) widget.onChanged!(widget.selectedTime);

    return TextFormField(
      decoration: widget.decoration ?? InputDecoration(
        labelText: tr.time
      ),
      controller: TextEditingController(
        text: formatedTime
      ),
      enabled: widget.enabled ?? true,
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

    if (picked != null) setState(() { widget.selectedTime = picked; });
  }
}