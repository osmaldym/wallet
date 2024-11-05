import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/modules/home/home_page.dart';

import '../../modules/auth/login/login_page.dart';
import '../../modules/auth/signin/signin_page.dart';

class AppRoutes {
  /// Pages routes
  static final GoRouter pages = GoRouter(
    initialLocation: '/login',
    routes: <RouteBase>[
      _newRoot(
        const Home(),
        routes: [
          _newRoute('login', const Login()),
          _newRoute('signin', const Signin()),
        ]
      )
    ]
  );

  /// Set's routes more easier
  static GoRoute _newRoute(String url, Widget page, { List<RouteBase> childs = const <RouteBase>[] }){
    return GoRoute(
      path: url,
      builder: (context, state) => page,
      routes: childs
    );
  }
  /// Set the root route
  static GoRoute _newRoot(Widget page, { List<RouteBase> routes = const <RouteBase>[] }){
    return GoRoute(
      path: "/",
      builder: (context, state) => page,
      routes: routes,
    ); 
  }
}