import 'package:flutter/material.dart';
import 'package:wallet/modules/home/home_controller.dart';
import 'package:wallet/modules/shared/widgets/header.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/modules/shared/widgets/menu.dart';

class Home extends StatelessWidget{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Home({ super.key });

  @override
  Widget build(BuildContext context){
    AppLocalizations? tr = AppLocalizations.of(context)!;
    HomeController controller = HomeController();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CHeader(
        icon: Icons.menu,
        onPressed: () => _scaffoldKey.currentState!.openDrawer(),
      ),
      drawer: Menu(),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10),
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