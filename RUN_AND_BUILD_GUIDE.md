# 📱 Remindly - Build & Emulator Guide

This guide provides step-by-step instructions for launching **Remindly** on an Android Emulator and building the Android Release APK.

---

## 🛠️ 1. Prerequisites

Ensure you have the following installed:
- **Flutter SDK** (`v3.29.x` or later)
- **Android Studio** with **Android SDK** & **AVD Manager** (Android Virtual Device)
- **Java Development Kit (JDK 17+)**

Verify your environment:
```bash
flutter doctor
```

---

## 📲 2. How to Launch & Run on Android Emulator

### Step 2.1: List Available Emulators
To see all configured Android Virtual Devices (AVDs) on your machine:
```bash
flutter emulators
```

*Example Output:*
```text
4 available emulators:

Id                         • Name                       • Manufacturer • Platform
Pixel_8                    • Pixel 8                    • Google       • android
pixel_7_-_api_35           • Pixel 7 - API 35           • Google       • android
phone_m-dpi_5_4in_-_api_33 • Phone M-DPI 5.4in - API 33 • Generic      • android
```

### Step 2.2: Launch the Emulator
Launch your desired emulator ID (for example `Pixel_8`):
```bash
flutter emulators --launch Pixel_8
```

### Step 2.3: Run the Application
Once the emulator finishes starting up, run the app:
```bash
flutter run -d Pixel_8
```
*(Or simply run `flutter run` and select the running emulator from the prompt)*

---

## 📦 3. How to Generate the Android APK

### Step 3.1: Generate Code (If Modifying Database/Models)
Before building, ensure Drift & Freezed code generators are up to date:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 3.2: Build Universal Release APK
Build the release APK package:
```bash
flutter build apk --release
```
**Output File Location**:
`build/app/outputs/flutter-apk/app-release.apk`

### Step 3.3: Build Split ABIs (Smaller APK size per architecture)
If you want smaller APKs targeted per device architecture (arm64-v8a, armeabi-v7a, x86_64):
```bash
flutter build apk --split-per-abi --release
```
**Output Directory**:
`build/app/outputs/flutter-apk/`

---

## 📥 4. Installing APK directly onto Emulator or Device

### Option A: Via ADB (Android Debug Bridge)
With your emulator running or physical device connected via USB Debugging:
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Option B: Drag and Drop
1. Open your running Android Emulator window.
2. Drag and drop `build/app/outputs/flutter-apk/app-release.apk` directly into the emulator screen.

---

## 🔑 5. App Credentials & Security Features

- **Central Dashboard & Modular Extensibility**:
  - `/` route hosts the top-level app launcher.
  - **Remandly**: Personal Memory Assistant.
  - **Diary**: Private Daily Journal.
- **Diary Security & Lock**:
  - **Salted SHA-256 PIN Hashing**: PIN is never stored in plaintext.
  - **Biometrics**: Fingerprint / Face Unlock supported on physical devices and emulators.
  - **Lock Timeout Options**: Immediately, 1 Minute, or 5 Minutes.
  - **Zero Content Logging**: Diary entries suppress text printing in console logs and debug traces.
  - **Cloud Sync**: Interface ready with *"Cloud Backup: Coming soon"* notification.
- **Remandly Security Lock**:
  - **Default Mobile PIN**: `1234`
  - **Secure Reminders 🔒**: Toggle *"Mark as Secure / Private"* when creating memories to protect sensitive information.
- **Multi-Language Support**:
  - 🇬🇧 English (`en`)
  - 🇮🇳 Hindi (`hi` - हिंदी)
  - 🇮🇳 Tamil (`ta` - தமிழ்)
  - 🇮🇳 Kannada (`kn` - ಕನ್ನಡ)
  - 🇮🇳 Tulu (`tcy` - ತುಳು)
- **Developer Credit**:
  - Developed by **Vijay Sankar S**.

---

## 🌐 6. Useful Commands Summary

| Task | Command |
| :--- | :--- |
| **Check Flutter Setup** | `flutter doctor` |
| **List Emulators** | `flutter emulators` |
| **Start Emulator** | `flutter emulators --launch <EMULATOR_ID>` |
| **Run App on Emulator** | `flutter run -d <EMULATOR_ID>` |
| **Build Release APK** | `flutter build apk --release` |
| **Install APK via ADB** | `adb install build/app/outputs/flutter-apk/app-release.apk` |
| **Run Unit & Widget Tests** | `flutter test` |
| **Run Static Code Analyzer** | `flutter analyze` |
