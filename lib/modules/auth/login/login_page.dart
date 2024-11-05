import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wallet/core/constants/app_images.dart';
import 'package:wallet/core/constants/theme/AppTheme.dart';
import 'package:wallet/modules/auth/login/login_controller.dart';
import 'package:wallet/modules/shared/widgets/brandLoginBtn.dart';
import 'package:wallet/modules/shared/widgets/changeLangBtn.dart';
import 'package:wallet/modules/shared/widgets/footer.dart';
import 'package:wallet/modules/shared/widgets/input.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatelessWidget{
  const Login({ super.key });

  @override
  Widget build(BuildContext context){
    AppLocalizations? tr = AppLocalizations.of(context)!;
    LoginController controller = LoginController();

   // Creating here the appbar to get the height later
    AppBar appBar = AppBar(
      automaticallyImplyLeading: false,
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CInput(
                          type: Types.pass
                        ),
                      ),
                      BrandLoginBtn(),
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
                                    recognizer: TapGestureRecognizer()..onTap = () => controller.goToSignin(context)
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
        onPressedBtn: () => controller.login(context),
        showBg: true,
        btnText: tr.logIn,
      ),
    );
  }
}