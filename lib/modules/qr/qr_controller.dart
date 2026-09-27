import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../app/routes/app_routes.dart';
import '../../core/services/connection_service.dart';
import '../../core/services/qr_service.dart';
import '../../data/models/file_model.dart';

class QrController extends GetxController {
  final QrService qrService;
  final ConnectionService connectionService;

  QrController({
    required this.qrService,
    required this.connectionService,
  });

  final MobileScannerController scannerController = MobileScannerController();
  final RxBool isProcessing = false.obs;
  List<FileModel> pendingFiles = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['files'] != null) {
      pendingFiles = List<FileModel>.from(args['files'] as List);
    }
  }

  void onDetect(BarcodeCapture capture) async {
    if (isProcessing.value) return;

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    isProcessing.value = true;
    try {
      final payload = qrService.parseScannedData(rawValue);
      await connectionService.connectWithQrPayload(payload);

      Get.offNamed(
        AppRoutes.transfer,
        arguments: {
          'targetDevice': payload.device,
          'files': pendingFiles,
          'isSender': true,
        },
      );
    } catch (e) {
      Get.snackbar('Connection Failed', e.toString());
      isProcessing.value = false;
    }
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
