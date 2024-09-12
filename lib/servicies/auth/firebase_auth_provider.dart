import 'package:firebase_core/firebase_core.dart';
import 'package:disabilapp/firebase_options.dart';
import 'package:disabilapp/servicies/auth/auth_user.dart';
import 'package:disabilapp/servicies/auth/auth_provider.dart';
import 'package:disabilapp/servicies/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseException;

class FirebaseAuthProvider implements AuthProvider {
  void _getErrorMessage(String errorCode) {
    {
      switch (errorCode) {
        case 'user-not-found':
          throw UserNotFoundAuthException();
        case 'wrong-password':
          throw InvalidPasswordAuthException();
        case 'too-many-requests':
          throw TooManyRequestsAuthException();
        case 'invalid-credential':
          throw InvalidCredentialAuthException();
        default:
          throw GenericAuthException();
      }
    }
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedAuthException();
      }
    } on FirebaseException catch (e) {
      _getErrorMessage(e.code);
    } catch (_) {
      throw GenericAuthException();
    }

    throw GenericAuthException(); // Add this line to ensure a non-null value is always returned
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedAuthException();
      }
    } on FirebaseException catch (e) {
      _getErrorMessage(e.code);
    } catch (_) {
      throw GenericAuthException();
    }

    throw GenericAuthException(); // Add this line to ensure a non-null value is always returned
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedAuthException();
    }
  }

  @override
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
