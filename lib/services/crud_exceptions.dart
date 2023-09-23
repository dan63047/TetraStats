class DatabaseAlreadyOpen implements Exception {}

class DatabaseIsNotOpen implements Exception {}

class UnableToGetDocuments implements Exception {}

class CouldNotDeletePlayer implements Exception {}

class CouldNotDeleteMatch implements Exception {}

class CouldNotUpdatePlayer implements Exception {}

class TetrioPlayerAlreadyExist implements Exception {}

class TetrioPlayerNotExist implements Exception {}

class TetrioHistoryNotExist implements Exception {}

class TetrioTooManyRequests implements Exception {}

class TetrioForbidden implements Exception {}

class P1nkl0bst3rTooManyRequests implements Exception {}

class P1nkl0bst3rForbidden implements Exception {}

class P1nkl0bst3rInternalProblem implements Exception {}

class TetrioOskwareBridgeProblem implements Exception {}

class TetrioInternalProblem implements Exception {}

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

