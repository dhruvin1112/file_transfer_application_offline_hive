import 'dart:async';
import '../../data/models/device_model.dart';
import '../errors/app_exception.dart';
import 'qr_service.dart';
import 'socket_service.dart';

enum ConnectionStateStatus {
  idle,
  hosting,
  connecting,
  connected,
  disconnected,
  error
}

class ConnectionService {
  final SocketService _socketService;

  ConnectionService(this._socketService);

  final _connectionStateController =
      StreamController<ConnectionStateStatus>.broadcast();
  Stream<ConnectionStateStatus> get onConnectionStateChanged =>
      _connectionStateController.stream;

  ConnectionStateStatus _currentStatus = ConnectionStateStatus.idle;
  ConnectionStateStatus get currentStatus => _currentStatus;

  DeviceModel? _connectedPeer;
  DeviceModel? get connectedPeer => _connectedPeer;

  String? _activeSessionId;
  String? get activeSessionId => _activeSessionId;

  String? _activeSessionToken;
  String? get activeSessionToken => _activeSessionToken;

  void _setStatus(ConnectionStateStatus status) {
    _currentStatus = status;
    _connectionStateController.add(status);
  }

  /// Hosts a transfer session (e.g. Receiver waiting for Sender or Sender waiting for Receiver)
  Future<int> hostSession({
    required DeviceModel localDevice,
    int port = 8888,
  }) async {
    try {
      _setStatus(ConnectionStateStatus.hosting);
      final boundPort = await _socketService.startServer(port: port);
      return boundPort;
    } catch (e) {
      _setStatus(ConnectionStateStatus.error);
      throw ConnectionException('Failed to host session: $e');
    }
  }

  /// Connects to a remote peer session using parsed QR pairing payload
  Future<void> connectWithQrPayload(QrPairingPayload payload) async {
    try {
      _setStatus(ConnectionStateStatus.connecting);
      _activeSessionId = payload.sessionId;
      _activeSessionToken = payload.token;

      final socket = await _socketService.connectToPeer(
        host: payload.device.connectionAddress,
        port: payload.device.port,
      );

      _connectedPeer = payload.device.copyWith(isConnected: true);
      _setStatus(ConnectionStateStatus.connected);

      // Listen for disconnection
      socket.done.then((_) {
        disconnect();
      });
    } catch (e) {
      _setStatus(ConnectionStateStatus.error);
      throw ConnectionException('Failed to establish connection with peer: $e');
    }
  }

  /// Sets connected peer when an incoming client connects to the server
  void acceptIncomingPeer(DeviceModel peer, String sessionId, String sessionToken) {
    _connectedPeer = peer.copyWith(isConnected: true);
    _activeSessionId = sessionId;
    _activeSessionToken = sessionToken;
    _setStatus(ConnectionStateStatus.connected);
  }

  /// Disconnects active session
  Future<void> disconnect() async {
    _connectedPeer = null;
    _activeSessionId = null;
    _activeSessionToken = null;
    await _socketService.dispose();
    _setStatus(ConnectionStateStatus.disconnected);
  }

  void dispose() {
    _connectionStateController.close();
  }
}
