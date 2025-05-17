import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  List<dynamic>? items;
  void Function(dynamic value)? onChanged;
  InputDecoration? decoration;
  bool? expand;
  Icon? icon;

  Select({
    super.key,
    this.items,
    this.onChanged,
    this.icon,
    this.expand,
    this.decoration,
  });
  
  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  dynamic dropdownValue;

  @override
  Widget build(BuildContext context) {
    dropdownValue ??= widget.items!.first;

    return DropdownButtonFormField(
      value: dropdownValue,
      decoration: widget.decoration,
      items: widget.items!.map<DropdownMenuItem<dynamic>>(
        (dynamic value) => DropdownMenuItem<dynamic>(
          value: value,
          child: Text(value),
        )
      ).toList(),
      isExpanded: widget.expand ?? true,
      onChanged: (dynamic value) {
        setState(() {
          dropdownValue = value;
        });
        widget.onChanged!(value);
      },
      icon: widget.icon ?? const Icon(Icons.keyboard_arrow_down),
    );
  }
}