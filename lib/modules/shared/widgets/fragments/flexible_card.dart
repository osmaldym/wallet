import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';

class FlexibleCard extends StatelessWidget {
  bool? forList;
  double? elevation;
  Widget child;
  Color? color;

  FlexibleCard({
    super.key,
    required this.child,
    this.forList,
    this.color,
    this.elevation
  });

  @override
  Widget build(BuildContext context) {
    forList ??= false;
    return Flexible(
      child: Card(
        borderOnForeground: false,
        elevation: !(forList ?? false) ? elevation : 0,
        color: !(forList ?? false) ? (color ?? Colors.transparent) : AppTheme.of(context).seedBgColor,
        child: child,
      )
    );
  }
}
