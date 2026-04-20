import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_goals.dart';

class GoalsController {
  Dao dao = Dao();

  Future<List<RelatedGoal>> getRelatedGoals() => dao.relatedGoals();

  /// Increase or decrease the goal saved amount with the amount provided
  Future<int> operationUpdateGoalSaved(int id, double saved, double amount, { bool decrease = false }) {
    if (decrease) saved -= amount;
    else saved += amount;

    return dao.updateGoalSaved(id, saved);
  }
}