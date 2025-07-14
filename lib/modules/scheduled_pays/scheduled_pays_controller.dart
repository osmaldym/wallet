import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/relationships/r_scheduled_pay.dart';

class ScheduledPaysController {
  Dao dao = Dao();

  Future<List<RelatedScheduledPay>> getScheduledPays({ int? type }){
    return dao.relatedScheduledPays(type: type);
  }
}