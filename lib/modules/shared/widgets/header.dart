import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CHeader extends StatelessWidget implements PreferredSizeWidget {
  double height;
  String title;
  IconData leadingIcon;
  IconData trailingIcon;
  double iconSize;
  void Function()? onLeadingPressed;
  void Function()? onTrailingPressed;
  final double p = 25;

  CHeader({
    super.key,
    this.onLeadingPressed,
    this.onTrailingPressed,
    this.height = 80.0,
    this.iconSize = 34.0,
    this.leadingIcon = Icons.chevron_left,
    this.trailingIcon = Icons.add,
    this.title = "Wallet",
  });

  @override
  Widget build(BuildContext context){
    return Container(
      height: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.only(top: p, left: p, right: p, bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: p),
              child: IconButton(
                icon: Icon(leadingIcon),
                iconSize: iconSize,
                onPressed: onLeadingPressed ?? () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 32,
                )
              ),
            ),
            if (onTrailingPressed != null)
              IconButton(
                icon: Icon(trailingIcon),
                iconSize: iconSize,
                onPressed: onTrailingPressed,
              ),
          ],
        ),
      ),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}