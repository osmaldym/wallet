import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';

class CCircularProgressIndicator extends StatelessWidget {
  Widget? child;
  double? value;
  double? strokeWidth;
  double? blurRadius;
  double? size;
  Color? blurColor;
  bool? blur;

  CCircularProgressIndicator({
    super.key,
    this.size = 50,
    this.child,
    this.value = 0.5,
    this.strokeWidth = 2,
    this.blur,
    this.blurColor,
    this.blurRadius,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.of(context).seedBgColor,
            shape: BoxShape.circle,
            boxShadow: (blur ?? true) ? [
              BoxShadow(
                color: blurColor ?? Colors.grey.withAlpha(40),
                blurRadius: blurRadius ?? 15,
              )
            ] : null
          ),
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            backgroundColor: AppTheme.of(context).greenDark,
            color: AppTheme.of(context).greenContrast,
          ),
        ),

        child ?? Icon(
          size: 24,
          color: AppTheme.of(context).textContrast,
          Icons.flag_outlined
        )
      ]
    );
  }
}
