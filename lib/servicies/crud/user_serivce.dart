// import 'package:mynotes/db/database_provider.dart';
// import 'package:mynotes/models/database_user.dart';
// import 'package:mynotes/repositories/crud_repositories/user_repository.dart';

// class UserService {
//   final DatabaseProvider databaseProvider;
//   late final UserRepository _userRepository;

//   UserService({required this.databaseProvider}) {
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     final db = await databaseProvider.database;
//     _userRepository = UserRepository(db: db);
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     return await _userRepository.create({'email': email.toLowerCase()});
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     final users = await _userRepository.readAll();
//     return users.firstWhere((user) => user.email == email.toLowerCase());
//   }

//   Future<void> deleteUser({required String email}) async {
//     final user = await getUser(email: email);
//     await _userRepository.delete(user.id);
//   }

//   Future<void> updateUser({
//     required int id,
//     required String email,
//   }) async {
//     final user = DatabaseUser(id: id, email: email.toLowerCase());
//     await _userRepository.update(user);
//   }

//   Future<List<DatabaseUser>> getAllUsers() async {
//     return await _userRepository.readAll();
//   }
// }
