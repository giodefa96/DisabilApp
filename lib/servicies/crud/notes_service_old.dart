// import 'package:flutter/foundation.dart';
// import 'package:mynotes/servicies/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class NotesService {
//   Database? _db;

// // User CRUD

//   Future<DatabaseUser> createUser({required String email}) async {
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: '$emailColumn = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }
//     final id = await db.insert(
//       userTable,
//       {emailColumn: email.toLowerCase()},
//     );
//     return DatabaseUser(
//       id: id,
//       email: email,
//     );
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: '$emailColumn = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isEmpty) {
//       throw UserDoesNotExistException();
//     }
//     return DatabaseUser.fromRow(results.first);
//   }

//   Future<void> deleteUser({required String email}) async {
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: '$emailColumn = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUserException();
//     }
//   }

// // Note CRUD

//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     final db = _getDatabaseOrThrow();

//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw UserDoesNotExistException();
//     }
//     const text = '';
//     final noteId = await db.insert(noteTable, {
//       userId: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });

//     return DatabaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//     );
//   }

//   Future<void> deleteNote({required DatabaseNote note}) async {
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: '$idColumn = ?',
//       whereArgs: [note.id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNoteException();
//     }
//   }

//   Future<int> deleteAllNotes({required DatabaseUser owner}) async {
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(noteTable);
//     return deletedCount;
//   }

//   Future<DatabaseNote> getNote({required int id}) async {
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       noteTable,
//       limit: 1,
//       where: '$idColumn = ?',
//       whereArgs: [id],
//     );
//     if (results.isEmpty) {
//       throw CouldNotFoundNoteException();
//     }
//     return DatabaseNote.fromRow(results.first);
//   }

//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(noteTable);
//     return results.map((e) => DatabaseNote.fromRow(e));
//   }

//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     final db = _getDatabaseOrThrow();

//     await getNote(id: note.id);

//     final updateCount = await db.update(noteTable, {
//       textColumn: text,
//       isSyncedWithCloudColumn: 0,
//     });
//     if (updateCount == 0) {
//       throw CouldNotFoundNoteException();
//     }

//     return await getNote(id: note.id);
//   }

// // Database

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpened();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpened();
//     }
//     await db.close();
//     _db = null;
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }

//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       await db.execute(createUserTable);
//       await db.execute(createNoteTable);
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentDirectoryException();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, id = $id, email = $email';

//   @override
//   bool operator ==(covariant DatabaseUser other) {
//     return id == other.id;
//   }

//   @override
//   int get hashCode => id.hashCode ^ email.hashCode;
// }

// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   const DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });

//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[emailColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Note, id = $id, userId = $userId, text = $text, isSyncedWithCloud = $isSyncedWithCloud';

//   @override
//   bool operator ==(covariant DatabaseNote other) {
//     return id == other.id;
//   }

//   @override
//   int get hashCode => id.hashCode ^ userId.hashCode ^ text.hashCode;
// }

// const dbName = 'notes.db';
// const userTable = 'user';
// const noteTable = 'note';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userId = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const createNoteTable = '''CREATE TABLE "notes" (
//         "id"	INTEGER NOT NULL,
//         "user_id"	INTEGER NOT NULL,
//         "text"	BLOB,
//         "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//         PRIMARY KEY("id" AUTOINCREMENT),
//         FOREIGN KEY("user_id") REFERENCES "user"("id")
//       )''';
// const createUserTable = '''REATE TABLE IF NOT EXISTS "user" (
//           "id"	INTEGER NOT NULL,
//           "email"	TEXT NOT NULL UNIQUE,
//           PRIMARY KEY("id" AUTOINCREMENT)
//         )''';
