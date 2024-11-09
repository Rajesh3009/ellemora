# Ellemora - E-Commerce App

A modern, responsive e-commerce mobile application built with Flutter and Riverpod. This app demonstrates clean architecture, state management, and responsive design principles for building scalable Flutter applications.

## Demo


https://github.com/user-attachments/assets/137e401e-6416-47ed-93e1-2c3b8d48e462



## Features

- Browse products from Fake Store API
- View detailed product information
- Shopping cart functionality
- Dark/Light theme with persistence
- Responsive design for all screen sizes:
  - Mobile (2 columns)
  - Tablet (3 columns)
  - Desktop (4 columns)
  - Large Desktop (6 columns)
- Error handling and loading states
- Pull-to-refresh functionality
- Clean and intuitive UI

## Tech Stack

- Flutter SDK (3.5.0 or higher)
- Dart SDK (3.5.3 or higher)
- State Management: Riverpod
- Local Storage: SharedPreferences
- HTTP Client: http
- Backend: Appwrite

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter SDK (3.5.0 or higher)
- Dart SDK (3.5.3 or higher)
- Git
- A suitable IDE (VS Code, Android Studio, or IntelliJ)

## Installation

### 1. Install Flutter

First, install the Flutter SDK by following these steps:

1. Download Flutter from [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. Extract the downloaded file
3. Add Flutter to your PATH
4. Run `flutter doctor` to verify the installation

### 2. Clone the Repository

git clone https://github.com/yourusername/ellemora.git
cd ellemora

### 3. Install Dependencies

flutter pub get

### 4. Configure Appwrite

1. Create a new project in your Appwrite Console
2. Create a new database and collection for the cart items
3. Copy `lib/config/appwrite_config.example.dart` to `lib/config/appwrite_config.dart`
4. Fill in the configuration values:



### 5. Run the App

flutter run


## Building for Production

### Android

flutter build apk --release

The APK file will be located in the `build/app/outputs/flutter-apk/` directory.
