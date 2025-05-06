import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/input.dart';

class AccountModal extends SingleChildScrollView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int ?id;

  AccountModal({
    super.key,
    this.id
  });

  @override
  Widget build(BuildContext context) {
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
                id == null ? "New account" : "Editing account",
                style: GoogleFonts.urbanist(
                    fontSize: 32,
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: CInput(
                  type: Types.text,
                  placeholder: "Account",
                  focus: true,
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: CButton(
                  text: "Save",
                  onPressed: () => Navigator.pop(context)
                )
              )
            ],
          ),
        )
      )
    );
  }
}