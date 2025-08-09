import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';

class FullSizeMessage extends StatelessWidget {
  Widget? icon;
  IconData? iconData;
  String? title;
  Widget? subtitle;
  Color? backgroundColorIcon;
  Color? fillColor;
  Color? titleColor;
  Color? iconColor;
  double? radius;
  EdgeInsetsGeometry? padding;

  FullSizeMessage({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.iconData,
    this.backgroundColorIcon,
    this.iconColor,
    this.fillColor,
    this.titleColor,
    this.padding,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
            backgroundColor: backgroundColorIcon ?? fillColor ?? AppTheme.of(context).primary,
            radius: radius ?? 40,
            child: icon ?? Icon(
              iconData ?? Icons.warning_amber_rounded,
              size: 38,
              color: iconColor ?? AppTheme.of(context).seedBgColor,
            ),
          ),
          Text(
            title ?? 'Error',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: titleColor ?? fillColor ?? AppTheme.of(context).textContrast
            ),
          ),
          if (subtitle != null) subtitle!
        ],
      ),
    );
  }
}
