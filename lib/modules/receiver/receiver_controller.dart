import 'package:get/get.dart';
import '../../core/services/connection_service.dart';
import '../../core/services/qr_service.dart';
import '../../data/models/device_model.dart';
import '../../data/repositories/device_repository.dart';

class ReceiverController extends GetxController {
  final DeviceRepository deviceRepository;
  final ConnectionService connectionService;
  final QrService qrService;

  ReceiverController({
    required this.deviceRepository,
    required this.connectionService,
    required this.qrService,
  });

  final RxBool isHosting = false.obs;
  final RxString qrPayloadString = ''.obs;
  final Rx<DeviceModel?> localDevice = Rx<DeviceModel?>(null);
  final Rx<DeviceModel?> connectedSender = Rx<DeviceModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _startHosting();
  }

  Future<void> _startHosting() async {
    isHosting.value = true;
    try {
      final device = await deviceRepository.getLocalDevice();
      localDevice.value = device;

      final boundPort = await connectionService.hostSession(localDevice: device);
      final updatedDevice = device.copyWith(port: boundPort);
      localDevice.value = updatedDevice;

      final qrData = qrService.generatePairingData(localDevice: updatedDevice);
      qrPayloadString.value = qrData;
    } finally {
      isHosting.value = false;
    }
  }

  @override
  void onClose() {
    connectionService.disconnect();
    super.onClose();
  }
}
