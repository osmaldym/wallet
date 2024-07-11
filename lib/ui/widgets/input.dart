import 'package:flutter/material.dart';

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
    this.placeholder = 'Email',
    this.text = '',
    this.type = Types.email,
    this.error = "This field is required",
    this.info = "Something is wrong with this field",
    this.focus = false
  });

  @override
  Widget build(BuildContext context) {
    TextInputType textType = TextInputType.name;

    switch (type) {
      case Types.email:
        textType = TextInputType.emailAddress;
        placeholder = 'Email';
        break;
      
      case Types.pass:
        textType = TextInputType.visiblePassword;
        placeholder = 'Password';
        break;
      
      case Types.text:
        textType = TextInputType.text;
        placeholder = 'Text';
        break;
      
      case Types.number:
        textType = TextInputType.number;
        placeholder = 'Numbers';
        break;

      default:
        textType = TextInputType.name;
        placeholder = 'Name';
    }

    return TextFormField(
      keyboardType: textType,
      autofocus: focus,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        // errorText: error,
        helperText: info,
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