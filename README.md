# 🧠 Remindly & Diary

Smart personal life-management application featuring a central Dashboard, Personal Memory & Reminder Assistant (**Remindly**), and Private Daily Journal (**Diary**). Built with Flutter using Material 3 design and clean architecture.

Developed by **Vijay Sankar S**.

---

## 🚀 Key Modules & Architecture

1. **Central Dashboard (`/`)**:
   - Modern Material 3 dashboard interface presenting modular tiles.
   - Designed for easy expansion of future personal productivity modules.

2. **Remindly (Personal Memory Assistant)**:
   - Voice-enabled memory assistant with speech-to-text and optional text-to-speech readouts.
   - Secure private memory entries protected by biometric or PIN unlock.

3. **Diary (Private Daily Journal)**:
   - Encrypted daily entries with rich rich-text content and tag classification.
   - Standalone security lock with custom PIN and biometric authentication.
   - Auto-lock timeouts (Immediately, 1 Minute, 5 Minutes).
   - Zero-logging policy ensuring private text is never output to console logs or crash reports.
   - Cloud backup integration placeholder.

---

## 📖 Build & Emulator Instructions

For comprehensive step-by-step documentation on running the app in an Android Emulator or generating release APKs, see:
👉 **[RUN_AND_BUILD_GUIDE.md](file:///c:/Users/Admin/.gemini/antigravity-ide/scratch/remember_this/RUN_AND_BUILD_GUIDE.md)**

---

## ⚡ Quick Start

### 1. Launch Android Emulator
```bash
flutter emulators --launch Pixel_8
```

### 2. Run Application
```bash
flutter run
```

### 3. Build Release APK
```bash
flutter build apk --release
```
**Output APK**: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔒 Security & Key Features
- **App & Module Security Lock**: Biometric Unlock (Fingerprint / Face ID) or Mobile PIN (Default: `1234`).
- **Secure / Private Entries 🔒**: Salted SHA-256 PIN hashing stored safely in encrypted storage.
- **Voice Search & TTS**: Speech-to-text voice search with automated text-to-speech search result readouts.
- **Multi-Language Support**: English, Hindi, Tamil, Kannada, Tulu.
- **Developer Credit**: Developed by Vijay Sankar S.


