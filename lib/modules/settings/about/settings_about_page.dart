import 'package:flutter/material.dart';
import 'package:wallet/core/constants/app_images.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/shared/widgets/header.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';

class SettingsAboutPage extends StatelessWidget {
  SettingsAboutPage({
    super.key,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CHeader(
        title: context.l10n!.about_app,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              Column(
                spacing: 15,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.of(context).isThemeDark ? AppTheme.of(context).seedBgColorInverse : Colors.transparent,
                    radius: 85,
                    child: const Padding(
                      padding: EdgeInsets.all(35),
                        child: Image(
                        image: AssetImage(AppImages.appLogo),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Text(
                    context.l10n!.help_us,
                    style: const TextStyle(
                      fontSize: 22
                    ),
                  ),
                  GestureDetector(
                    onTap: () => print('Redireccionando a la play store'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 3,
                      children: [
                        for (int i = 0; i < 5; i++) const Icon(Icons.star_border, size: 32,)
                      ],
                    )
                  )
                ],    
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n!.version,
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  ),
                  const Text(
                    "1.0",
                    style: TextStyle(
                      fontSize: 18
                    ),
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n!.about_us,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  const Text(
                    'Lorem ipsum',
                    style: TextStyle(
                      fontSize: 18
                    )
                  ),
                ]
              ),
            ],
          ),
        )
      ),
    );
  }
}
