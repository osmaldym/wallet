import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallet/core/constants/app_route.dart';
import 'package:wallet/core/providers/DarkModeNotifier.dart';
import 'package:wallet/core/utils/BiometricHelper.dart';
import 'package:wallet/core/utils/LocalData.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/widgets/fragments/change_lang_btn.dart';
import 'package:wallet/modules/shared/widgets/header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _darkModefromSystem = false;
  bool _darkMode = false;
  bool _biometric = false;

  void _getModeByLocalData() async {
    bool? darkMode = await LocalData.get("darkMode", type: Type.bool);
    bool? darkModefromSystem = await LocalData.get("darkModeBySystem", type: Type.bool);

    darkMode ??= false;
    darkModefromSystem ??= false;

    setState(() {
      _darkMode = darkMode!;
      _darkModefromSystem = darkModefromSystem!;
    });
  }

  void _getBiometricByLocalData() async {
    bool biometric = await LocalData.get("biometric", type: Type.bool) ?? false;
    setState(() => _biometric = biometric);
  }

  @override
  void initState() {
    _getModeByLocalData();
    _getBiometricByLocalData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CHeader(
        title: context.l10n!.settings,
        trailing: ChangeLangBtn(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  context.l10n!.brightnessMode,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SwitchListTile(
                title: Text(context.l10n!.dark),
                secondary: const Icon(Icons.dark_mode),
                value: _darkMode,
                contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                onChanged: _darkModefromSystem ? null : (bool value) async {
                  await LocalData.set("darkMode", value, type: Type.bool);
                  if (context.mounted) context.read<DarkModeNotifier>().notify();
                  setState(() =>_darkMode = value);
                } 
              ),
              SwitchListTile(
                title: Text(context.l10n!.fromSystem),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                secondary: const Icon(Icons.phonelink_setup_rounded),
                value: _darkModefromSystem,
                onChanged: (bool value) async {
                  await LocalData.set("darkModeBySystem", value, type: Type.bool);
                  if (context.mounted) context.read<DarkModeNotifier>().notify();
                  setState(() { _darkModefromSystem = value; });
                }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  context.l10n!.security,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SwitchListTile(
                title: Text(context.l10n!.fingerprint),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                secondary: const Icon(Icons.fingerprint_rounded),
                value: _biometric,
                onChanged: (bool value) async {
                  if (!_biometric) {
                    final BiometricHelper biometric = BiometricHelper();
                    if (context.mounted) {
                      if (await biometric.canAuth()) {
                        bool isAuth = await biometric.authenticate(context.l10n!.fingerprint_activation_message);
                        if (!isAuth) return;
                      }
                    }
                  }
                  await LocalData.set("biometric", value, type: Type.bool);
                  setState(() { _biometric = value; });
                }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  context.l10n!.app_data,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              ListTile(
                title: Text(context.l10n!.about),
                contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                leading: const Icon(Icons.info_outline_rounded),
                onTap: () => context.push(AppRoute.settingsAbout),
              )
            ],
          )
        )
      )
    );
  }
}