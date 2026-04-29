# Strukku 📄

> **Foto struk, simpan tenang.**

Aplikasi Flutter cross-platform (Android & iOS) untuk memindai, menyimpan, dan melacak struk belanja menggunakan OCR on-device. 100% lokal, tidak membutuhkan akun atau koneksi internet.

---

## Tech Stack

| Layer | Package |
|-------|---------|
| Framework | Flutter 3.22+ (Dart 3.4+) |
| OCR | `google_mlkit_text_recognition` v2 |
| Image preprocessing | `image` package |
| Database | `drift` (SQLite wrapper) |
| Notifications | `flutter_local_notifications` |
| Export | `pdf` + `excel` |
| State management | `flutter_riverpod` |
| Navigation | `go_router` |
| Charts | `fl_chart` |
| Preferences | `shared_preferences` |

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.22 installed and in PATH
- Android Studio with Android SDK 21+ (for Android)
- Xcode 15+ (for iOS, macOS only)

### Setup

```bash
# 1. Install Flutter if not installed
# https://docs.flutter.dev/get-started/install

# 2. Install packages
flutter pub get

# 3. Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# 4. Run on device/emulator
flutter run

# 5. Build APK
flutter build apk --release
```

---

## Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # GoRouter + MaterialApp
├── core/
│   ├── theme/                   # Colors, typography, ThemeData
│   ├── database/                # Drift tables, DAOs, AppDatabase
│   ├── services/                # OCR, notifications, export, prefs
│   ├── models/                  # Domain models
│   └── utils/                   # Formatters, helpers
├── features/
│   ├── onboarding/              # Intro slides + name input (Screen 01)
│   ├── home/                    # Dashboard (Screen 02)
│   ├── camera/                  # Camera + preview (Screens 03-04)
│   ├── ocr_review/              # OCR results editor (Screen 05)
│   ├── receipt_detail/          # Detail view (Screen 06)
│   ├── reminder/                # Set reminder + list (Screens 07+10)
│   ├── history/                 # Receipt history (Screen 08)
│   ├── analytics/               # Charts (Screen 09)
│   ├── export/                  # Export sheet (Screen 11)
│   └── search/                  # Full-screen search (Screen 12)
└── shared/widgets/              # Reusable components
```

---

## Features

- ✅ **OCR on-device** — ML Kit Text Recognition v2, offline, zero cost
- ✅ **12 screens** — Complete UI matching the design spec
- ✅ **SQLite persistence** — Drift ORM, history never auto-deleted
- ✅ **Reminder notifications** — H-7, H-3, H-1 alerts with deep links
- ✅ **Analytics** — Bar charts + donut charts per category
- ✅ **Export** — PDF & Excel with native share sheet
- ✅ **Onboarding** — Single-time name input, no account required
- ✅ **Design system** — Inter font, #1D9E75 accent, all spec tokens

---

## Color Palette

| Token | Hex | Usage |
|-------|-----|-------|
| Background | `#FFFFFF` | Main background |
| Surface | `#F7F7F5` | Cards, inputs |
| Accent | `#1D9E75` | CTA, active elements |
| Warning | `#E84C4C` | Expired, delete |
| Amber | `#F5A623` | Approaching deadlines |
| Text Primary | `#1A1A1A` | Headings, body |
| Text Secondary | `#8A8A8A` | Captions, labels |

---

## Important: Code Generation

After `flutter pub get`, you **must** run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates the `*.g.dart` files for:
- Drift database (`app_database.g.dart`)
- DAOs (`receipts_dao.g.dart`, `reminders_dao.g.dart`)

---

## Screen Map

| # | Screen | Route |
|---|--------|-------|
| 00 | Intro Slides | `/onboarding` |
| 01 | Name Input | `/onboarding/name` |
| 02 | Home Dashboard | `/home` |
| 03 | Camera Scan | `/camera` |
| 04 | Preview & Process | `/camera/preview` |
| 05 | OCR Review | `/camera/review` |
| 06 | Receipt Detail | `/home/detail/:id` |
| 07 | Set Reminder | bottom sheet |
| 08 | History | `/history` |
| 09 | Analytics | `/analytics` |
| 10 | Reminder List | `/reminders` |
| 11 | Export | bottom sheet |
| 12 | Search | `/search` |
