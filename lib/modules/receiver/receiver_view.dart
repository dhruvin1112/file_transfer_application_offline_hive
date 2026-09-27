import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../shared/widgets/common_loader.dart';
import '../../shared/widgets/custom_card.dart';
import '../../shared/widgets/pulse_radar_widget.dart';
import 'receiver_controller.dart';

class ReceiverView extends GetView<ReceiverController> {
  const ReceiverView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Files'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isHosting.value) {
            return const CommonLoader(
              message: 'Initializing local socket receiver...',
            );
          }

          final device = controller.localDevice.value;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                // Network Badge Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.cyan.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        device != null && device.connectionAddress.isNotEmpty
                            ? 'IP: ${device.connectionAddress} : ${device.port}'
                            : 'Listening for connections...',
                        style: AppTextStyles.telemetry.copyWith(
                          color: isDark ? AppColors.cyanLight : AppColors.cyan,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Radar Wave Animated QR Code Container
                PulseRadarWidget(
                  size: 290,
                  pulseColor: AppColors.cyan,
                  rings: 3,
                  centerChild: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan.withValues(alpha: 0.25),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: controller.qrPayloadString.value.isNotEmpty
                        ? QrImageView(
                            data: controller.qrPayloadString.value,
                            version: QrVersions.auto,
                            size: 190.0,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Color(0xFF0F172A),
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Color(0xFF0F172A),
                            ),
                          )
                        : const SizedBox(
                            width: 190,
                            height: 190,
                            child: CommonLoader(),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                // Status Heading
                Text(
                  'Scan to Connect',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Point the sender device camera at this QR code to initiate secure file transfer.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),

                const SizedBox(height: 24),

                // Connection Tips Cards
                CustomCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 18,
                  child: Column(
                    children: [
                      _buildTipRow(
                        icon: Icons.wifi_tethering_rounded,
                        text: 'Connect both devices to the same Wi-Fi network or mobile Hotspot.',
                        isDark: isDark,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(height: 1),
                      ),
                      _buildTipRow(
                        icon: Icons.lock_rounded,
                        text: 'All transfers happen directly and never leave your local network.',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTipRow({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryLight),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
