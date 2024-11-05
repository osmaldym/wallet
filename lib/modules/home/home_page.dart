import 'package:flutter/material.dart';
import 'package:wallet/modules/home/home_controller.dart';
import 'package:wallet/modules/shared/widgets/header.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatelessWidget{
  const Home({ super.key });

  @override
  Widget build(BuildContext context){
    AppLocalizations? tr = AppLocalizations.of(context)!;
    HomeController controller = HomeController();

    return Scaffold(
      appBar: CHeader(),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text("Hola mundo")
              ],
            ),
          )
        )
      ),
    );
  }
}