import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';

class PayOptionsBtn extends StatelessWidget {
  Widget? icon;
  Color? iconColor;
  void Function()? onPostponePressed;
  void Function()? onCustomPayPressed;
  void Function()? onPayPressed;
  void Function()? onRefusePressed;

  PayOptionsBtn({
    super.key,
    this.iconColor,
    this.icon,
    this.onPostponePressed,
    this.onCustomPayPressed,
    this.onPayPressed,
    this.onRefusePressed,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      iconColor: iconColor,
      icon: icon ?? const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: onPostponePressed != null,
          onTap: onPostponePressed,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.calendar_month, color: AppTheme.of(context).textContrast),
              Text(
                context.l10n!.postpone,
                style: TextStyle(
                  color: AppTheme.of(context).textContrast
                ),
              )
            ],
          )
        ),
        PopupMenuItem(
          enabled: onCustomPayPressed != null,
          onTap: onCustomPayPressed,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.edit, color: AppTheme.of(context).greenContrast,),
              Text(
                context.l10n!.customPay,
                style: TextStyle(
                  color: AppTheme.of(context).greenContrast
                ),
              )
            ],
          )
        ),
        PopupMenuItem(
          enabled: onPayPressed != null,
          onTap: onPayPressed, 
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.done, color: AppTheme.of(context).greenContrast,),
              Text(
                context.l10n!.pay,
                style: TextStyle(
                  color: AppTheme.of(context).greenContrast
                ),
              )
            ],
          )
        ),
        PopupMenuItem(
          enabled: onRefusePressed != null,
          onTap: onRefusePressed,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.delete_sharp, color: AppTheme.of(context).redContrast,),
              Text(
                context.l10n!.refuse,
                style: TextStyle(
                  color: AppTheme.of(context).redContrast
                ),
              )
            ],
          )
        ),
      ] ,
    );
  }
}
