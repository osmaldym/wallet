import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/core/constants/app_route.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/BiometricHelper.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';

class Biometric extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Biometric({ super.key, });

  Future<void> authenticate(BuildContext context) async {
    final BiometricHelper biometric = BiometricHelper();
    if (context.mounted) {
      if (await biometric.canAuth()) {
        bool isAuth = await biometric.authenticate(context.l10n!.fingerprint_verification_message);
        if (isAuth) context.go(AppRoute.root);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    authenticate(context);

    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: AppTheme.of(context).primary,
              onPressed: () => authenticate(context),
              focusColor: AppTheme.of(context).primary,
              icon: const Icon(
                Icons.fingerprint_rounded,
                size: 62,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.l10n!.fingerprint_page_message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
