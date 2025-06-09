import 'package:flutter/material.dart';
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
    """
    CREATE TABLE IF NOT EXISTS ${DBTables.subcategory}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      name TEXT,
      icon INTEGER,
      icon_font_family TEXT,
      category_group_id INTEGER,
      FOREIGN KEY(category_group_id) REFERENCES CategoryGroup(id)
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
      ('Financial', 0xeea2, 'MaterialIcons'),
      ('Investment', 0xf382, 'MaterialIcons')
    """,
    """
    INSERT INTO ${DBTables.subcategory} (name, icon, icon_font_family, category_group_id) VALUES
      ('Bar or liquor store', 0xe38c, 'MaterialIcons', 1), 
      ('Restaurant or fast food', 0xf049, 'MaterialIcons', 1),
      ('Supermarket or grocery', 0xe112, 'MaterialIcons', 1),
      ('Babies or kids', 0xe612, 'MaterialIcons', 2),
      ('House and garden', 0xf108, 'MaterialIcons', 2),
      ('Devices', 0xe1cb, 'MaterialIcons', 2),
      ('Pharmacy', 0xf186, 'MaterialIcons', 2),
      ('Jewerly or accesories', 0xf05e7, 'MaterialIcons', 2),
      ('Pets', 0xe4a1, 'MaterialIcons', 2),
      ('Stationery', 0xefaf, 'MaterialIcons', 2),
      ('Redeem', 0xe511, 'MaterialIcons', 2),
      ('Clothes and footwear', 0xe15d, 'MaterialIcons', 2),
      ('Health and care', 0xe253, 'MaterialIcons', 2),
      ('Free time', 0xe3fe, 'MaterialIcons', 2),
      ('Energy or utilitarian', 0xf079c, 'MaterialIcons', 3),
      ('Mortgage', 0xf2ee, 'MaterialIcons', 3),
      ('Maintenance', 0xe2f2, 'MaterialIcons', 3),
      ('Rent', 0xf052b, 'MaterialIcons', 3),
      ('Property insurance', 0xf379, 'MaterialIcons', 3),
      ('Services', 0xf31f, 'MaterialIcons', 3),
      ('Long distance', 0xe297, 'MaterialIcons', 4),
      ('Taxi', 0xe3a7, 'MaterialIcons', 4),
      ('Public transportation', 0xe1d5, 'MaterialIcons', 4),
      ('Business trip', 0xef0a, 'MaterialIcons', 4),
      ('Rent', 0xef2b, 'MaterialIcons', 5),
      ('Fuel', 0xf17c, 'MaterialIcons', 5),
      ('Parking', 0xe39d, 'MaterialIcons', 5),
      ('Car repair', 0xef2c, 'MaterialIcons', 5),
      ('Car insurance', 0xf06e3, 'MaterialIcons', 5),
      ('Smoke or alcohol', 0xe5c8, 'MaterialIcons', 6),
      ('Beauty or welfare', 0xf3bb, 'MaterialIcons', 6),
      ('Charity or redeem', 0xf4a9, 'MaterialIcons', 6),
      ('Heathcare or doctor', 0xf1bf, 'MaterialIcons', 6),
      ('Culture or sports events', 0xf0668, 'MaterialIcons', 6),
      ('Fitness or sports', 0xe28d, 'MaterialIcons', 6),
      ('School, courses or development', 0xf33c, 'MaterialIcons', 6),
      ('Special events', 0xef0f, 'MaterialIcons', 6),
      ('Books, audio or suscriptions', 0xe3dd, 'MaterialIcons', 6),
      ('Games of chance or lottery', 0xef32, 'MaterialIcons', 6),
      ('Hobbies', 0xe622, 'MaterialIcons', 6),
      ('TV or Streaming', 0xe687, 'MaterialIcons', 6),
      ('Vacations, trips or hotels', 0xeec6, 'MaterialIcons', 6),
      ('Internet', 0xe544, 'MaterialIcons', 7),
      ('Postal services', 0xe3c4, 'MaterialIcons', 7),
      ('Software, apps or games', 0xf05c4, 'MaterialIcons', 7),
      ('Phone or smartphone', 0xe829, 'MaterialIcons', 7),
      ('Salary', 0xf266, 'MaterialIcons', 8),
      ('Sale', 0xf353, 'MaterialIcons', 8),
      ('Taxes', 0xf2f0, 'MaterialIcons', 8),
      ('Cashback (Taxes, shopping)', 0xe68c, 'MaterialIcons', 8),
      ('Coupons or checks', 0xef75, 'MaterialIcons', 8),
      ('Loans or interest', 0xe66d, 'MaterialIcons', 8),
      ('Rates or charges', 0xf0547, 'MaterialIcons', 8),
      ('Gifts', 0xf37d, 'MaterialIcons', 8),
      ('Penalty', 0xf18a, 'MaterialIcons', 8),
      ('Donations or quotes', 0xf312, 'MaterialIcons', 8),
      ('Rental', 0xf114, 'MaterialIcons', 8),
      ('Counseling', 0xe33d, 'MaterialIcons', 8),
      ('Family allowance', 0xf311, 'MaterialIcons', 8)
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