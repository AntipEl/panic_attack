# Breathing Timer: Box & 4-7-8
An app that provides guided breathing exercises to quickly reduce panic attacks, anxiety, and acute stress in real time.

## Platform

Android only (Flutter-based application)

## Preview

<p align="center">
  <img src="https://raw.githubusercontent.com/AntipEl/antipel.github.io/refs/heads/main/screen_panic-attack/breathing_circle.png" width="150"/>
  <img src="https://raw.githubusercontent.com/AntipEl/antipel.github.io/refs/heads/main/screen_panic-attack/breathing_circle_light.png" width="150"/>
  <img src="https://raw.githubusercontent.com/AntipEl/antipel.github.io/refs/heads/main/screen_panic-attack/pattren_creating.png" width="150"/>
  <img src="https://raw.githubusercontent.com/AntipEl/antipel.github.io/refs/heads/main/screen_panic-attack/settings.png" width="150"/>
</p>

## Tech Stack

- Flutter — cross-platform UI framework for building mobile application
- Dart — main programming language

- State Management (custom controllers) — handles breathing sessions, UI states, and app logic
- Local Storage (custom repositories) — saves breathing patterns and user settings

- Firebase Analytics — tracks user engagement and session behavior
- Appodeal SDK — ad monetization and revenue management

- Multidex — support for large-scale Flutter application

- Android Native Configuration — permissions handling (Internet, network state, advertising ID)

## Features

- Guided breathing sessions
- Real-time breathing animation synced with timer
- Custom breathing pattern creation
- Save and reuse breathing techniques
- Dark mode support
- Ad-supported free experience with optional removal via purchase

## Architecture
- UI layer: screens and widgets
- State layer: controllers handling breathing sessions and UI state
- Service layer: ads, analytics, storage

## Setup

- Install Flutter SDK (>= 3.x)
- Install Dart SDK
- Connect Android device or emulator

Then run:

flutter pub get
flutter run

## Build

Debug APK:
flutter build apk --debug

Release APK:
flutter build apk --release

Or App Bundle (for Play Store):
flutter build appbundle

## Download

Latest release APK:
👉 https://github.com/AntipEl/app/releases

## Requirements

- Flutter SDK 3.x or higher
- Dart SDK
- Android Studio or VS Code
- Android device or emulator (API 21+)
- Internet connection (for ads and analytics)

## Future Improvements

- Add guided voice instructions for breathing sessions
- Introduce advanced analytics for breathing patterns
- Add Apple Watch / Wear OS support
- Improve animation smoothness for low-end devices
- Add more breathing techniques library
