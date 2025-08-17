import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/core/extensions/object_ext.dart';

class Account extends Card {
  bool? isTotal;
  String? name;
  double quantity;
  void Function()? onTap;
  late NumberFormat format;

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

    format = NumberFormat("#,###.##", tr.localeName);

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      elevation: 0,
      color: isTotal.toBool() ? theme.primary : null,
      child: IntrinsicWidth(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          onTap: onTap,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          splashColor: Colors.grey,
          textColor: isTotal.toBool() ? theme.textBlack : theme.textContrast,
          title: Text(
            isTotal.toBool() || (name == null) ? tr.total : name!,
            textAlign: isTotal.toBool() ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 20
            ),
          ),
          subtitle: Text(
            "\$ ${format.format(quantity)}",
            style: TextStyle(
              color: quantity < 0
                ? (isTotal.toBool() ? theme.redDark : theme.redLight) 
                : (isTotal.toBool() ? theme.greenDark : theme.greenLight),
              fontSize: 12
            ),
          ),
        ),
      )
    );
  }
}