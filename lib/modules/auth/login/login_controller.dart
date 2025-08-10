import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/core/constants/app_route.dart';

class LoginController {
  void goToSignin(BuildContext context) => context.push(AppRoute.signin);

  void login(BuildContext context) {
    context.go("/");
  }
}