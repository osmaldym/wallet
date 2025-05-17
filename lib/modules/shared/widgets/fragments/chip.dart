import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';

class Chip extends ChoiceChip {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String? text;
  Color? txtColor;

  Chip({
    super.key,
    this.text,
    this.txtColor,
    super.label = const Text("Text"),
    required super.selected,
    super.autofocus,
    super.disabledColor,
    super.selectedColor,
    super.showCheckmark,
    super.side,
    super.shape,
    super.onSelected
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      key: _scaffoldKey,
      label: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        child: text != null ? Text(
          text!,
          style: GoogleFonts.urbanist(
            fontSize: 16
          )
        ) : label,
      ),
      selected: selected,
      autofocus: autofocus,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(999)
          ),
        ),
      showCheckmark: showCheckmark ?? false,
      side: side ?? const BorderSide(
        width: 0,
        color: Colors.transparent
      ),
      backgroundColor: backgroundColor ?? Colors.black.withAlpha(10),
      disabledColor: disabledColor ?? Colors.black.withAlpha(10),
      selectedColor: selectedColor ?? AppTheme.of(context).primary,
      labelStyle: TextStyle(
        color: txtColor
      ),

      onSelected: onSelected,
    );
  }
}