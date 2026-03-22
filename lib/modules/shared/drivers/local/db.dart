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
      amount REAL,
      is_total INTEGER,
      FOREIGN KEY(user_id) REFERENCES User(id)
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.session}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      user_id INTEGER,
      started_at INTEGER,
      finished_at INTEGER,
      public_ip TEXT,
      token TEXT,
      finished_by_user INTEGER,
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
      currency_id INTEGER,
      type INTEGER,
      title TEXT,
      automatic INTEGER DEFAULT 0,
      amount REAL,
      date INTEGER,
      note TEXT,
      beneficiary TEXT,
      completed_pay INTEGER,
      FOREIGN KEY(user_id) REFERENCES ${DBTables.user}(id),
      FOREIGN KEY(category_id) REFERENCES ${DBTables.category}(id),
      FOREIGN KEY(account_id) REFERENCES ${DBTables.account}(id),
      FOREIGN KEY(frecuency_id) REFERENCES ${DBTables.recordRepetition}(id),
      FOREIGN KEY(notification_id) REFERENCES ${DBTables.notifications}(id),
      FOREIGN KEY(currency_id) REFERENCES ${DBTables.currencies}(id)
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
      is_category_reference INTEGER,
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
      for_date INTEGER,
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
      same_day_of_month INTEGER,
      every_last_day_of_month INTEGER,
      every_number_day INTEGER,
      week_number INTEGER,
      FOREIGN KEY(record_repetition_id) REFERENCES ${DBTables.recordRepetition}(id)
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.notifications}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      name TEXT,
      locale_name TEXT
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.currencies}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      iso TEXT,
      symbol TEXT,
      locale TEXT,
      country TEXT
    )
    """,
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.record}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      user_id INTEGER,
      scheduled_pay_id INTEGER,
      date INTEGER,
      amount REAL,
      paid INTEGER,
      date_paid INTEGER,
      expired INTEGER,
      balance REAL,
      FOREIGN KEY(user_id) REFERENCES ${DBTables.user}(id),
      FOREIGN KEY(scheduled_pay_id) REFERENCES ${DBTables.scheduledPay}(id)
    )
    """,
    """
      CREATE TABLE IF NOT EXISTS ${DBTables.icons}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id INTEGER,
        name TEXT,
        hex_code INTEGER,
        icon_font_family TEXT
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
    """
    INSERT INTO ${DBTables.notifications} (name, locale_name) VALUES
      ('15 minutes before', 'fifteenMinutesBefore'),
      ('30 minutes before', 'thirtyMinutesBefore'),
      ('1 hour before', 'oneHourBefore'),
      ('2 hours before', 'twoHoursBefore'),
      ('3 hours before', 'threeHoursBefore'),
      ('6 hours before', 'sixHoursBefore'),
      ('8 hours before', 'eightHoursBefore'),
      ('12 hours before', 'twelveHoursBefore'),
      ('1 day before', 'oneDayBefore')
    """,
    """
    INSERT INTO ${DBTables.account} (title, amount, is_total) VALUES ('Total', '0.0', 1)
    """,
    """
    INSERT INTO ${DBTables.currencies} (iso, symbol, locale, country) VALUES
      ('USD', '\$', 'en', 'us'),
      ('EUR', '€', 'es', 'es'),
      ('DOP', '\$', 'es', 'do'),
      ('ARS', '\$', 'es', 'ar'),
      ('BOB', 'Bs', 'es', 'bo'),
      ('COP', '\$', 'es', 'co'),
      ('CRC', '₡', 'es', 'cr'),
      ('CUP', '\$', 'es', 'cu'),
      ('GTQ', 'Q', 'es', 'gt'),
      ('HNL', 'L', 'es', 'hn'),
      ('MXN', '\$', 'es', 'mx'),
      ('NIO', 'C\$', 'es', 'ni'),
      ('PAB', '₲', 'es', 'py'),
      ('UYU', '\$', 'es', 'uy'),
      ('VED', 'Bs.D', 'es', 've')
    """,
    """
    INSERT INTO ${DBTables.icons} (name, hex_code, icon_font_family) VALUES
      ('Bar', 0xe38c, 'MaterialIcons'),
      ('Fast food', 0xf049, 'MaterialIcons'),
      ('Brunch dinning', 0xe112, 'MaterialIcons'),
      ('Stroller', 0xe612, 'MaterialIcons'),
      ('Home repair service', 0xf108, 'MaterialIcons'),
      ('Devices', 0xe1cb, 'MaterialIcons'),
      ('Pharmacy', 0xf186, 'MaterialIcons'),
      ('Diamond', 0xf05e7, 'MaterialIcons'),
      ('Pets', 0xe4a1, 'MaterialIcons'),
      ('Design services', 0xefaf, 'MaterialIcons'),
      ('Redeem', 0xe511, 'MaterialIcons'),
      ('Checkroom', 0xe15d, 'MaterialIcons'),
      ('Face retouching natural', 0xe253, 'MaterialIcons'),
      ('Mood', 0xe3fe, 'MaterialIcons'),
      ('Electric bolt', 0xf079c, 'MaterialIcons'),
      ('Real state agent', 0xf2ee, 'MaterialIcons'),
      ('Handyman', 0xe2f2, 'MaterialIcons'),
      ('Key', 0xf052b, 'MaterialIcons'),
      ('Shield', 0xf379, 'MaterialIcons'),
      ('Room preferences', 0xf31f, 'MaterialIcons'),
      ('Plane', 0xe297, 'MaterialIcons'),
      ('Taxi', 0xe3a7, 'MaterialIcons'),
      ('Directions bus', 0xe1d5, 'MaterialIcons'),
      ('Business center', 0xef0a, 'MaterialIcons'),
      ('Car rental', 0xef2b, 'MaterialIcons'),
      ('Gas station', 0xf17c, 'MaterialIcons'),
      ('Parking', 0xe39d, 'MaterialIcons'),
      ('Car repair', 0xef2c, 'MaterialIcons'),
      ('Car crash', 0xf06e3, 'MaterialIcons'),
      ('Smoking rooms', 0xe5c8, 'MaterialIcons'),
      ('Spa', 0xf3bb, 'MaterialIcons'),
      ('Volunteer activism', 0xf4a9, 'MaterialIcons'),
      ('Medication', 0xf1bf, 'MaterialIcons'),
      ('Stadium', 0xf0668, 'MaterialIcons'),
      ('Fitness center', 0xe28d, 'MaterialIcons'),
      ('School', 0xf33c, 'MaterialIcons'),
      ('Cake', 0xef0f, 'MaterialIcons'),
      ('Menu', 0xe3dd, 'MaterialIcons'),
      ('Casino', 0xef32, 'MaterialIcons'),
      ('Surfing', 0xe622, 'MaterialIcons'),
      ('TV', 0xe687, 'MaterialIcons'),
      ('Beach access', 0xeec6, 'MaterialIcons'),
      ('Rss feed', 0xe544, 'MaterialIcons'),
      ('Mail', 0xe3c4, 'MaterialIcons'),
      ('Browser updated', 0xf05c4, 'MaterialIcons'),
      ('Call', 0xe829, 'MaterialIcons'),
      ('Payments', 0xf266, 'MaterialIcons'),
      ('Sell', 0xf353, 'MaterialIcons'),
      ('Receipt', 0xf2f0, 'MaterialIcons'),
      ('Undo', 0xe68c, 'MaterialIcons'),
      ('Ticket', 0xef75, 'MaterialIcons'),
      ('Toll', 0xe66d, 'MaterialIcons'),
      ('Percent', 0xf0547, 'MaterialIcons'),
      ('Shopping bag', 0xf37d, 'MaterialIcons'),
      ('Police', 0xf18a, 'MaterialIcons'),
      ('Request quote', 0xf312, 'MaterialIcons'),
      ('House', 0xf114, 'MaterialIcons'),
      ('Info', 0xe33d, 'MaterialIcons'),
      ('Request page', 0xf311, 'MaterialIcons'),
      ('Savings', 0xf336, 'MaterialIcons'),
      ('Other houses', 0xf244, 'MaterialIcons'),
      ('Album', 0xe076, 'MaterialIcons'),
      ('Trending up', 0xe67f, 'MaterialIcons'),
      ('Garage', 0xf0bf, 'MaterialIcons'),
      ('Forklift', 0xf0866, 'MaterialIcons'),
      ('Store', 0xe60a, 'MaterialIcons'),
      ('Desk', 0xf079a, 'MaterialIcons'),
      ('Liquor', 0xe383, 'MaterialIcons'),
      ('Science', 0xf33d, 'MaterialIcons'),
      ('Biotech', 0xe0df, 'MaterialIcons'),
      ('Gamepad', 0xe2d0, 'MaterialIcons'),
      ('Controller', 0xf3ca, 'MaterialIcons'),
      ('Electric scooter', 0xe227, 'MaterialIcons'),
      ('Motorcycle', 0xe40a, 'MaterialIcons'),
      ('Electric bike', 0xf011, 'MaterialIcons'),
      ('Pedal bike', 0xf267, 'MaterialIcons'),
      ('Snowmobile', 0xe5ce, 'MaterialIcons'),
      ('Two wheeler', 0xe689, 'MaterialIcons'),
      ('Agriculture', 0xe063, 'MaterialIcons'),
      ('Truck', 0xe3a6, 'MaterialIcons'),
      ('Laptop', 0xe185, 'MaterialIcons'),
      ('PC', 0xefb2, 'MaterialIcons'),
      ('Chair', 0xe14d, 'MaterialIcons'),
      ('Smartphone', 0xe5c6, 'MaterialIcons'),
      ('Deck', 0xe1b7, 'MaterialIcons'),
      ('Photo camera', 0xe4b6, 'MaterialIcons'),
      ('Car', 0xe1d7, 'MaterialIcons')
    """,
  ];

  Future<Database> get() async {
    return openDatabase(
      join(await getDatabasesPath(), DBNames.walletLocal),
      onCreate: (db, version) {
        for (final query in allCreateQueries) db.execute(query).catchError((err) => print(err));
        for (final query in allFillQueries) db.execute(query).catchError((err) => print(err));
      },
      version: 1
    );
  }
}