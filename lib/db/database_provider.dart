// import 'package:mynotes/utilities/exceptions/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class DatabaseProvider {
//   Database? _db;

//   // Constructor to initialize the database
//   DatabaseProvider() {
//     _initDatabase();
//   }

//   Future<void> _initDatabase() async {
//     _db = await _openDatabase();
//   }

//   Future<Database> get database async {
//     if (_db != null) {
//       return _db!;
//     }
//     _db = await _openDatabase();
//     return _db!;
//   }

//   Future<Database> _openDatabase() async {
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, 'notes.db');
//       final db =
//           await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
//         await db.execute(createUserTable);
//         await db.execute(createNoteTable);
//       });
//       return db;
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentDirectoryException();
//     }
//   }

//   Future<void> close() async {
//     final db = await database;
//     await db.close();
//     _db = null;
//   }

//   Future<int> insert(String table, Map<String, Object?> values,
//       {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) async {
//     try {
//       final db = await database;
//       return await db.insert(table, values,
//           nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<int> update(String table, Map<String, Object?> values,
//       {String? where,
//       List<Object?>? whereArgs,
//       ConflictAlgorithm? conflictAlgorithm}) async {
//     try {
//       final db = await database;
//       return await db.update(table, values,
//           where: where,
//           whereArgs: whereArgs,
//           conflictAlgorithm: conflictAlgorithm);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<int> delete(String table,
//       {String? where, List<Object?>? whereArgs}) async {
//     try {
//       final db = await database;
//       return await db.delete(table, where: where, whereArgs: whereArgs);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<List<Map<String, Object?>>> query(String table,
//       {bool? distinct,
//       List<String>? columns,
//       String? where,
//       List<Object?>? whereArgs,
//       String? groupBy,
//       String? having,
//       String? orderBy,
//       int? limit,
//       int? offset}) async {
//     try {
//       final db = await database;
//       return await db.query(table,
//           distinct: distinct,
//           columns: columns,
//           where: where,
//           whereArgs: whereArgs,
//           groupBy: groupBy,
//           having: having,
//           orderBy: orderBy,
//           limit: limit,
//           offset: offset);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<List<Map<String, Object?>>> rawQuery(String sql,
//       [List<Object?>? arguments]) async {
//     try {
//       final db = await database;
//       return await db.rawQuery(sql, arguments);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<int> rawInsert(String sql, [List<Object?>? arguments]) async {
//     try {
//       final db = await database;
//       return await db.rawInsert(sql, arguments);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<int> rawDelete(String sql, [List<Object?>? arguments]) async {
//     try {
//       final db = await database;
//       return await db.rawDelete(sql, arguments);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async {
//     try {
//       final db = await database;
//       return await db.rawUpdate(sql, arguments);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<T> transaction<T>(Future<T> Function(Transaction txn) action,
//       {bool? exclusive}) async {
//     try {
//       final db = await database;
//       return await db.transaction(action, exclusive: exclusive);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Batch batch() {
//     if (_db == null) {
//       throw Exception("Database is not initialized.");
//     }
//     return _db!.batch();
//   }

//   Future<T> devInvokeMethod<T>(String method, [Object? arguments]) async {
//     try {
//       final db = await database;
//       return await db.devInvokeMethod<T>(method, arguments);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<T> devInvokeSqlMethod<T>(String method, String sql,
//       [List<Object?>? arguments]) async {
//     try {
//       final db = await database;
//       return await db.devInvokeSqlMethod<T>(method, sql, arguments);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<QueryCursor> queryCursor(String table,
//       {bool? distinct,
//       List<String>? columns,
//       String? where,
//       List<Object?>? whereArgs,
//       String? groupBy,
//       String? having,
//       String? orderBy,
//       int? limit,
//       int? offset,
//       int? bufferSize}) async {
//     try {
//       final db = await database;
//       return await db.queryCursor(table,
//           distinct: distinct,
//           columns: columns,
//           where: where,
//           whereArgs: whereArgs,
//           groupBy: groupBy,
//           having: having,
//           orderBy: orderBy,
//           limit: limit,
//           offset: offset,
//           bufferSize: bufferSize);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<QueryCursor> rawQueryCursor(String sql, List<Object?>? arguments,
//       {int? bufferSize}) async {
//     try {
//       final db = await database;
//       return await db.rawQueryCursor(sql, arguments, bufferSize: bufferSize);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }

//   Future<T> readTransaction<T>(
//       Future<T> Function(Transaction txn) action) async {
//     try {
//       final db = await database;
//       return await db.readTransaction(action);
//     } catch (e) {
//       // Add proper error handling here
//       rethrow;
//     }
//   }
// }

// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
//   "id" INTEGER NOT NULL,
//   "email" TEXT NOT NULL UNIQUE,
//   PRIMARY KEY("id" AUTOINCREMENT)
// )''';

// const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
//   "id" INTEGER NOT NULL,
//   "user_id" INTEGER NOT NULL,
//   "text" TEXT,
//   "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
//   PRIMARY KEY("id" AUTOINCREMENT),
//   FOREIGN KEY("user_id") REFERENCES "user"("id")
// )''';
