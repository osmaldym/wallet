import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputDate extends StatefulWidget {
  InputDecoration? decoration;
  bool? readOnly;
  bool? enabled;
  TextInputType? keyboardType;
  bool showModal;
  void Function()? onTap;
  void Function(DateTime value)? onChanged;
  DateTime selectedDate;
  DateTime? firstDate;
  DateTime? lastDate;
  
  InputDate({
    super.key,
    required this.selectedDate,
    this.decoration,
    this.readOnly,
    this.keyboardType,
    this.showModal = true,
    this.onTap,
    this.enabled,
    this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<StatefulWidget> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  @override
  Widget build(BuildContext context) {
    String formatedDate = DateFormat("dd/MM/yyyy").format(widget.selectedDate);
    AppLocalizations? tr = AppLocalizations.of(context)!;

    if (widget.onChanged != null) widget.onChanged!(widget.selectedDate);

    return TextFormField(
      decoration: widget.decoration ?? InputDecoration(
        labelText: tr.date
      ),
      enabled: widget.enabled ?? true,
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
      firstDate: widget.firstDate ?? DateTime(DateTime.now().year - 5),
      lastDate: widget.lastDate ?? DateTime(DateTime.now().year + 5)
    );

    if (picked != null) setState(() { widget.selectedDate = picked; });
  }
}