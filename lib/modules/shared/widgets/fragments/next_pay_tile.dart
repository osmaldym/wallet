import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/shared/widgets/fragments/pay_options_btn.dart';

class NextPayTile extends StatelessWidget {
  final Utils _utils = Utils();

  String? title;
  bool? isIncome;
  double? amount;
  IconData? icon;
  void Function()? onTap;
  void Function()? onOptionPostponePressed;
  void Function()? onOptionPayPressed;
  void Function()? onOptionCustomPayPressed;
  void Function()? onOptionRefusePressed;
  late NumberFormat format;
  DateTime? date;
  Color? backgroundColor;

  NextPayTile({
    super.key,
    this.title,
    this.isIncome,
    this.amount,
    this.icon,
    this.onTap,
    this.onOptionPostponePressed,
    this.onOptionPayPressed,
    this.onOptionCustomPayPressed,
    this.onOptionRefusePressed,
    this.date,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    format = NumberFormat("#,###.##", context.l10n!.localeName);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      tileColor: backgroundColor ?? AppTheme.of(context).primary,
      leading: CircleAvatar(
        backgroundColor: AppTheme.of(context).seedBgColor,
        radius: 25,
        child: Icon(icon ?? Icons.payments_outlined),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      title: Text(title ?? (isIncome! ? context.l10n?.myIncome : context.l10n?.myExpend) ?? "-"),
      subtitle: Row(
        spacing: 5,
        children: [
          Text(
            (isIncome! ? "+" : "-") + format.format(amount ?? 0),
            style: TextStyle(
              color: isIncome! ? AppTheme.of(context).textGreen : AppTheme.of(context).textRedDark,
            ),
          ),
          const CircleAvatar(
            radius: 2.5,
            backgroundColor: Colors.black,
          ),
          Text(
            _utils.toReadableRelativeDate((date ?? DateTime.now()), context),
            style: const TextStyle(
              color: Colors.black,
            )
          )
        ],
      ),
      trailing: SizedBox(
        height: 32,
        child: PayOptionsBtn(
          iconColor: Colors.black,
          onPayPressed: onOptionPayPressed,
          onCustomPayPressed: onOptionCustomPayPressed,
          onRefusePressed: onOptionRefusePressed,
          onPostponePressed: onOptionPostponePressed,
        )
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      onTap: onTap,
    );
  }
}
