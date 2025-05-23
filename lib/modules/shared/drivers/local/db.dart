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

  final String _SQL_CREATE_SESSION = """
    CREATE TABLE IF NOT EXISTS ${DBTables.session}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      user_id INTEGER,
      started_at TEXT,
      finished_at TEXT,
      public_ip TEXT,
      token TEXT,
      finished_by_user BOOLEAN,
      FOREIGN KEY(user_id) REFERENCES User(id)
    )
  """;

  final String _SQL_CREATE_SCHEDULED_PAY = """
    CREATE TABLE IF NOT EXISTS ${DBTables.scheduledPay}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      user_id INTEGER,
      image_id INTEGER,
      category_id INTEGER,
      budget_id INTEGER,
      goal_id INTEGER,
      frecuency_id INTEGER,
      payment_method_id INTEGER,
      notification_id INTEGER,
      type INTEGER,
      title TEXT,
      amount REAL,
      date TEXT,
      note TEXT,
      beneficiary TEXT,
      FOREIGN KEY(user_id) REFERENCES User(id)
    )
  """;

  Future<Database> get() async {
    return openDatabase(
      join(await getDatabasesPath(), DBNames.walletLocal),
      onCreate: (db, version) {
        db.execute(_SQL_CREATE_USER);
        db.execute(_SQL_CREATE_ACCOUNTS);
        db.execute(_SQL_CREATE_SESSION);
        db.execute(_SQL_CREATE_SCHEDULED_PAY);
      },
      version: 1
    );
  }
}