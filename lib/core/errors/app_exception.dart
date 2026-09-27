class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.details});
}

class ConnectionException extends AppException {
  ConnectionException(super.message, {super.code, super.details});
}

class TransferException extends AppException {
  TransferException(super.message, {super.code, super.details});
}

class PermissionException extends AppException {
  PermissionException(super.message, {super.code, super.details});
}

class StorageException extends AppException {
  StorageException(super.message, {super.code, super.details});
}

class ChecksumMismatchException extends TransferException {
  ChecksumMismatchException(String fileName)
      : super('Checksum integrity check failed for file: $fileName',
            code: 'CHECKSUM_MISMATCH');
}
