import 'package:flutter/material.dart';
import 'package:wallet/assets/AppTheme.dart';
import 'package:wallet/ui/widgets/footer.dart';
import 'package:wallet/ui/widgets/input.dart';

class Login extends StatelessWidget{
  const Login({ super.key });
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/logo.png')),
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
                            vertical: 25
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
                  )
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