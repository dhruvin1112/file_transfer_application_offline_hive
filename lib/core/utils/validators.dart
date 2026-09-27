class Validators {
  Validators._();

  static bool isValidIpAddress(String ip) {
    final ipv4Pattern = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (!ipv4Pattern.hasMatch(ip)) return false;

    final parts = ip.split('.');
    for (final part in parts) {
      final value = int.tryParse(part);
      if (value == null || value < 0 || value > 255) return false;
    }
    return true;
  }

  static bool isValidPort(int port) {
    return port > 0 && port <= 65535;
  }

  static bool isValidDeviceName(String? name) {
    if (name == null || name.trim().isEmpty) return false;
    return name.trim().length <= 50;
  }

  static bool isValidSessionToken(String? token) {
    if (token == null || token.trim().isEmpty) return false;
    return token.trim().length >= 8;
  }
}
