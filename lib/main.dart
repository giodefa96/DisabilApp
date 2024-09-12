import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:disabilapp/constants/routes.dart';
import 'package:disabilapp/helpers/loading/loading_screen.dart';
import 'package:disabilapp/servicies/auth/bloc/auth_bloc.dart';
import 'package:disabilapp/servicies/auth/bloc/auth_event.dart';
import 'package:disabilapp/servicies/auth/bloc/auth_state.dart';
import 'package:disabilapp/servicies/auth/firebase_auth_provider.dart';
import 'package:disabilapp/utilities/logging_util.dart';
import 'package:disabilapp/views/forgot_password_view.dart';
import 'package:disabilapp/views/login_view.dart';
import 'package:disabilapp/views/notes/create_update_note_view.dart';
import 'package:disabilapp/views/notes/notes_view.dart';
import 'package:disabilapp/views/register_view.dart';
import 'package:disabilapp/views/verified_email_view.dart';
// import 'dart:developer' as developer show log as print;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configureLogging(); // Initialize logging configuration

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NoteView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}
