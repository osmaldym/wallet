import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wallet/modules/home/home_controller.dart';
import 'package:wallet/modules/shared/widgets/fragments/account.dart';
import 'package:wallet/modules/shared/widgets/header.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/modules/shared/widgets/menu.dart';
import 'package:wallet/modules/shared/widgets/modals/account.dart';

class Home extends StatelessWidget{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Account> accs = [
    Account(
      isTotal: true,
      quantity: "+180,000",
      onTap: (){},
    ),
    Account(
      name: "Qik",
      quantity: "+131,000",
      onTap: (){},
    ),
    Account(
      name: "Popular",
      quantity: "+20,000",
      onTap: (){},
    ),
    Account(
      name: "BDI",
      quantity: "+200",
      onTap: (){},
    ),
  ];

  Home({ super.key });

  @override
  Widget build(BuildContext context){
    AppLocalizations? tr = AppLocalizations.of(context)!;
    HomeController controller = HomeController();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CHeader(
        title: "Accounts",
        leadingIcon: Icons.menu,
        onLeadingPressed: () => _scaffoldKey.currentState!.openDrawer(),
        onTrailingPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) => AccountModal()
        ),
      ),
      drawer: Menu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25
                ),
                alignment: Alignment.center,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, i) => Padding(
                    padding: EdgeInsets.only(left: i > 0 ? 5 : 0),
                    child: accs[i],
                  ),
                  itemCount: accs.length,
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}