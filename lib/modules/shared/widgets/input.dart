import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CInput extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String placeholder;
  String text;
  String error;
  String info;
  bool focus;
  Types type;

  CInput({
    super.key,
    this.placeholder = '',
    this.text = '',
    this.type = Types.email,
    this.error = "This field is required",
    this.info = "Something is wrong with this field",
    this.focus = false
  });

  @override
  Widget build(BuildContext context) {
    TextInputType textType = TextInputType.name;
    AppLocalizations? tr = AppLocalizations.of(context)!;

    switch (type) {
      case Types.email:
        textType = TextInputType.emailAddress;
        if (placeholder == '') placeholder = tr.email;
        break;
      
      case Types.pass:
        textType = TextInputType.visiblePassword;
        if (placeholder == '') placeholder = tr.password;
        break;
      
      case Types.text:
        textType = TextInputType.text;
        if (placeholder == '') placeholder = tr.text;
        break;
      
      case Types.number:
        textType = TextInputType.number;
        if (placeholder == '') placeholder = tr.numbers;
        break;

      default:
        textType = TextInputType.name;
        if (placeholder == '') placeholder = tr.name;
    }

    return TextFormField(
      keyboardType: textType,
      autofocus: focus,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        // errorText: error,
        helperText: tr.somethingWrongField,
        labelText: placeholder
      ),
    );
  }
}

enum Types {
  email,
  pass,
  text,
  number,
  name
}