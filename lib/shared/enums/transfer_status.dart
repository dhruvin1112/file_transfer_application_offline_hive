enum TransferStatus {
  pending,
  connecting,
  connected,
  preparing,
  transferring,
  paused,
  completed,
  failed,
  cancelled;

  bool get isTerminal =>
      this == TransferStatus.completed ||
      this == TransferStatus.failed ||
      this == TransferStatus.cancelled;

  bool get isActive =>
      this == TransferStatus.connecting ||
      this == TransferStatus.connected ||
      this == TransferStatus.preparing ||
      this == TransferStatus.transferring;

  String get displayName {
    switch (this) {
      case TransferStatus.pending:
        return 'Pending';
      case TransferStatus.connecting:
        return 'Connecting...';
      case TransferStatus.connected:
        return 'Connected';
      case TransferStatus.preparing:
        return 'Preparing Transfer...';
      case TransferStatus.transferring:
        return 'Transferring...';
      case TransferStatus.paused:
        return 'Paused';
      case TransferStatus.completed:
        return 'Completed';
      case TransferStatus.failed:
        return 'Failed';
      case TransferStatus.cancelled:
        return 'Cancelled';
    }
  }
}
