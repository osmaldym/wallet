import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/AppTheme.dart';

class CButton extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String? text;
  Color? bgColor;
  void Function() onPressed;

  CButton({
    super.key,
    this.text = '',
    this.bgColor,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    String txt = text ?? 'Guardar';
    Color bgCol = bgColor ?? AppTheme.of(context).primary;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bgCol,
        minimumSize: const Size.fromHeight(50),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        )
      ),
      child: Text(
        txt,
        style: TextStyle(
          color: AppTheme.of(context).contrast,
        ),
      ),
    );
  }
}