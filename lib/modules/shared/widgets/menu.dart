import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/core/constants/app_images.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/shared/widgets/fragments/menu_option.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Menu extends Drawer {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  double width;

  Menu({
    super.key,
    this.width = 270,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;
    return Drawer(
      key: _scaffoldKey,
      width: width,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: AppTheme.of(context).primary
            ),
            height: 150,
            padding: const EdgeInsets.symmetric(
              horizontal: 15
            ),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Image(
                    height: 50,
                    image: AssetImage(AppImages.appLogo),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Text(
                  "Wallet App",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),
                )
              ],
            )
          ),
          MenuOption(
            text: tr.nextPays,
            icon: Icons.money,
            onTap: () => context.go("/"),
          ),
          MenuOption(
            text: tr.records,
            icon: Icons.storage_rounded,
            onTap: () => context.go("/"),
          ),
          MenuOption(
            text: tr.statistics,
            icon: Icons.trending_up,
            onTap: () => context.go("/"),
          ),
          MenuOption(
            text: tr.goals,
            icon: Icons.sports_score,
            onTap: () => context.go("/"),
          ),
          MenuOption(
            text: tr.budgets,
            icon: Icons.calculate,
            onTap: () => context.go("/"),
          ),
          MenuOption(
            text: tr.settings,
            icon: Icons.settings,
            onTap: () => context.go("/"),
          )
        ],
      ),
    );
  }
}