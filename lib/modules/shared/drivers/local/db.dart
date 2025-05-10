import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet/core/constants/app_db.dart';

class DB {
  final String _SQL_CREATE_USER = """
    CREATE TABLE IF NOT EXISTS ${DBTables.user}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id TEXT,
      email TEXT,
      names TEXT,
      password text,
      img TEXT
    )
  """;

  final String _SQL_CREATE_ACCOUNTS = """
    CREATE TABLE IF NOT EXISTS ${DBTables.account}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      user_id INTEGER,
      title TEXT,
      FOREIGN KEY(user_id) REFERENCES User(id)
    )
  """;

  Future<Database> get() async {
    return openDatabase(
      join(await getDatabasesPath(), DBNames.walletLocal),
      onCreate: (db, version) {
        db.execute(_SQL_CREATE_USER);
        db.execute(_SQL_CREATE_ACCOUNTS);
      },
      version: 1
    );
  }
}