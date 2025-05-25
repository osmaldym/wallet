import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/modules/shared/widgets/fragments/chip.dart' as component;

class ScheduledPayTile extends StatelessWidget {
  String? title;
  bool? isIncome;
  double? amount;
  IconData? icon;
  void Function()? onTap;
  late NumberFormat format;

  ScheduledPayTile({ 
    super.key,
    this.title,
    this.isIncome,
    this.amount,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;
    AppTheme theme = AppTheme.of(context);

    format = NumberFormat("#,###.##", tr.localeName);

    return ListTile(
      tileColor: theme.primary,
      leading: CircleAvatar(
        backgroundColor: theme.seedBgColor,
        radius: 25,
        child: Icon(icon ?? Icons.payments_outlined),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
      ),
      title: Text(title ?? (isIncome! ? tr.myIncome : tr.myExpend)),
      subtitleTextStyle: TextStyle(
        color: isIncome! ? theme.textGreen : theme.textRedDark,
      ),
      subtitle: Text((isIncome! ? "+" : "-") + format.format(amount ?? 0)),
      trailing: SizedBox(
        height: 32,
        child: component.Chip(
          selectedColor: theme.seedBgColor,
          txtColor: isIncome! ? theme.greenContrast : theme.redContrast,
          text: isIncome! ? tr.income : tr.expend,
          selected: true,
          padding: const EdgeInsets.only(right: 5),
          avatar: Icon(
            Icons.chevron_right_rounded,
            color: isIncome! ? theme.greenContrast : theme.redContrast,
          ),
          onSelected: (e){},
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      onTap: () {
        if (onTap != null) onTap!();
      },
    );
  }
}