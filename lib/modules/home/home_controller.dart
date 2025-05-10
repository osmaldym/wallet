import 'dart:async';

import 'package:wallet/core/constants/app_db.dart';
import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart' as Model;
import 'package:wallet/modules/shared/drivers/local/models/user.dart';
import 'package:wallet/modules/shared/widgets/fragments/account.dart';

class HomeController {
  late Dao daoLocal = Dao();

  Future<void> createGuest() async {
    List<User> users = await daoLocal.users();
    if (users.isEmpty){
      Map<String, Object?> data = {
        "names": "Guest"
      };
      await daoLocal.insert(DBTables.user, data);
    }
  }

  Future<void> addAccount(String name) async {
    List<User> users = await daoLocal.users();
    User actualUser = users.first;

    Map<String, Object?> data = { 
      "title": name,
      "user_id": actualUser.serverId ?? actualUser.id
    };
    await daoLocal.insert(DBTables.account, data);
  }

  Future<List<Account>> getAccounts() async {
    List<Model.Account> accounts = await daoLocal.accounts();
    List<Account> accountsToShow = [
      Account(
        isTotal: true,
        quantity: "+180,000",
        onTap: (){},
      ),
    ];

    for (final account in accounts)
      accountsToShow.add(
        Account(
          name: account.title,
          quantity: '+100,000',
          onTap: (){},
        )
      );

    return accountsToShow;
  }
}