import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wallet/assets/AppTheme.dart';
import 'package:wallet/ui/widgets/footer.dart';
import 'package:wallet/ui/widgets/input.dart';

class Login extends StatelessWidget{
  const Login({ super.key });

  @override
  Widget build(BuildContext context){
    double googleBtnSize = Platform.isIOS ? 44*1.2 : 40*1.2;
    double googleImgSize = 20;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 100,
              child: Padding(
                padding: EdgeInsets.all(35),
                  child: Image(
                  image: AssetImage('assets/logo.png'),
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
                    type: Types.pass
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 15
                          ),
                          child: Text(
                            'Olvidé mi contraseña',
                            style: TextStyle(
                              fontSize: 14
                            ),
                            textAlign: TextAlign.end,
                          ),
                        )
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: AppTheme.of(context).contrast
                        )
                      )
                    ],
                  ),
                  OutlinedButton( // Google button
                    onPressed: (){},
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(googleBtnSize, googleBtnSize),
                      padding: EdgeInsets.zero,
                      backgroundColor: Color(
                        MediaQuery.of(context).platformBrightness == Brightness.dark ? 0xFF131314 : 0xFFFFFFFF
                      ) 
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Image(
                          width: googleImgSize,
                          height: googleImgSize,
                          image: const AssetImage("assets/brand_logos/google.png")
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text: "¿No tienes cuenta? "
                          ),
                          TextSpan(
                            text: "Registrate",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              // Add function
                            }
                          )
                        ]
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: CFooter(
        onPressedBtn: (){},
        btnText: "Iniciar sesión",
      ),
    );
  }
}