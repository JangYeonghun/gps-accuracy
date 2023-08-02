// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DatabaseHelper {
//   static final _databaseName = "accelerometer.db";
//   static final _databaseVersion = 1;
//
//   static final table = 'accelerometer_data';
//   static final columnId = '_id';
//   static final columnX = 'x';
//   static final columnY = 'y';
//   static final columnZ = 'z';
//
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
//
//   static Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), _databaseName);
//     return await openDatabase(path,
//         version: _databaseVersion, onCreate: _onCreate);
//   }
//
//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE $table (
//         $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $columnX REAL NOT NULL,
//         $columnY REAL NOT NULL,
//         $columnZ REAL NOT NULL
//       )
//     ''');
//   }
//
//   Future<void> insertAccelerometerData(double x, double y, double z) async {
//     Database db = await instance.database;
//     await db.insert(table, {columnX: x, columnY: y, columnZ: z});
//   }
//
//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     Database db = await instance.database;
//     return await db.query(table);
//   }
//
//   Future<void> createAndInitTable() async {
//     Database db = await instance.database;
//     await db.execute('DROP TABLE IF EXISTS $table');
//     await db.execute('''
//       CREATE TABLE $table (
//         $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $columnX REAL NOT NULL,
//         $columnY REAL NOT NULL,
//         $columnZ REAL NOT NULL
//       )
//     ''');
//   }
// }
