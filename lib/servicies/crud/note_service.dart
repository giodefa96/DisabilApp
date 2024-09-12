// import 'package:mynotes/db/database_provider.dart';
// import 'package:mynotes/extensions/list/filter.dart';
// import 'package:mynotes/servicies/stream/note_stream_service.dart';
// import 'package:mynotes/utilities/exceptions/crud_exceptions.dart';
// import 'package:mynotes/models/database_note.dart';
// import 'package:mynotes/models/database_user.dart';
// import 'package:mynotes/repositories/crud_repositories/note_repository.dart';
// import 'package:mynotes/repositories/crud_repositories/user_repository.dart';

// class NoteService {
//   final DatabaseProvider databaseProvider;
//   late final NoteRepository _noteRepository;
//   late final UserRepository _userRepository;
//   final NoteStreamManager _noteStreamManager = NoteStreamManager();

//   DatabaseUser? _user;

//   static final NoteService _shared =
//       NoteService._sharedInstance(databaseProvider: DatabaseProvider());
//   NoteService._sharedInstance({required this.databaseProvider}) {
//     _initialize();
//   }
//   factory NoteService() => _shared;

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//     _noteStreamManager.addNotes(allNotes.toList());
//   }

//   Future<void> _initialize() async {
//     final db =
//         await databaseProvider.database; // Ensure the database is initialized
//     _noteRepository = NoteRepository(db: db);
//     _userRepository = UserRepository(db: db);
//     _noteStreamManager.init();
//     await _cacheNotes(); // Now cache notes
//   }

//   void dispose() {
//     _noteStreamManager.dispose();
//     final db = databaseProvider;
//     db.close();
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await databaseProvider.database;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Stream<List<DatabaseNote>> get allNotes =>
//       _noteStreamManager.allNotes.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });

//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       await _ensureDbIsOpen();
//       final user = await _userRepository.read(email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on UserDoesNotExistException {
//       final createdUser = await _userRepository.create({'email': email});
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<DatabaseNote> createNote({
//     required DatabaseUser owner,
//   }) async {
//     await _ensureDbIsOpen();
//     const String text = '';
//     final note = await _noteRepository.create({
//       'user_id': owner.id,
//       'text': text,
//       'is_synced_with_cloud': 0,
//     });
//     _noteStreamManager.addNote(note);
//     return note;
//   }

//   Future<DatabaseNote> getNoteById(int id) async {
//     await _ensureDbIsOpen();
//     final note = await _noteRepository.read(id);
//     _noteStreamManager.updateNote(note);
//     return note;
//   }

//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final updatedNote = DatabaseNote(
//       id: note.id,
//       userId: note.userId,
//       text: text,
//       isSyncedWithCloud: note.isSyncedWithCloud,
//     );
//     final updateNote = await _noteRepository.update(updatedNote);
//     _noteStreamManager.updateNote(updateNote);
//     return updateNote;
//   }

//   Future<void> deleteNoteById({required int id}) async {
//     await _ensureDbIsOpen();
//     await _noteRepository.delete(id);
//     _noteStreamManager.deleteNoteById(id);
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final deletedCount = await _noteRepository.deleteAll();
//     _noteStreamManager.clearNotes();
//     return deletedCount;
//   }

//   Future<List<DatabaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//     return await _noteRepository.readAll();
//   }

//   Future<DatabaseUser> getUser({required String email}) {
//     try {
//       return _userRepository.read(email);
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
