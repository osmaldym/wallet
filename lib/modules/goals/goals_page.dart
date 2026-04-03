import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/constants/app_route.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/goals/goals_controller.dart';
import 'package:wallet/modules/goals/widgets/fragments/circular_progress_bar.dart';
import 'package:wallet/modules/goals/widgets/fragments/goal_options_btn.dart';
import 'package:wallet/modules/goals/widgets/modals/goal_modal.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_goals.dart';
import 'package:wallet/modules/shared/widgets/fragments/full_size_message.dart';
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
  GoalsController controller = GoalsController();
  Utils utils = Utils();
  NumberFormat? format;

  Future<List<RelatedGoal>>? _goals;

  void _reloadGoals() => _goals = controller.getRelatedGoals();

  @override
  void initState() {
    _reloadGoals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    format ??= NumberFormat("#,###.##", context.l10n?.localeName ?? "en_US");

    return Scaffold(
      appBar: CHeader(
        title: context.l10n!.goals,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push(AppRoute.goalsPut).then((_) => setState(() { _reloadGoals(); }))
      ),
      body: FutureBuilder<List<RelatedGoal>>(
          future: _goals,
          builder: (BuildContext context, AsyncSnapshot<List<RelatedGoal>> snapshotRelatedGoal) {
            if (snapshotRelatedGoal.connectionState == ConnectionState.done) {
              if (snapshotRelatedGoal.hasData) {
                List<RelatedGoal> rGoals = snapshotRelatedGoal.data!;
                return snapshotRelatedGoal.data!.isEmpty ? FullSizeMessage(
                  iconData: Icons.search_off,
                  title: context.l10n!.thereAreNoGoalsToShowYet,
                  subtitle: GestureDetector(
                    onTap: () => context.push(AppRoute.goalsPut).then((_) => setState(() { _reloadGoals(); })),
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n!.createANewGoal,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.of(context).textContrast
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          color: AppTheme.of(context).textContrast,
                        )
                      ],
                    )
                  ),
                ) : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  itemCount: rGoals.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) => ListTile(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => GoalModal(
                        icon: rGoals[i].icon,
                        title: rGoals[i].title,
                        automatic: rGoals[i].autoSaving != null,
                        saved: rGoals[i].saved,
                        dateTo: rGoals[i].dateTo,
                        dateFrom: rGoals[i].dateFrom,
                        total: rGoals[i].total,
                      )
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    trailing: GoalOptionsBtn(
                      onEditPressed: (){},
                      onIncreaseSavingPressed: (){},
                      onDecreaseSavingsPressed: (){},
                      onDeletePressed: (){},
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    leading: CCircularProgressIndicator(
                      value: (rGoals[i].saved ?? 0) / (rGoals[i].total ?? 0),
                      child: Icon(
                        size: 24,
                        color: AppTheme.of(context).textContrast,
                        rGoals[i].icon?.hashCode != null ? IconData(rGoals[i].icon!.hexCode!, fontFamily: rGoals[i].icon?.iconFontFamily) : Icons.flag_outlined
                      ),
                    ),
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      color: AppTheme.of(context).textContrast,
                    ),
                    title: Text(
                      rGoals[i].title ?? 'My goal',
                    ),
                    subtitle: Row(
                      spacing: 5,
                      children: [
                        Text(
                          format!.format(rGoals[i].total ?? 0),
                          style: TextStyle(
                            color: AppTheme.of(context).greenContrast 
                          ),
                        ),
                        CircleAvatar(
                          radius: 2.5,
                          backgroundColor: AppTheme.of(context).textContrast,
                        ),
                        Text(
                          utils.toReadableRelativeDate(rGoals[i].dateTo ?? DateTime.now(), context),
                          style: TextStyle(
                            color: AppTheme.of(context).textContrast,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }

            if (snapshotRelatedGoal.hasError) {
              print(snapshotRelatedGoal.error);
            }
        
            return const CircularProgressIndicator();
          }
        ),
    );
  }
}