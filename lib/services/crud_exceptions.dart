class DatabaseAlreadyOpen implements Exception {}

class DatabaseIsNotOpen implements Exception {}

class UnableToGetDocuments implements Exception {}

class CouldNotDeletePlayer implements Exception {}

class CouldNotUpdatePlayer implements Exception {}

class TetrioPlayerAlreadyExist implements Exception {}

class TetrioPlayerNotExist implements Exception {}

class ConnectionIssue implements Exception {
  const ConnectionIssue(this.code, this.message);

  final int code;
  final String message;

  @override
  String toString() {
    String result = 'ConnectionIssue';
    return '$result: $code $message';
  }
}

