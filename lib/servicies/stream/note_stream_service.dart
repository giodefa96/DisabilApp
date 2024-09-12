import 'dart:async';
import 'package:disabilapp/models/database_note.dart';

class NoteStreamManager {
  late final StreamController<List<DatabaseNote>> _notesStreamController;

  List<DatabaseNote> _notes = [];

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  void addNotes(List<DatabaseNote> notes) {
    _notes = notes;
    _notesStreamController.add(_notes);
  }

  void addNote(DatabaseNote note) {
    _notes.add(note);
    _notesStreamController.add(_notes);
  }

  void updateNote(DatabaseNote updatedNote) {
    _notes.removeWhere((note) => note.id == updatedNote.id);
    _notes.add(updatedNote);
    _notesStreamController.add(_notes);
  }

  void deleteNoteById(int id) {
    _notes.removeWhere((note) => note.id == id);
    _notesStreamController.add(_notes);
  }

  void clearNotes() {
    _notes.clear();
    _notesStreamController.add(_notes);
  }

  void init() {
    _notesStreamController =
        StreamController<List<DatabaseNote>>.broadcast(onListen: () {
      _notesStreamController.sink.add(_notes);
    });
  }

  void dispose() {
    _notesStreamController.close();
  }
}
