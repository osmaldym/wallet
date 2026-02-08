import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/modules/home/home_page.dart';
import 'package:wallet/modules/records/records_page.dart';
import 'package:wallet/modules/scheduled_pays/put/put_page.dart' as scheduled_pays;
import 'package:wallet/modules/scheduled_pays/info/pay_info_page.dart' as scheduled_pays;
import 'package:wallet/modules/scheduled_pays/scheduled_pays_page.dart';
import 'package:wallet/modules/settings/settings_page.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_scheduled_pay.dart';

import '../../modules/auth/login/login_page.dart';
import '../../modules/auth/signin/signin_page.dart';

class AppRoutes {
  /// Pages routes
  static final GoRouter pages = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      _newRoot(
        const Home(),
        routes: [
          _newRoute('login', page: const Login()),
          _newRoute('signin', page: const Signin()),
          _newRoute(
            "scheduled_pays", page: const ScheduledPays(),
            childs: [
              _newRoute(
                "put",
                builder: (context, state) => scheduled_pays.Put(relatedScheduledPay: state.extra as RelatedScheduledPay?,)
              ),
              _newRoute(
                "pay_info",
                builder: (context, state) => scheduled_pays.PayInfoPage(relatedScheduledPay: state.extra as RelatedScheduledPay,)
              ),
            ]
          ),
          _newRoute('records', page: const RecordsPage()),
          _newRoute('settings', page: const SettingsPage()),
        ]
      )
    ]
  );

  /// Set's routes more easier
  static GoRoute _newRoute(String url, { Widget? page, List<RouteBase> childs = const <RouteBase>[], Function(BuildContext context, GoRouterState state)? builder }){
    return GoRoute(
      path: url,
      builder: (context, state) => builder != null ? builder(context, state) : page,
      routes: childs,
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