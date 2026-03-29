import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet/core/constants/app_route.dart';
import 'package:wallet/modules/shared/widgets/header.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';

class GoalsPage extends StatefulWidget {
  GoalsPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CHeader(
        title: context.l10n!.goals,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push(AppRoute.goalsPut),
      ),
    );
  }
}