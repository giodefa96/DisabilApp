
// login exception

class UserNotFoundAuthException implements Exception {}

class InvalidPasswordAuthException implements Exception {}

class TooManyRequestsAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}


// register exception

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}


// generic exception

class GenericAuthException implements Exception {}

class UserNotLoggedAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}