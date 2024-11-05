import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginController {
  void goToSignin(BuildContext context) => context.push("/signin");

  void login(BuildContext context) {
    context.go("/");
  }
}