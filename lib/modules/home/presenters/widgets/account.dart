import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountModal extends StatefulWidget {
  int ?id;
  void Function(String name) onSave;

  AccountModal({
    super.key,
    required this.onSave,
    this.id,
  });

  @override
  _AccountModalState createState() => _AccountModalState();
}

class _AccountModalState extends State<AccountModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String name = "";
    AppLocalizations? tr = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      key: _scaffoldKey,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppTheme.of(context).seedBgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.id == null ? tr.newAccount : tr.editingAccount,
                style: GoogleFonts.urbanist(
                    fontSize: 32,
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: tr.account,
                  ),
                  autofocus: true,
                  onChanged: (String val) => name = val,
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: CButton(
                  text: tr.save,
                  onPressed: () {
                    widget.onSave(name);
                    Navigator.pop(context);
                  }
                )
              )
            ],
          ),
        )
      )
    );
  }
}