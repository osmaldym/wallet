import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';

class BorderedContainer extends StatelessWidget {
  List<Widget>? children;
  double? width;
  EdgeInsetsGeometry? padding;
  Color? color;
  double? gap;
  BorderRadiusDirectional? borderRadius;

  BorderedContainer({
    super.key,
    this.children,
    this.padding,
    this.gap,
    this.width,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      stepWidth: width,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? const BorderRadiusDirectional.all(Radius.circular(15)),
          color: AppTheme.of(context).seedBgColor,
        ),
        child: Row(
          spacing: gap ?? 5,
          children: children ?? [],
        )
      ),
    );
  }
}
