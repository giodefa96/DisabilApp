import 'package:flutter/material.dart';
import 'package:disabilapp/constants/routes.dart';
import 'package:disabilapp/enums/menu_action.dart';
import 'package:disabilapp/models/cloud_note.dart';
import 'package:disabilapp/servicies/auth/auth_service.dart';
import 'package:disabilapp/servicies/auth/bloc/auth_bloc.dart';
import 'package:disabilapp/servicies/auth/bloc/auth_event.dart';
import 'package:disabilapp/servicies/cloud/firebase_cloud_storage.dart';
import 'package:disabilapp/utilities/dialogs/logout_dialog.dart';
import 'package:disabilapp/utilities/logging_util.dart';
import 'package:disabilapp/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    super.initState();
    _noteService = FirebaseCloudStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                if (value == MenuAction.logout) {
                  final shouldLogout = await showLogOutDialog(context);
                  logger.info('Should logout: $shouldLogout');
                  if (shouldLogout) {
                    await _logout(context);
                  }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  )
                ];
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: _noteService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('Waiting for all notes...');
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NoteListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _noteService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }

  Future<void> _logout(BuildContext context) async {
    try {
      context.read<AuthBloc>().add(
            const AuthEventLogOut(),
          );
    } catch (e) {
      logger.severe('Logout failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to log out. Please try again.'),
        ),
      );
    }
  }
}
