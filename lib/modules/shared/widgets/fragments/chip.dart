import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';

class Chip extends ChoiceChip {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String? text;
  Color? txtColor;
  double? width;

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
    super.onSelected,
    super.avatar,
    super.padding,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      key: _scaffoldKey,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
      label: text != null ? SizedBox(
        width: width,
        child: Text(
          text!,
          textAlign: TextAlign.center,
        ),
      ) : label,
      labelStyle: GoogleFonts.urbanist(
        color: txtColor ?? Colors.black,
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
      avatar: avatar,
      backgroundColor: backgroundColor ?? Colors.grey.withAlpha(30),
      disabledColor: disabledColor ?? Colors.grey.withAlpha(30),
      selectedColor: selectedColor ?? AppTheme.of(context).primary,
      onSelected: onSelected,
    );
  }
}