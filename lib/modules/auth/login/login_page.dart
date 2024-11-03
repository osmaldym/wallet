import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wallet/core/constants/app_images.dart';
import 'package:wallet/core/constants/theme/AppTheme.dart';
import 'package:wallet/modules/shared/widgets/changeLangBtn.dart';
import 'package:wallet/modules/shared/widgets/footer.dart';
import 'package:wallet/modules/shared/widgets/input.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatelessWidget{
  const Login({ super.key });

  @override
  Widget build(BuildContext context){
    double googleBtnSize = Platform.isIOS ? 44*1.2 : 40*1.2;
    double googleImgSize = 20;
    AppLocalizations? tr = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30
                  ),
                  child: ChangeLangBtn(key: key),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 100,
                  child: Padding(
                    padding: EdgeInsets.all(35),
                      child: Image(
                      image: AssetImage(AppImages.appLogo),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 50
                  ),
                  child: Column(
                    children: <Widget>[
                      CInput(
                        focus: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CInput(
                          type: Types.pass
                        ),
                      ),
                      OutlinedButton( // Google button
                        onPressed: (){},
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(googleBtnSize, googleBtnSize),
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
                              width: googleImgSize,
                              height: googleImgSize,
                              image: const AssetImage(AppImages.googleLogo)
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${tr.dontHaveAccount} ',
                                    style: TextStyle(
                                      color: AppTheme.of(context).textContrast,
                                    )
                                  ),
                                  TextSpan(
                                    text: tr.signIn,
                                    style: TextStyle(
                                      color: AppTheme.of(context).textContrast,
                                      fontWeight: FontWeight.bold
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      // Add function
                                    }
                                  )
                                ]
                              )
                            ),
                            GestureDetector(
                              onTap: (){},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15
                                ),
                                child: Text(
                                  tr.iForgotMyPassword,
                                  style: const TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                              )
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        )
      ),
      bottomSheet: CFooter(
        onPressedBtn: (){},
        showBg: true,
        btnText: tr.logIn,
      ),
    );
  }
}