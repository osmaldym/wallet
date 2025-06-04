import 'package:flutter/material.dart';

class Select extends StatelessWidget {
  List<DropdownMenuItem>? items;
  void Function(dynamic value)? onChanged;
  InputDecoration? decoration;
  bool? expand;
  Icon? icon;
  dynamic value;

  Select({
    super.key,
    this.items,
    this.onChanged,
    this.value,
    this.icon,
    this.expand,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,
      decoration: decoration,
      items: items ?? [],
      isExpanded: expand ?? true,
      onChanged: (dynamic value) {
        value = value;
        if (onChanged != null) onChanged!(value);
      },
      icon: icon ?? const Icon(Icons.keyboard_arrow_down),
    );
  }
}