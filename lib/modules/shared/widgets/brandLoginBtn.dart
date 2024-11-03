import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_images.dart';
import '../../../core/constants/theme/AppTheme.dart';

class BrandLoginBtn extends StatelessWidget {
  double btnSize = Platform.isIOS ? 44*1.2 : 40*1.2;
  double imgSize = 0;

  BrandLoginBtn({
    super.key,
    btnSize,
    imgSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton( // Google button
      onPressed: (){},
      style: OutlinedButton.styleFrom(
        minimumSize: Size(btnSize, btnSize),
        padding: EdgeInsets.zero,
        backgroundColor: Color(
          AppTheme.of(context).isThemeDark ? 0xFF131314 : 0xFFFFFFFF
        ) 
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Image(
            width: imgSize,
            height: imgSize,
            image: const AssetImage(AppImages.googleLogo)
          ),
        ],
      )
    );
  }
  
}