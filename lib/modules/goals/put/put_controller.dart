import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/goal.dart';

class PutController {
  Dao dao = Dao();

  Future<Goal?> putGoal(Goal goal) async {
    int id = await dao.putGoal(goal.toMap());
    return await dao.goal(id);
  }
}