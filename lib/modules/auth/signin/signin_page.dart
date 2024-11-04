import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet/core/constants/app_images.dart';
import 'package:wallet/core/constants/theme/AppTheme.dart';
import 'package:wallet/modules/auth/signin/signin_controller.dart';
import 'package:wallet/modules/shared/widgets/brandLoginBtn.dart';
import 'package:wallet/modules/shared/widgets/changeLangBtn.dart';
import 'package:wallet/modules/shared/widgets/footer.dart';
import 'package:wallet/modules/shared/widgets/input.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Signin extends StatelessWidget{
  const Signin({ super.key });

  @override
  Widget build(BuildContext context){
    AppLocalizations? tr = AppLocalizations.of(context)!;
    SigninController controller = SigninController();

    // Creating here the appbar to get the height later
    AppBar appBar = AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30
          ),
          child: ChangeLangBtn(key: key),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        minimum: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: appBar.preferredSize.height + 10),
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
                      CInput(
                        placeholder: tr.name,
                        type: Types.name,
                        focus: true,
                      ),
                      CInput(
                        placeholder: tr.lastName,
                        type: Types.name,
                        focus: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CInput(
                          type: Types.pass
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CInput(
                          placeholder: tr.confirmPassword,
                          type: Types.pass
                        ),
                      ),
                      BrandLoginBtn(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 35),
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${tr.hasAccount} ',
                                    style: TextStyle(
                                      color: AppTheme.of(context).textContrast,
                                    )
                                  ),
                                  TextSpan(
                                    text: tr.logIn,
                                    style: TextStyle(
                                      color: AppTheme.of(context).textContrast,
                                      fontWeight: FontWeight.bold
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () => controller.goToLogin(context)
                                  )
                                ]
                              )
                            ),
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
        btnText: tr.signIn,
      ),
    );
  }
}