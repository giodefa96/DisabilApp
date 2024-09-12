// import 'package:mynotes/utilities/exceptions/crud_exceptions.dart';
// import 'package:mynotes/models/database_note.dart';
// import 'package:mynotes/repositories/interfaces/crud_repository_interface.dart';
// import 'package:sqflite/sqflite.dart';

// class NoteRepository implements CrudOperations {
//   final Database db;

//   NoteRepository({required this.db});

//   @override
//   Future<DatabaseNote> create(Map<String, dynamic> data) async {
//     final id = await db.insert(noteTable, data);
//     return DatabaseNote(
//       id: id,
//       userId: data[userIdcolumn],
//       text: data[textColumn],
//       isSyncedWithCloud: data[isSyncedWithCloudColumn] == 1,
//     );
//   }

//   @override
//   Future<void> delete(dynamic id) async {
//     final deleteCount = await db.delete(
//       noteTable,
//       where: '$idColumn = ?',
//       whereArgs: [id],
//     );
//     if (deleteCount == 0) {
//       throw CouldNotDeleteNoteException();
//     }
//   }

//   @override
//   Future<DatabaseNote> read(dynamic id) async {
//     final results = await db.query(
//       noteTable,
//       where: '$idColumn = ?',
//       whereArgs: [id],
//     );
//     if (results.isEmpty) {
//       throw CouldNotFoundNoteException();
//     }
//     return DatabaseNote.fromRow(results.first);
//   }

//   @override
//   Future<List<DatabaseNote>> readAll() async {
//     final results = await db.query(noteTable);
//     return results.map((e) => DatabaseNote.fromRow(e)).toList();
//   }

//   @override
//   Future<DatabaseNote> update(dynamic note) async {
//     if (note is! DatabaseNote) {
//       throw ArgumentError('Expected note to be of type DatabaseNote');
//     }
//     final DatabaseNote returnNote = note;
//     await db.update(
//       noteTable,
//       {
//         textColumn: note.text,
//         isSyncedWithCloudColumn: note.isSyncedWithCloud ? 1 : 0,
//       },
//       where: '$idColumn = ?',
//       whereArgs: [note.id],
//     );
//     return returnNote;
//   }

//   @override
//   Future<int> deleteAll() async {
//     return await db.delete(noteTable);
//   }
// }
