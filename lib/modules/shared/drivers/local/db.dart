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
    CREATE TABLE IF NOT EXISTS ${DBTables.category}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      user_id INTEGER,
      name TEXT,
      icon INTEGER,
      icon_font_family TEXT,
      FOREIGN KEY(user_id) REFERENCES User(id)
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.subcategory}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      name TEXT,
      icon INTEGER,
      icon_font_family TEXT,
      category_id INTEGER,
      is_category_reference BOOL,
      FOREIGN KEY(category_id) REFERENCES Category(id)
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.recordRepetition}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      times_placed INTEGER,
      repeated_times INTEGER,
      for INTEGER,
      for_date TEXT,
      repeat_every INTEGER
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.recordRepetitionWeekly}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      record_repetition_id INTEGER,
      days_of_week TEXT,
      FOREIGN KEY(record_repetition_id) REFERENCES ${DBTables.recordRepetition}(id)
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.recordRepetitionMonthly}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      record_repetition_id INTEGER,
      same_day_of_month BOOL,
      every_last_day_of_month BOOL,
      every_number_day INTEGER,
      week_number INTEGER,
      FOREIGN KEY(record_repetition_id) REFERENCES ${DBTables.recordRepetition}(id)
    )
    """,
  ];

  final List<String> allFillQueries = [
    """
    INSERT INTO ${DBTables.category} (name, icon, icon_font_family) VALUES
      ('Food and drink', 0xe532, 'MaterialIcons'),
      ('Shopping', 0xf3ee, 'MaterialIcons'),
      ('House', 0xf114, 'MaterialIcons'),
      ('Transport', 0xf18f, 'MaterialIcons'),
      ('Vehicles', 0xf06fd, 'MaterialIcons'),
      ('Life and entertainment', 0xe25b, 'MaterialIcons'),
      ('Comunication or PC', 0xe6e7, 'MaterialIcons'),
      ('Financial', 0xeea2, 'MaterialIcons'),
      ('Investment', 0xf382, 'MaterialIcons')
    """,
    """
    INSERT INTO ${DBTables.subcategory} (name, icon, icon_font_family, category_id, is_category_reference) VALUES
      (null, null, null, 1, true),
      ('Bar or liquor store', 0xe38c, 'MaterialIcons', 1, false),
      ('Restaurant or fast food', 0xf049, 'MaterialIcons', 1, false),
      ('Supermarket or grocery', 0xe112, 'MaterialIcons', 1, false),
      (null, null, null, 2, true),
      ('Babies or kids', 0xe612, 'MaterialIcons', 2, false),
      ('House and garden', 0xf108, 'MaterialIcons', 2, false),
      ('Devices', 0xe1cb, 'MaterialIcons', 2, false),
      ('Pharmacy', 0xf186, 'MaterialIcons', 2, false),
      ('Jewerly or accesories', 0xf05e7, 'MaterialIcons', 2, false),
      ('Pets', 0xe4a1, 'MaterialIcons', 2, false),
      ('Stationery', 0xefaf, 'MaterialIcons', 2, false),
      ('Redeem', 0xe511, 'MaterialIcons', 2, false),
      ('Clothes and footwear', 0xe15d, 'MaterialIcons', 2, false),
      ('Health and care', 0xe253, 'MaterialIcons', 2, false),
      ('Free time', 0xe3fe, 'MaterialIcons', 2, false),
      (null, null, null, 3, true),
      ('Energy or utilitarian', 0xf079c, 'MaterialIcons', 3, false),
      ('Mortgage', 0xf2ee, 'MaterialIcons', 3, false),
      ('Maintenance', 0xe2f2, 'MaterialIcons', 3, false),
      ('Rent', 0xf052b, 'MaterialIcons', 3, false),
      ('Property insurance', 0xf379, 'MaterialIcons', 3, false),
      ('Services', 0xf31f, 'MaterialIcons', 3, false),
      (null, null, null, 4, true),
      ('Long distance', 0xe297, 'MaterialIcons', 4, false),
      ('Taxi', 0xe3a7, 'MaterialIcons', 4, false),
      ('Public transportation', 0xe1d5, 'MaterialIcons', 4, false),
      ('Business trip', 0xef0a, 'MaterialIcons', 4, false),
      (null, null, null, 5, true),
      ('Rent', 0xef2b, 'MaterialIcons', 5, false),
      ('Fuel', 0xf17c, 'MaterialIcons', 5, false),
      ('Parking', 0xe39d, 'MaterialIcons', 5, false),
      ('Car repair', 0xef2c, 'MaterialIcons', 5, false),
      ('Car insurance', 0xf06e3, 'MaterialIcons', 5, false),
      (null, null, null, 6, true),
      ('Smoke or alcohol', 0xe5c8, 'MaterialIcons', 6, false),
      ('Beauty or welfare', 0xf3bb, 'MaterialIcons', 6, false),
      ('Charity or redeem', 0xf4a9, 'MaterialIcons', 6, false),
      ('Heathcare or doctor', 0xf1bf, 'MaterialIcons', 6, false),
      ('Culture or sports events', 0xf0668, 'MaterialIcons', 6, false),
      ('Fitness or sports', 0xe28d, 'MaterialIcons', 6, false),
      ('School, courses or development', 0xf33c, 'MaterialIcons', 6, false),
      ('Special events', 0xef0f, 'MaterialIcons', 6, false),
      ('Books, audio or suscriptions', 0xe3dd, 'MaterialIcons', 6, false),
      ('Games of chance or lottery', 0xef32, 'MaterialIcons', 6, false),
      ('Hobbies', 0xe622, 'MaterialIcons', 6, false),
      ('TV or Streaming', 0xe687, 'MaterialIcons', 6, false),
      ('Vacations, trips or hotels', 0xeec6, 'MaterialIcons', 6, false),
      (null, null, null, 7, true),
      ('Internet', 0xe544, 'MaterialIcons', 7, false),
      ('Postal services', 0xe3c4, 'MaterialIcons', 7, false),
      ('Software, apps or games', 0xf05c4, 'MaterialIcons', 7, false),
      ('Phone or smartphone', 0xe829, 'MaterialIcons', 7, false),
      (null, null, null, 8, true),
      ('Salary', 0xf266, 'MaterialIcons', 8, false),
      ('Sale', 0xf353, 'MaterialIcons', 8, false),
      ('Taxes', 0xf2f0, 'MaterialIcons', 8, false),
      ('Cashback (Taxes, shopping)', 0xe68c, 'MaterialIcons', 8, false),
      ('Coupons or checks', 0xef75, 'MaterialIcons', 8, false),
      ('Loans or interest', 0xe66d, 'MaterialIcons', 8, false),
      ('Rates or charges', 0xf0547, 'MaterialIcons', 8, false),
      ('Gifts', 0xf37d, 'MaterialIcons', 8, false),
      ('Penalty', 0xf18a, 'MaterialIcons', 8, false),
      ('Donations or quotes', 0xf312, 'MaterialIcons', 8, false),
      ('Rental', 0xf114, 'MaterialIcons', 8, false),
      ('Counseling', 0xe33d, 'MaterialIcons', 8, false),
      ('Family allowance', 0xf311, 'MaterialIcons', 8, false),
      (null, null, null, 9, true),
      ('Savings', 0xf336, 'MaterialIcons', 9, false),
      ('Real state', 0xf244, 'MaterialIcons', 9, false),
      ('Collection', 0xe076, 'MaterialIcons', 9, false),
      ('Financial invertions', 0xe67f, 'MaterialIcons', 9, false),
      ('Cars or properties', 0xf0bf, 'MaterialIcons', 9, false)
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