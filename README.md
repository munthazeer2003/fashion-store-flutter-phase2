# 👗 MFashion Store — Flutter & Firebase

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)
![GitHub stars](https://img.shields.io/github/stars/munthazeer2003/fashion-store-flutter-phase2)
![GitHub forks](https://img.shields.io/github/forks/munthazeer2003/fashion-store-flutter-phase2)
![GitHub issues](https://img.shields.io/github/issues/munthazeer2003/fashion-store-flutter-phase2)
![Last commit](https://img.shields.io/github/last-commit/munthazeer2003/fashion-store-flutter-phase2)

Full-stack fashion e-commerce mobile app.

## Screenshots

See /assets/images/

## Features

- ✅ Firebase Authentication (Register/Login/Logout/Forgot Password)
- ✅ Product browsing by category (Men, Women, Kids, Shoes)
- ✅ Wishlist functionality
- ✅ Shopping Cart with Firestore persistence
- ✅ Checkout with delivery address
- ✅ Order placement and Order History
- ✅ User Profile (View & Edit)
- ✅ Onboarding screen
- ✅ MVVM Architecture
- ✅ Responsive UI with custom widgets

## Tech Stack

| Technology | Purpose |
| --- | --- |
| Flutter 3.x | Cross-platform UI |
| Firebase Auth | Authentication |
| Cloud Firestore | Database |
| Firebase Storage | Image storage |
| MVVM Pattern | Architecture |
| Provider | State management |

## Project Structure

```text
lib/
├─ core/
├─ data/
├─ models/
├─ screens/
├─ services/
├─ view_models/
├─ firebase_options.dart
└─ main.dart
```

## Firebase Setup Instructions

1. Create Firebase project at console.firebase.google.com
2. Add Android app with package: com.example.fashion_store_app
3. Download google-services.json and place it in android/app/
4. Enable Email/Password Authentication
5. Create Firestore Database
6. Add Firestore security rules from firestore.rules

## How to Run

```bash
git clone https://github.com/munthazeer2003/fashion-store-flutter-phase2.git
cd fashion-store-flutter-phase2
flutter pub get
flutter run
```

## APK Download

Download the latest APK from GitHub Releases:
https://github.com/munthazeer2003/fashion-store-flutter-phase2/releases

## 🎬 Video Demonstration

[![MFashion Store - Flutter & Firebase Demo](https://img.youtube.com/vi/IDdQMxkb5GI/maxresdefault.jpg)](https://youtu.be/IDdQMxkb5GI?si=SdgtjDi86-sP_kX0)

▶️ **[Watch Full Demo on YouTube](https://youtu.be/IDdQMxkb5GI?si=SdgtjDi86-sP_kX0)**

| Timestamp | Feature Demonstrated |
|-----------|---------------------|
| 00:00 | Introduction & Student Info |
| 00:30 | Splash & Onboarding Screen |
| 01:00 | User Registration (Firebase Auth) |
| 01:30 | User Login & Logout |
| 02:00 | Home Screen & Categories |
| 02:30 | Product Browsing (Men, Women, Kids, Shoes) |
| 03:00 | Product Detail & Add to Cart |
| 03:30 | Wishlist Feature |
| 04:00 | Shopping Cart & Checkout |
| 04:30 | Order Placement & Order History |
| 05:00 | User Profile View & Edit |
| 05:30 | Firebase Integration Demo |

## 📚 Documentation

| Document | Link |
|----------|------|
| Firebase Setup | [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md) |
| Architecture Guide | [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) |
| Screenshots | [docs/SCREENSHOTS.md](docs/SCREENSHOTS.md) |
| Changelog | [CHANGELOG.md](CHANGELOG.md) |
| Contributing | [CONTRIBUTING.md](CONTRIBUTING.md) |

## Academic Info

| Field | Detail |
| --- | --- |
| Module | CIT211 – Mobile Software Development |
| University | SLTC Research University |
| Student | Mohamed Almunthazeer Raheem |
| Student ID | 23DA2-1148 |
| Phase | Phase 2 – Full Application |

## License

MIT

Built with ❤️ using Flutter & Firebase
