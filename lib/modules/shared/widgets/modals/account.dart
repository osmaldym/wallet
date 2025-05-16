import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';

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
                widget.id == null ? "New account" : "Editing account",
                style: GoogleFonts.urbanist(
                    fontSize: 32,
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Account",
                  ),
                  autofocus: true,
                  onChanged: (String val) => name = val,
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: CButton(
                  text: "Save",
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