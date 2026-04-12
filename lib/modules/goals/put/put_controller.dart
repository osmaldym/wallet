import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/goal.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_goals.dart';

class PutController {
  Dao dao = Dao();

  Future<RelatedGoal?> putGoal(Goal goal) async {
    int id = await dao.putGoal(goal.toMap());
    return await dao.relatedGoal(id);
  }
}