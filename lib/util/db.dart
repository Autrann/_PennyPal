import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users_database4.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        tipo TEXT DEFAULT 'standard',
        imagePath TEXT DEFAULT 'assets/avatar.svg',
        balance double DEFAULT 0.0,
        transactions TEXT DEFAULT '[]'
      )
    ''');
  }

  Future<int> registerUser(String nombre, String email, String password) async {
    final db = await database;
    return await db.insert(
      'users',
      {'nombre': nombre, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    var result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateUserTipo(int id, String tipo) async {
    final db = await database;
    return await db.update(
      'users',
      {'tipo': tipo},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateUserImagePath(int id, String imagePath) async {
    final db = await database;
    return await db.update(
      'users',
      {'imagePath': imagePath},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateBalance(int id, double balance) async {
    final db = await database;
    return await db.update(
      'users',
      {'balance': balance},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> checkEmailExists(String email) async {
    final db = await database;
    var result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

Future<void> addPurchase(int userId, String productName, double cost) async {
  final db = await database;

  var result = await db.query(
    'users',
    columns: ['transactions'],
    where: 'id = ?',
    whereArgs: [userId],
  );

  if (result.isNotEmpty) {
    String transactionsJson = result.first['transactions'] as String;
    List<Map<String, dynamic>> transactions = List<Map<String, dynamic>>.from(jsonDecode(transactionsJson));

    transactions.add({
      'productName': productName,
      'cost': cost,
    });

    String updatedTransactionsJson = jsonEncode(transactions);
    await db.update(
      'users',
      {'transactions': updatedTransactionsJson},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}

Future<List<Map<String, dynamic>>> getPurchases(int userId) async {
  final db = await database;

  var result = await db.query(
    'users',
    columns: ['transactions'],
    where: 'id = ?',
    whereArgs: [userId],
  );

  if (result.isNotEmpty) {
    String transactionsJson = result.first['transactions'] as String;
    return List<Map<String, dynamic>>.from(jsonDecode(transactionsJson));
  }
  return [];
}
}
