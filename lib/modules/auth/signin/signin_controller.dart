import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SigninController {
  void goToLogin(BuildContext context) {
    if (context.canPop()) context.pop('/login');
    context.push("/login");
  }
}