import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Account extends Card {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isTotal;
  String ?name;
  String quantity;
  void Function()? onTap;

  Account({
    super.key,
    required this.quantity,
    this.isTotal = false,
    this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;
    AppTheme theme = AppTheme.of(context);

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      elevation: 5,
      shadowColor: isTotal ? const Color.fromARGB(255, 29, 29, 29) : Colors.transparent,
      color: isTotal ? theme.primary : Colors.transparent,
      child: IntrinsicWidth(
        child: ListTile(
          onTap: onTap,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          splashColor: Colors.grey,
          textColor: isTotal ? theme.textBlack : theme.textContrast,
          title: Text(
            isTotal || (name == null) ? tr.total : name!,
            textAlign: isTotal ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 20
            ),
          ),
          subtitle: Text(
            quantity,
            style: TextStyle(
              color: quantity.startsWith("-") ? 
                isTotal ? theme.redDark : theme.redLight
                : isTotal ? theme.greenDark : theme.greenLight,
              fontSize: 12
            ),
          ),
        ),
      )
    );
  }
}