import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SigninController {
  void goToLogin(BuildContext context) => context.go('/login');

  void signin(BuildContext context) {
    context.go("/");
  }
}