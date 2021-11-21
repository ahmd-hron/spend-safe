import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DataBase {
  static const String expenseTable = 'user_expense';
  static const String balanceTable = 'user_balance';
  static Future<sql.Database> getDataBase() async {
    String rawPath = await sql.getDatabasesPath();
    String dbPath = path.join(rawPath, 'user_database1');
    return sql.openDatabase(dbPath, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $expenseTable(id TEXT PRIMARY KEY,amount REAL,date TEXT,title TEXT,decription TEXT,category TEXT);');
      return db.execute(
          'CREATE TABLE $balanceTable(id TEXT PRIMARY KEY,amount REAL,date TEXT,title TEXT,decription TEXT);');
    }, version: 1);
  }

  static Future insertExpense(Map<String, dynamic> values) async {
    final db = await getDataBase();
    await db.insert(expenseTable, values);
  }

  static Future updateExpense(String id, Map<String, dynamic> values) async {
    final db = await getDataBase();
    await db.update(expenseTable, values, where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> readExpenseTable() async {
    final db = await getDataBase();
    return db.query(expenseTable);
  }

  static Future insertInBalance(Map<String, dynamic> values) async {
    final db = await getDataBase();
    await db.insert(balanceTable, values);
  }

  static Future updateBonuse(String id, Map<String, dynamic> values) async {
    final db = await getDataBase();
    await db.update(balanceTable, values, where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> readFromBalance() async {
    final db = await getDataBase();
    return db.query(balanceTable);
  }

  static Future deleteFromTable(String tableName, String id) async {
    final db = await getDataBase();
    db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future clearDatabaseTable(String tableName) async {
    final db = await getDataBase();
    db.delete(tableName);
  }
}
