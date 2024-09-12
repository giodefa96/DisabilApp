import 'package:flutter/foundation.dart';

@immutable
class CloudStorageExceptions implements Exception {
  final String message;
  const CloudStorageExceptions({required this.message});

  @override
  String toString() {
    return 'CloudStorageExceptions: $message';
  }
}

class CloudNotCreateNoteException extends CloudStorageExceptions {
  const CloudNotCreateNoteException({required super.message});
}

class CloudNotGetAllNotesException extends CloudStorageExceptions {
  const CloudNotGetAllNotesException({required super.message});
}

class CloudNotUpdateNoteException extends CloudStorageExceptions {
  const CloudNotUpdateNoteException({required super.message});
}

class CloudNotDeleteNoteException extends CloudStorageExceptions {
  const CloudNotDeleteNoteException({required super.message});
}
