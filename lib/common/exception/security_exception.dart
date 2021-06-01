abstract class SecurityException implements Exception {}

class WrongSecurityDataException extends SecurityException {
  String message;

  WrongSecurityDataException(String name, [this.message]) {
    message ??= "Field $name = cannot be null";
  }
}

class MultipleSessionException extends SecurityException {
  final String message;

  MultipleSessionException([this.message = "You can't have 2 active sessions"]);
}
