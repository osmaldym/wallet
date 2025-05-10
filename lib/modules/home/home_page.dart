import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wallet/modules/home/home_controller.dart';
import 'package:wallet/modules/shared/widgets/fragments/account.dart';
import 'package:wallet/modules/shared/widgets/header.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/modules/shared/widgets/menu.dart';
import 'package:wallet/modules/shared/widgets/modals/account.dart';

class Home extends StatefulWidget {
  const Home({ super.key });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late Future<List<Account>> _accs;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _updateAccounts();
    _controller.createGuest();
  }

  void _updateAccounts() => setState(() {
    _accs = _controller.getAccounts();
  });

  @override
  Widget build(BuildContext context){
    AppLocalizations? tr = AppLocalizations.of(context)!;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CHeader(
        title: "Accounts",
        leadingIcon: Icons.menu,
        onLeadingPressed: () => _scaffoldKey.currentState!.openDrawer(),
        onTrailingPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) => AccountModal(
            onSave: (String name) async {
              await _controller.addAccount(name);
              _updateAccounts();
            }
          )
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
                child: FutureBuilder<List<Account>>(
                  future: _accs,
                  builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, i) => Padding(
                          padding: EdgeInsets.only(left: i > 0 ? 5 : 0),
                          child: snapshot.data?[i],
                        ),
                        itemCount: snapshot.data?.length,
                      );
                    }
                    return const Text("You don't have any data to show");
                  },
                )
              )
            ],
          ),
        )
      ),
    );
  }
}