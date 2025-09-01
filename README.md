# Voice Shopping Assistant

A complete voice-enabled shopping application with Flutter frontend and Spring Boot backend, featuring AI-powered recommendations and intelligent voice command processing.

## Features Implemented

1. **App Shell** + Bottom navigation with 4 tabs
2. **Shopping List Screen** (Main Page) - Manage shopping lists with voice commands
3. **Search & Item Lookup Screen** - Search for products
4. **History Screen** - View purchase history and analytics
5. **Settings Screen** - App preferences and theme management
6. **Shared Lists Screen** - Share shopping lists with others
7. **User Profile Screen** - User account management
8. **UI Components** - Voice input widget, item cards, product cards, suggestions

## Tech Stack Used

- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **speech_to_text**: Voice recognition (local device)
- **http**: REST API communication
- **permission_handler**: Microphone permissions
- **shared_preferences**: Local storage for theme preference

## Deployment

- **Frontend**: Hosted on [Netlify](https://spontaneous-sherbet-a72ea7.netlify.app/)

## Project Structure

```
lib/
├── main.dart                    # App entry point with dark mode support
├── models/
├── services/
│   ├── api_service.dart         # Backend API communication
│   ├── speech_service.dart      # Speech-to-text functionality
│   ├── theme_service.dart       # Theme preference management
│   └── user_service.dart        # User data management
├── screens/
│   ├── splash_screen.dart       # Initial loading screen
│   ├── main_navigation.dart     # Bottom navigation container
│   ├── shopping_list_screen.dart # Main shopping list view
│   ├── search_screen.dart       # Product search view
│   ├── history_screen.dart      # Purchase history and analytics
│   ├── settings_screen.dart     # App settings and preferences
│   ├── shared_lists_screen.dart # Shared shopping lists
│   ├── user_profile_screen.dart # User profile management
├── utils/
├── widgets/
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
android/
ios/
web/
linux/
macos/
windows/
.netlify/
netlify.toml
```

## Prerequisites

- **Flutter SDK 3.x** - Install from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Git** - For cloning the repository

## Setup Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/Anshadi/Project_Repo.git
cd Project_Repo
```

### Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

### Step 3: Run the Application

```bash
flutter run
```

Choose your target platform:
- `1` for Android emulator
- `2` for iOS simulator
- `3` for Chrome (web)

### Step 4: Configuration

1. **Update API endpoint** (if needed)
   Edit `lib/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'http://localhost:8082/api';
   ```

2. **Enable microphone permissions**
   - Android: Already configured in `android/app/src/main/AndroidManifest.xml`
   - iOS: Already configured in `ios/Runner/Info.plist`

## Permissions Required

### Android (`android/app/src/main/AndroidManifest.xml`):
- `RECORD_AUDIO`: For voice recognition
- `INTERNET`: For API communication

### iOS (`ios/Runner/Info.plist`):
- `NSMicrophoneUsageDescription`: For voice recognition
- `NSSpeechRecognitionUsageDescription`: For speech recognition

## Recently Added Features

### Dark Mode Theme
- **Complete dark theme implementation** with automatic theme switching
- **Persistent theme preference** using SharedPreferences
- **Adaptive colors** that work well in both light and dark modes
- **Theme toggle** available in Settings screen
- **System theme detection** capability

### Shopping History Visualization
- **Complete purchase history tracking** with detailed analytics
- **Interactive charts and statistics**:
  - Total items purchased and quantities
  - Total amount spent and average per item
  - Category breakdown with visual charts
  - Monthly purchase trends
- **Filtering options** (This Week, This Month, Last 3 Months)
- **Detailed item history** with store information and prices
- **Export functionality** for data backup
- **Two-tab interface**: History timeline and Analytics dashboard

### Enhanced Navigation
- **4-tab bottom navigation**: Shopping List, Search, History, Settings
- **Settings screen** with comprehensive preferences
- **Theme management** and app customization options

### Additional Features
- **Shared Lists**: Share shopping lists with other users
- **User Profile**: Manage user account and preferences
- **Voice Commands**: Advanced voice recognition for adding items, searching, etc.

## Required Backend Endpoints

The frontend expects the following REST API endpoints to be implemented in your Spring Boot backend:

- `GET /api/health` - Health check
- `GET /api/products/search?q={query}` - Search products
- `POST /api/lists` - Create shopping list
- `GET /api/lists` - Get user's shopping lists
- `PUT /api/lists/{id}` - Update shopping list
- `DELETE /api/lists/{id}` - Delete shopping list
- `POST /api/lists/{id}/items` - Add item to list
- `PUT /api/lists/{id}/items/{itemId}` - Update item
- `DELETE /api/lists/{id}/items/{itemId}` - Delete item
- `GET /api/history` - Get purchase history
- `POST /api/history` - Add purchase to history
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `POST /api/voice/process` - Process voice commands
- `GET /api/recommendations` - Get product recommendations
