import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart';
import 'package:wallet/modules/shared/drivers/local/models/scheduled_pay.dart';

class PutController {
  late Dao dao = Dao();

  Future<void> createPay(ScheduledPay pay) async {
    await dao.putScheduledPay(pay.toMap());
  }

  Future<List<Account>> getAllAccounts() async {
    return await dao.accounts();
  }
}