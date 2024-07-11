import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallet/assets/AppTheme.dart';
import 'package:wallet/ui/widgets/button.dart';

// ignore: must_be_immutable
class CFooter extends StatelessWidget {
  double height;
  String? btnText;
  double verticalPadding;
  double horizontalPadding;
  Function onPressedBtn;

  CFooter({
    super.key, 
    this.height = 70.0,
    this.btnText,
    this.verticalPadding = 10,
    this.horizontalPadding = 20,
    required this.onPressedBtn,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      // alignment: Alignment.bottomCenter,
      height: height + verticalPadding,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CButton(
            onPressed: onPressedBtn,
            text: btnText,
          ),
        ],
      ),
    );
  }

}