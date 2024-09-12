// import 'package:mynotes/db/database_provider.dart';
// import 'package:mynotes/utilities/exceptions/crud_exceptions.dart';
// import 'package:mynotes/models/database_user.dart';
// import 'package:mynotes/repositories/interfaces/crud_repository_interface.dart';
// import 'package:sqflite/sqflite.dart';

// class UserRepository implements CrudOperations {
//   final Database db;

//   UserRepository({required this.db});

//   @override
//   Future<DatabaseUser> create(Map<String, dynamic> data) async {
//     final id = await db.insert(userTable, data);
//     return DatabaseUser(id: id, email: data[emailColumn]);
//   }

//   @override
//   Future<void> delete(dynamic id) async {
//     final deleteCount = await db.delete(
//       userTable,
//       where: '$idColumn = ?',
//       whereArgs: [id],
//     );
//     if (deleteCount == 0) {
//       throw CouldNotDeleteUserException();
//     }
//   }

//   @override
//   Future<DatabaseUser> read(dynamic id) async {
//     final results = await db.query(
//       userTable,
//       where: '$emailColumn = ?',
//       whereArgs: [id],
//     );
//     if (results.isEmpty) {
//       throw UserDoesNotExistException();
//     }
//     return DatabaseUser.fromRow(results.first);
//   }

//   @override
//   Future<List<DatabaseUser>> readAll() async {
//     final results = await db.query(userTable);
//     return results.map((e) => DatabaseUser.fromRow(e)).toList();
//   }

//   @override
//   Future<DatabaseUser> update(item) {
//     // TODO: implement update
//     throw UnimplementedError();
//   }

//   @override
//   Future<int> deleteAll() async {
//     return await db.delete(userTable);
//   }
// }
