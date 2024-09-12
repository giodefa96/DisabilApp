import 'package:flutter_test/flutter_test.dart';
import 'package:disabilapp/servicies/auth/auth_provider.dart';
import 'package:disabilapp/servicies/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot logout if not initialized', () {
      expect(
          provider.logOut(),
          throwsA(
            const TypeMatcher<NotInitializedException>(),
          ));
    });

    test('Should be able to be initialized', () async {
      await provider.init();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in 1 seconds', () async {
      final stopwatch = Stopwatch()..start();
      await provider.init();
      stopwatch.stop();
      expect(stopwatch.elapsed, const Duration(seconds: 3));
    });

    test('Should be to initialize in less than 2 seconds', () async {
      await provider.init();
      expect(provider.isInitialized, true);
    },
        timeout: const Timeout(
          Duration(seconds: 3),
        ));

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'foobar',
      );
      expect(
        badEmailUser,
        throwsA(
          const TypeMatcher<UserNotFoundException>(),
        ),
      );
      final badPasswordUser = provider.createUser(
        email: 'other@mail.com',
        password: 'foobar',
      );
      expect(
        badPasswordUser,
        throwsA(
          const TypeMatcher<WrongPasswordAuthException>(),
        ),
      );

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('logIn user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to logOut and logIn', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'foo',
        password: 'bart',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, false);
    });
  });
}

class NotInitializedException implements Exception {
  final String message;
  const NotInitializedException(this.message);

  @override
  String toString() {
    return 'NotInitializedException: $message';
  }
}

class UserNotFoundException implements Exception {
  final String message;
  const UserNotFoundException(this.message);

  @override
  String toString() {
    return 'UserNotFoundException: $message';
  }
}

class WrongPasswordAuthException implements Exception {
  final String message;
  const WrongPasswordAuthException(this.message);

  @override
  String toString() {
    return 'WrongPasswordAuthException: $message';
  }
}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw const NotInitializedException('Auth provider not initialized');
    }
    await Future.delayed(const Duration(seconds: 2));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw const NotInitializedException('Auth provider not initialized');
    }
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'foo@bar.com') {
      throw const UserNotFoundException('User not found');
    }
    if (password == 'foobar') {
      throw const WrongPasswordAuthException('Wrong password');
    }
    final userEmail = email;
    final user = AuthUser(
      id: 'my-id', // 'my-id' is a placeholder, it should be a real id
      email: userEmail,
      isEmailVerified: false,
    );
    _user = user;
    return user;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw const NotInitializedException('Auth provider not initialized');
    }
    if (_user == null) {
      throw const UserNotFoundException('User not found');
    }
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw const NotInitializedException('Auth provider not initialized');
    }
    final user = _user;
    if (user == null) {
      throw const UserNotFoundException('User not found');
    }
    final newUser = AuthUser(
      id: 'my_id',
      email: user.email,
      isEmailVerified: true,
    );
    _user = newUser;
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}
