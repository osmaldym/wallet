import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';

class PutController {
  late Dao daoLocal = Dao();

  Future<void> createPay(ScheculedPay pay) async {
    await daoLocal.putScheduledPay(pay.toMap());
  }
}