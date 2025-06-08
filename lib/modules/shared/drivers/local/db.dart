import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet/core/constants/app_db.dart';

class DB {
  final List<String> allCreateQueries = [
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.user}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id TEXT,
      email TEXT,
      names TEXT,
      password text,
      img TEXT
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.account}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      user_id INTEGER,
      title TEXT,
      FOREIGN KEY(user_id) REFERENCES User(id)
    )
    """,
    """
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
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.scheduledPay}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      user_id INTEGER,
      image_id INTEGER,
      category_id INTEGER,
      account_id INTEGER,
      budget_id INTEGER,
      goal_id INTEGER,
      frecuency_id INTEGER,
      payment_method_id INTEGER,
      notification_id INTEGER,
      type INTEGER,
      title TEXT,
      automatic BOOL DEFAULT 0,
      amount REAL,
      date TEXT,
      note TEXT,
      beneficiary TEXT,
      FOREIGN KEY(user_id) REFERENCES User(id)
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.categoryGroup}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      user_id INTEGER,
      name TEXT,
      icon INTEGER,
      icon_font_family TEXT,
      FOREIGN KEY(user_id) REFERENCES User(id)
    )
    """,
  ];

  final List<String> allFillQueries = [
    """
    INSERT INTO ${DBTables.categoryGroup} (name, icon, icon_font_family) VALUES
      ('Food and drink', 0xe532, 'MaterialIcons'), 
      ('Shopping', 0xf3ee, 'MaterialIcons'),
      ('House', 0xf114, 'MaterialIcons'),
      ('Transport', 0xf18f, 'MaterialIcons'),
      ('Vehicles', 0xf06fd, 'MaterialIcons'),
      ('Life and entertainment', 0xe25b, 'MaterialIcons'),
      ('Comunication or PC', 0xe6e7, 'MaterialIcons'),
      ('Financial expenses', 0xf1df, 'MaterialIcons'),
      ('Investment', 0xf382, 'MaterialIcons'),
      ('Income', 0xeea2, 'MaterialIcons')
    """,
  ];

  Future<Database> get() async {
    return openDatabase(
      join(await getDatabasesPath(), DBNames.walletLocal),
      onCreate: (db, version) {
        for (final query in allCreateQueries) db.execute(query);
        for (final query in allFillQueries) db.execute(query);
      },
      version: 1
    );
  }
}