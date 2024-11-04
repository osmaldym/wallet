import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginController {
  Future<void> goToSignin(BuildContext context) => context.push("/signin");
}