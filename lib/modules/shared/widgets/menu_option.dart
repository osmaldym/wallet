import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';

class MenuOption extends ListTile {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String text;
  IconData icon;
  double size;
  void Function() onTap;

  MenuOption({
    super.key,
    required this.onTap,
    this.text = "Home",
    this.icon = Icons.home,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: _scaffoldKey,
      title: Text(text),
      onTap: onTap,
      leading: Icon(icon, size: size),
      iconColor: AppTheme.of(context).textContrast,
      textColor: AppTheme.of(context).textContrast,
      splashColor: Colors.grey,
    );
  }
}