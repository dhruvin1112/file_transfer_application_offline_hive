abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message, {super.code});
}

class TransferFailure extends Failure {
  const TransferFailure(super.message, {super.code});
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}

class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.code});
}
