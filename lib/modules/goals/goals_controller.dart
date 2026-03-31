import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_goals.dart';

class GoalsController {
  Dao dao = Dao();

  Future<List<RelatedGoal>> getRelatedGoals() => dao.relatedGoals();
}