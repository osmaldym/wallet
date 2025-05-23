import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CButton extends StatelessWidget {
  String? text;
  Color? bgColor;
  bool? isLoading;
  void Function() onPressed;

  CButton({
    super.key,
    this.text = '',
    this.bgColor,
    this.isLoading,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;
    String txt = text ?? tr.save;
    Color bgCol = bgColor ?? AppTheme.of(context).primary;

    return TextButton(
      onPressed: isLoading != null && isLoading! ? null : onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bgCol,
        minimumSize: const Size.fromHeight(50),
        disabledBackgroundColor: bgCol.withAlpha(150),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        )
      ),
      child: isLoading != null && isLoading! ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppTheme.of(context).textContrast
        ),
      ) : Text(
        txt,
        style: TextStyle(
          color: AppTheme.of(context).contrast,
        ),
      ),
    );
  }
}