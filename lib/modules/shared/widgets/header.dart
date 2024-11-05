import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CHeader extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  double height;
  String title;
  IconData icon;
  double iconSize;
  final double p = 25;

  CHeader({
    super.key, 
    this.height = 80.0,
    this.iconSize = 34.0,
    this.icon = Icons.chevron_left,
    this.title = "Wallet",
  });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, p, 0),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(p, 0, p, 0),
                child: Icon(
                  icon,
                  size: iconSize,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 32,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}