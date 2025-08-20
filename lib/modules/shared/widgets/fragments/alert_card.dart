import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';

class AlertCard extends StatelessWidget {
  Widget? title;
  String? titleText;
  Widget? subtitle;
  Widget? icon;
  IconData? iconData;
  Color? bgColor;
  Color? iconColor;
  Color? titleColor;
  double? iconCircleSize;
  double? iconSize;

  AlertCard({
    super.key,
    this.title,
    this.titleText,
    this.icon,
    this.iconData,
    this.subtitle,
    this.bgColor,
    this.titleColor,
    this.iconCircleSize,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor ?? AppTheme.of(context).primary,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 15,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  title ?? Text(
                    titleText ?? "${context.l10n!.warning.toUpperCase()}!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: titleColor ?? Colors.black
                    ),
                  ),
                  if (subtitle != null) subtitle!
                ],
              ),
            ),
            icon ?? CircleAvatar(
              radius: iconCircleSize ?? 28,
              backgroundColor: iconColor ?? AppTheme.of(context).seedBgColor,
              child: Icon(
                iconData ?? Icons.warning_amber_outlined,
                size: iconSize ?? 28,
              ),
            )
          ],
        ),
      )
    );
  }
}
