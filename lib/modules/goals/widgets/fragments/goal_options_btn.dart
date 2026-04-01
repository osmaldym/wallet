import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';

class GoalOptionsBtn extends StatelessWidget {
  Widget? icon;
  Color? iconColor;
  void Function()? onDecreaseSavingsPressed;
  void Function()? onEditPressed;
  void Function()? onIncreaseSavingPressed;
  void Function()? onDeletePressed;

  GoalOptionsBtn({
    super.key,
    this.iconColor,
    this.icon,
    this.onDecreaseSavingsPressed,
    this.onEditPressed,
    this.onIncreaseSavingPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      iconColor: iconColor,
      icon: icon ?? const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: onIncreaseSavingPressed != null,
          onTap: onIncreaseSavingPressed, 
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.add, color: AppTheme.of(context).greenContrast,),
              Text(
                context.l10n!.increaseSavings,
                style: TextStyle(
                  color: AppTheme.of(context).greenContrast
                ),
              )
            ],
          )
        ),
        PopupMenuItem(
          enabled: onDecreaseSavingsPressed != null,
          onTap: onDecreaseSavingsPressed,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.remove, color: AppTheme.of(context).redContrast),
              Text(
                context.l10n!.decreaseSavings,
                style: TextStyle(
                  color: AppTheme.of(context).redContrast
                ),
              )
            ],
          )
        ),
        PopupMenuItem(
          enabled: onEditPressed != null,
          onTap: onEditPressed,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.edit, color: AppTheme.of(context).greenContrast,),
              Text(
                context.l10n!.edit,
                style: TextStyle(
                  color: AppTheme.of(context).greenContrast
                ),
              )
            ],
          )
        ),
        PopupMenuItem(
          enabled: onDeletePressed != null,
          onTap: onDeletePressed,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.delete_sharp, color: AppTheme.of(context).redContrast,),
              Text(
                context.l10n!.delete,
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
