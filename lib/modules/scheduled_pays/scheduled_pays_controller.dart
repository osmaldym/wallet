import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';

class ScheduledPaysController {
  Dao dao = Dao();

  Future<List<ScheduledPay>> getScheduledPays({ int? type }){
    return dao.scheduledPays(type: type);
  }
}