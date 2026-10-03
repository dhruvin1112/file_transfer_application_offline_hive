<div align="center">

# ⚡ DropShare (File Transfer Application)

**Ultra-fast, zero-cloud peer-to-peer file sharing and local storage optimization suite.**  
*Built with Flutter, Raw TCP Sockets, Hive NoSQL, and Native Android Method Channels.*

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State%20Management-GetX%204.7.2-8A2BE2)](https://pub.dev/packages/get)
[![Local Database](https://img.shields.io/badge/Database-Hive%20NoSQL-FFB300?logo=hive&logoColor=black)](https://pub.dev/packages/hive)
[![Integrity](https://img.shields.io/badge/Security-SHA--256%20Checksums-success)](https://pub.dev/packages/crypto)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Cross--Platform-brightgreen)](https://flutter.dev/multi-platform)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

[Key Features](#-key-features) •
[How It Works](#-how-it-works) •
[Architecture & Tech Stack](#-architecture--tech-stack) •
[Project Structure](#-project-structure) •
[Getting Started](#-getting-started) •
[Permissions](#-platform-permissions) •
[Usage Guide](#-usage-guide) •
[Deduplication Engine](#-intelligent-duplicate-cleaner)

---

</div>

## 📖 Overview

**DropShare** is an offline-first, high-throughput Peer-to-Peer (P2P) file transfer application designed to transfer files directly between devices at physical Wi-Fi hardware speeds without relying on internet access, mobile data, or third-party cloud servers.

By coupling raw asynchronous **TCP/IP socket streams** with zero-configuration **UDP broadcast beacons** and **dynamic QR-code handshakes**, DropShare delivers a secure, near-instant sharing experience for large videos, high-resolution photo libraries, lossless audio, documents, APK applications, and full contact address books.

In addition to high-speed transmission, DropShare features an integrated **Cryptographic Duplicate Cleaner** that uses a two-tier size-and-SHA-256 pipeline to scan and free up redundant local storage.

---

## ✨ Key Features

### 🚀 High-Throughput Socket Streaming
- **Raw TCP Socket Channels**: Bypasses HTTP/WebSockets overhead by establishing direct TCP `ServerSocket` and `Socket` streams (default port `8888`).
- **Chunked Data Pipeline**: Streams data in balanced 64 KB buffers (`AppConstants.defaultChunkSize = 65536`) with active sink backpressure management (`await socket.flush()`), ensuring steady memory consumption even during gigabyte-scale transfers.
- **Zero Internet Requirement**: Operates entirely over Local Area Networks (LAN) or direct Mobile Hotspots without external server hops.

### 📡 Zero-Configuration Dual Discovery
- **UDP Broadcast Radar**: Pings and listens on UDP port `8889` across subnet broadcast addresses (`255.255.255.255`) for automatic radar-like discovery of nearby devices.
- **Encrypted QR Code Pairing**: When router AP isolation or network firewalls block UDP broadcast packets, the receiver generates a secure QR code containing session tokens and IP parameters. The sender scans via `MobileScanner` to establish a direct point-to-point connection instantly.

### 🔒 Cryptographic Data Integrity
- **SHA-256 Checksum Validation**: Computes streaming hashes on transmitted files using Dart's cryptographic engine to guarantee zero data truncation or transmission corruption.

### 📁 Multi-Category Payload Support
- **Photos & Images**: JPG, PNG, GIF, WebP, HEIC, SVG, BMP.
- **High-Definition Video**: MP4, MKV, MOV, AVI, FLV, WebM, 3GP.
- **Lossless & Compressed Audio**: MP3, WAV, AAC, M4A, FLAC, OGG, WMA.
- **Documents & Archives**: PDF, DOCX, XLSX, PPTX, TXT, CSV, ZIP, RAR.
- **Application Packages**: Android APKs, IPAs.
- **Full Address Book Migration**: One-click extraction and compilation of device contacts into standard **vCard (.vcf)** files.

### 🧹 Intelligent Duplicate File Cleaner
- **Two-Tier Deduplication Engine**:
  1. *Quick Bucket Filter*: Groups files by exact byte size to eliminate 90% of non-matching files instantly.
  2. *Cryptographic Hash Match*: Runs SHA-256 content hashes on matching candidates to accurately identify identical files regardless of file names.
- Inspect and remove duplicate files safely to reclaim valuable device storage.

### 🗄️ Offline Storage & Session Recovery (Hive NoSQL)
- **High-Performance Local Persistence**: Employs lightweight, box-based Hive NoSQL storage (`hive_flutter`) for zero-latency indexing.
- **Transfer Logs & Telemetry**: Automatically records every transfer session, device endpoints, file count, byte volumes, and timestamps.
- **Aggregate Statistics**: Tracks cumulative data transferred across the device's lifetime.

### 📱 Native Android Deep Integration
- Custom Kotlin Method Channel (`com.example.file_transfer_appplication/native_channel`) exposing:
  - Precise battery percentage telemetry.
  - Native filesystem disk space (`StatFs` available & total storage).
  - Accurate active Wi-Fi IP address resolution.
  - One-tap intent triggers to native Wi-Fi settings and application permission panels.

### 🎨 Modern Cyber-Indigo Interface
- Responsive, edge-to-edge UI supporting both **Cosmic Dark** and **Clean Light** themes.
- Animated radar scanning pulse widgets, real-time speedometers (MB/s), live ETA metrics, and telemetry cards.
- **Non-Intrusive Ad Experience**: Built-in Google Mobile Ads engine featuring an active-transfer safety lock (`setTransferActive`) that strictly suppresses interstitial advertisements during ongoing transfers.

---

## 🔬 How It Works

### Connection & Transfer Lifecycle

```
       [SENDER DEVICE]                                 [RECEIVER DEVICE]
              │                                                │
   1. Select files (Photos/Videos/Docs/Contacts)               │
              │                                                │
              │                                     2. Tap "Receive"
              │                                        Start ServerSocket (:8888)
              │                                        Generate QR (IP + Port + Token)
              │                                                │
   3. Peer Discovery                                           │
      ├─► Method A: Listen for UDP Beacon (:8889) ◄────────────┤
      └─► Method B: Scan Receiver's Pairing QR ────────────────┤
              │                                                │
   4. Connect Socket ─────────────────────────────────────────►│
      (TCP Handshake & Session Validation)                     │
              │                                                │
   5. Chunked Binary Streaming (64 KB Buffers) ───────────────►│ Write to Storage
      (Real-time Speedometer & Progress Broadcast)             │ Sink Flush
              │                                                │
   6. End of File (EOF)                                        │
      Compute SHA-256 Hash ───────────────────────────────────►│ Validate SHA-256
              │                                                │
   7. Save Session into Hive DB                                8. Save Session into Hive DB
```

### Protocol Specifications
| Component | Protocol / Standard | Port / Format | Purpose |
| :--- | :--- | :--- | :--- |
| **Peer Discovery** | UDP Datagram Broadcast | `8889` (`255.255.255.255`) | Zero-configuration local network discovery |
| **Connection Handshake** | Dynamic QR / JSON Payload | UUID v4 Session + Auth Token | Secure peer pairing |
| **Data Stream** | Raw TCP IPv4 Socket | `8888` | High-throughput binary file streaming |
| **Buffer Sizing** | Chunked Byte Stream | 64 KB (`65536` bytes) | Memory efficiency and socket flow control |
| **Verification** | SHA-256 Digest | 256-bit hexadecimal string | Cryptographic byte-level verification |
| **Storage Engine** | Hive NoSQL Box | Binary Key-Value Store | Transfer metadata & session persistence |

---

## 🛠️ Architecture & Tech Stack

DropShare follows **Clean Architecture** combined with the **GetX Pattern**, enforcing separation of concerns between presentation, business logic, domain repositories, and data sources:

```
lib/
 ├── app/         # Application level config (Themes, Routes, Global Bindings)
 ├── core/        # Core utilities, platform services, constants, and network drivers
 ├── data/        # Hive database, entity models, and domain repositories
 ├── modules/     # Feature modules (GetX Views, Controllers, and Bindings)
 └── shared/      # Reusable widgets, visual components, and shared enums
```

### Core Technologies

| Technology | Package / Tool | Version | Role in Project |
| :--- | :--- | :--- | :--- |
| **Framework** | Flutter | `>= 3.12.0` | Cross-platform UI toolkit |
| **Language** | Dart | `^3.12.2` | Core programming language with Null Safety |
| **Native Layer** | Kotlin | `JVM 17` | Android platform method channels & telemetry |
| **Architecture** | GetX | `^4.7.2` | Reactive state management, DI & routing |
| **Persistence** | Hive & Hive Flutter | `^2.2.3` / `^1.1.0` | Fast, lightweight embedded NoSQL database |
| **Preferences** | SharedPreferences | `^2.5.3` | Key-value store for app preferences & flags |
| **File Picker** | file_picker | `^12.3.0` | Cross-platform multi-format file selection |
| **QR System** | qr_flutter & mobile_scanner | `^4.1.0` / `^7.4.1` | QR code generation and live camera scanner |
| **Cryptography** | crypto | `^3.0.7` | SHA-256 calculation for file integrity |
| **Identity** | uuid | `^4.6.0` | Unique transfer session IDs and auth tokens |
| **Device Info** | device_info_plus & network_info_plus | Latest | Device model detection & local IP parsing |
| **Monetization** | google_mobile_ads | `^9.1.0` | Non-intrusive banner & interstitial ads |

---

## 📂 Project Structure

```
file_transfer_appplication/
├── android/                                  # Native Android project configuration
│   ├── app/
│   │   ├── build.gradle.kts                  # Android Gradle config (SDK 37, JVM 17)
│   │   └── src/main/
│   │       ├── AndroidManifest.xml           # Wi-Fi, Storage, Camera permissions
│   │       └── kotlin/com/example/file_transfer_appplication/
│   │           ├── MainActivity.kt               # Method channel registration
│   │           ├── NativeChannelManager.kt       # MethodCallHandler implementation
│   │           ├── AndroidConnectivityService.kt # Native Wi-Fi IP & status service
│   │           └── AndroidDeviceService.kt       # Native battery & StatFs storage info
├── ios/                                      # Native iOS project configuration
├── lib/
│   ├── main.dart                             # Application entry point & service initialization
│   ├── app/
│   │   ├── bindings/
│   │   │   └── initial_binding.dart          # Dependency injection container
│   │   ├── routes/
│   │   │   ├── app_pages.dart                # GetPage route declarations
│   │   │   └── app_routes.dart               # Route constant names
│   │   └── theme/
│   │       ├── app_colors.dart               # Hex palettes, gradients, state accents
│   │       ├── app_text_styles.dart          # Typography tokens
│   │       └── app_theme.dart                # Light & Dark ThemeData configurations
│   ├── core/
│   │   ├── constants/
│   │   │   ├── ad_constants.dart             # AdMob ad unit IDs
│   │   │   ├── app_constants.dart            # Network ports, chunk sizes, timeouts
│   │   │   ├── method_channel_constants.dart # Platform channel method names
│   │   │   └── storage_keys.dart             # Hive box and SharedPreferences keys
│   │   ├── errors/
│   │   │   ├── app_exception.dart            # Custom domain exception hierarchy
│   │   │   └── failure.dart                  # Error handling abstractions
│   │   ├── platform/
│   │   │   ├── android_platform_service.dart # Android-specific platform adapter
│   │   │   ├── ios_platform_service.dart     # iOS-specific platform adapter
│   │   │   └── platform_transfer_service.dart# Abstract platform interface
│   │   ├── services/
│   │   │   ├── ad_service.dart               # AdMob manager with transfer guards
│   │   │   ├── connection_service.dart       # P2P connection lifecycle manager
│   │   │   ├── contact_service.dart          # Contact reader & VCF exporter
│   │   │   ├── device_discovery_service.dart # UDP broadcast discovery engine
│   │   │   ├── duplicate_file_service.dart   # SHA-256 duplicate file detection
│   │   │   ├── file_transfer_service.dart    # High-throughput TCP chunk streamer
│   │   │   ├── local_network_service.dart    # Network interface & IP detector
│   │   │   ├── local_storage_service.dart    # Unified storage facade
│   │   │   ├── native_channel_service.dart   # Dart-side MethodChannel wrapper
│   │   │   ├── permission_service.dart       # Dynamic runtime permission handler
│   │   │   ├── qr_service.dart               # QR pairing payload generator & parser
│   │   │   ├── shared_preferences_service.dart # Local settings & flags helper
│   │   │   └── socket_service.dart           # Raw TCP ServerSocket & client socket
│   │   └── utils/
│   │       ├── app_utils.dart                # Formatting, hashing, helper utilities
│   │       ├── extensions.dart               # Size formatting & string helpers
│   │       └── validators.dart               # IP address and port format validators
│   ├── data/
│   │   ├── local/
│   │   │   ├── hive_boxes.dart               # Hive box instances and lifecycles
│   │   │   └── hive_service.dart             # Hive CRUD operations
│   │   ├── models/
│   │   │   ├── contact_model.dart            # Contact entity model
│   │   │   ├── device_model.dart             # Device info & address model
│   │   │   ├── file_model.dart               # File metadata model
│   │   │   ├── transfer_history_model.dart   # Historical transfer session model
│   │   │   └── transfer_model.dart           # Active transfer session state model
│   │   └── repositories/
│   │       ├── contact_repository.dart       # Contact domain data repository
│   │       ├── device_repository.dart        # Device info & discovery repository
│   │       ├── file_repository.dart           # File picking & duplicate repository
│   │       ├── history_repository.dart        # Transfer logs repository
│   │       └── transfer_repository.dart       # File streaming coordinator repository
│   ├── modules/
│   │   ├── device_connection/                # Discovery radar & target selection
│   │   ├── duplicate_files/                  # Duplicate file scanner & remover UI
│   │   ├── file_selection/                   # Category file & media picker
│   │   ├── home/                             # Telemetry dashboard & quick action hub
│   │   ├── onboarding/                       # First-time introductory slides
│   │   ├── qr/                               # Camera QR code scanner view
│   │   ├── receiver/                         # Receiving radar beacon & pairing view
│   │   ├── sender/                           # Sender staging & device search view
│   │   ├── splash/                           # Splash view & initialization router
│   │   ├── transfer/                         # Live transfer progress & speed view
│   │   └── transfer_history/                 # Transfer history list & detail viewer
│   └── shared/
│       ├── enums/
│       │   ├── file_type.dart                # Media categories enum
│       │   └── transfer_status.dart          # Transfer state machine enum
│       └── widgets/
│           ├── common_button.dart            # Styled gradient button
│           ├── common_dialog.dart            # Universal modal alerts
│           ├── common_loader.dart            # Loading indicators
│           ├── custom_card.dart              # Glassmorphism container
│           └── pulse_radar_widget.dart       # Animated scanning radar
├── test/
│   └── widget_test.dart                      # Unit and serialization tests
├── pubspec.yaml                              # Package dependencies and assets
└── README.md                                 # Documentation
```

---

## 🚀 Getting Started

### Prerequisites

Ensure your development environment meets the following specifications:
- **Flutter SDK**: `>= 3.12.0` ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK**: `^3.12.2`
- **JDK**: Java Development Kit `17` (configured in `JAVA_HOME`)
- **Android Studio / VS Code**: With Flutter and Dart plugins installed
- **Target Device**: Physical Android device (recommended for testing Wi-Fi / Hotspot sockets) or Android Emulator

### Installation & Run

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/dhruvin1112/file_transfer_application_offline_hive.git
   cd file_transfer_application_offline_hive
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Project Health & Tests**:
   ```bash
   flutter test
   ```

4. **Run on Connected Device**:
   ```bash
   flutter run
   ```

5. **Build Release APK**:
   ```bash
   flutter build apk --release
   ```
   The compiled APK will be generated at:  
   `build/app/outputs/flutter-apk/app-release.apk`

---

## 🛡️ Platform Permissions

DropShare requests minimal, strict permissions essential for offline network connectivity, QR scanning, and storage access:

### Android (`AndroidManifest.xml`)
```xml
<!-- Wi-Fi & Local Socket Networking -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />

<!-- Storage & Media Access (Android 13+ Granular Permissions Included) -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />

<!-- Camera (QR Code Pairing) -->
<uses-permission android:name="android.permission.CAMERA" />

<!-- Nearby Wi-Fi Devices (Android 13+) -->
<uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES" android:usesPermissionFlags="neverForLocation" />

<!-- Contacts Migration (Optional) -->
<uses-permission android:name="android.permission.READ_CONTACTS" />
```

---

## 📱 Usage Guide

### 📤 Sending Files
1. Connect both devices to the same **Wi-Fi Network** or turn on **Mobile Hotspot** on one device and connect the other.
2. On the sender device, tap **Send Files** from the dashboard.
3. Select your desired files from the categorized tabs:
   - Photos, Videos, Music, Documents, Apps, or Contacts.
4. Tap **Proceed to Pairing**.
5. Choose your receiver from the nearby discovery radar or tap **Scan QR Code** to scan the receiver's screen.
6. The transfer begins immediately with real-time speed and progress monitoring.

### 📥 Receiving Files
1. On the receiver device, tap **Receive Files** from the dashboard.
2. The device starts listening on local TCP port `8888` and displays a dynamic **Pairing QR Code**.
3. Hold the QR code for the sender to scan, or allow nearby UDP radar discovery to detect your device.
4. Incoming files will stream in chunks directly to your device storage, verified with SHA-256 checksums upon completion.

---

## 🧹 Intelligent Duplicate Cleaner

Mobile storage often degrades due to duplicate downloads, shared photos, and repeated document copies. DropShare includes an advanced deduplication tool accessible directly from the home screen:

1. Tap the **Duplicate Cleaner** tool on the home dashboard.
2. Tap **Scan for Duplicates** and select the directory or files you want to analyze.
3. **Detection Algorithm**:
   - **Phase 1 (Size Filter)**: Files are grouped into buckets by exact byte length. Singletons are discarded immediately without expensive disk reads.
   - **Phase 2 (SHA-256 Hashing)**: Files sharing the exact byte size are streamed through SHA-256 cryptographic hashing. If the generated hashes match, they are classified as duplicates.
4. Review duplicate clusters and delete redundant copies with a single tap.

---

## 🔒 Security & Performance Considerations

- **Zero Cloud Footprint**: Data never touches external servers or cloud intermediaries. All packets stay within the local subnet.
- **Backpressure-Aware Sockets**: Sockets use explicit `flush()` calls during chunk dispatching, preventing out-of-memory crashes on resource-constrained devices when transferring large files.
- **Safe Monetization**: Interstitial ads are suppressed when an active transfer is executing (`AdService._isTransferActive`), guaranteeing that advertising SDKs never interrupt high-speed socket streams or consume CPU during data transfer.

---

## 🤝 Contributing

Contributions, feature requests, and bug reports are welcome!

1. Fork the Project.
2. Create your Feature Branch:
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. Commit your Changes:
   ```bash
   git commit -m "Add some AmazingFeature"
   ```
4. Push to the Branch:
   ```bash
   git push origin feature/AmazingFeature
   ```
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the terms described in the repository's [LICENSE](LICENSE) file.

---

<div align="center">
  <sub>Developed with ❤️ using Flutter, Hive, and Raw Sockets.</sub>
</div>
<div align="center">
