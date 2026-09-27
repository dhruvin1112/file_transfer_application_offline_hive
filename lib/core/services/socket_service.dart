import 'dart:async';
import 'dart:io';
import '../constants/app_constants.dart';
import '../errors/app_exception.dart';

class SocketService {
  ServerSocket? _serverSocket;
  Socket? _clientSocket;

  StreamController<Socket>? _incomingSocketController;

  Stream<Socket>? get onClientConnected => _incomingSocketController?.stream;
  bool get isServerRunning => _serverSocket != null;
  bool get isClientConnected => _clientSocket != null;

  /// Starts a local ServerSocket listening on the specified port
  Future<int> startServer({int port = AppConstants.defaultTransferPort}) async {
    try {
      await stopServer();

      _incomingSocketController = StreamController<Socket>.broadcast();

      _serverSocket = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        port,
        shared: true,
      );

      _serverSocket!.listen(
        (socket) {
          _incomingSocketController?.add(socket);
        },
        onError: (error) {
          _incomingSocketController?.addError(
            NetworkException('Server socket stream error: $error'),
          );
        },
        onDone: () {
          stopServer();
        },
      );

      return _serverSocket!.port;
    } catch (e) {
      throw NetworkException('Failed to bind server socket on port $port: $e');
    }
  }

  /// Connects to a remote peer socket
  Future<Socket> connectToPeer({
    required String host,
    required int port,
    Duration timeout = const Duration(seconds: AppConstants.socketTimeoutSeconds),
  }) async {
    try {
      await disconnectClient();

      _clientSocket = await Socket.connect(
        host,
        port,
        timeout: timeout,
      );

      return _clientSocket!;
    } catch (e) {
      throw ConnectionException('Failed to connect to peer at $host:$port: $e');
    }
  }

  /// Closes the server socket and cleans up client connections
  Future<void> stopServer() async {
    await _incomingSocketController?.close();
    _incomingSocketController = null;
    await _serverSocket?.close();
    _serverSocket = null;
  }

  /// Disconnects the active client socket
  Future<void> disconnectClient() async {
    await _clientSocket?.close();
    _clientSocket?.destroy();
    _clientSocket = null;
  }

  /// Disposes all socket resources
  Future<void> dispose() async {
    await stopServer();
    await disconnectClient();
  }
}
