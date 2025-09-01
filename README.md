# Voice Shopping Assistant

A complete voice-enabled shopping application with Flutter frontend and Spring Boot backend, featuring AI-powered recommendations and intelligent voice command processing.

## Features Implemented

### 1. App Shell

- **Splash Screen**: Minimal logo + app name with auto-navigation
- **Bottom Navigation**: 2 tabs - Shopping List & Search & Suggestions

### 2. Shopping List Screen (Main Page)

- **Header**: App title "Shopping Assistant" with settings button
- **Voice Input Section**:
  - Floating microphone button with pulse animation
  - Real-time speech recognition display
  - Last recognized command display
  - Usage example chips
- **Shopping List Display**:
  - Card-based item list with category icons
  - Quantity and category badges
  - Swipe left to remove items
  - Tap to edit quantities

### 3. Search & Item Lookup Screen

- **Search Bar**: Text input with voice search capability
- **Voice Search**: Real-time speech-to-text with visual feedback
- **Search Results**: Product cards with details (name, brand, price, category)
- **Add to List**: One-tap addition to shopping list

### 4. UI Components

- **Voice Input Widget**: Animated microphone with status indicators
- **Shopping Item Card**: Dismissible cards with edit functionality
- **Product Card**: Search result display with add button
- **Suggestions Section**: Smart recommendation chips

## Tech Stack Used

- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **speech_to_text**: Voice recognition (local device)
- **http**: REST API communication
- **permission_handler**: Microphone permissions

## Deployment

- **Frontend**: Hosted on [Netlify](https://spontaneous-sherbet-a72ea7.netlify.app/)
- **Backend**: Hosted on [Railway](https://projectrepobackend-production.up.railway.app)

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── shopping_item.dart       # Shopping list item model
│   └── product.dart             # Product search result model
├── services/
│   ├── api_service.dart         # Backend API communication
│   └── speech_service.dart      # Speech-to-text functionality
├── screens/
│   ├── splash_screen.dart       # Initial loading screen
│   ├── main_navigation.dart     # Bottom navigation container
│   ├── shopping_list_screen.dart # Main shopping list view
│   └── search_screen.dart       # Product search view
└── widgets/
    ├── voice_input_widget.dart  # Voice command interface
    ├── shopping_item_card.dart  # Shopping list item display
    ├── product_card.dart        # Search result display
    └── suggestions_section.dart # Recommendation chips
```

## Required Backend Endpoints

The frontend expects the following REST API endpoints to be implemented in your Spring Boot backend:

### Voice/NLP Processing

- `POST /api/voice/process`
  - Input: `{"userId": 123, "query": "add 2 bottles of milk"}`
  - Output: `{"status": "added", "item": "milk", "quantity": 2, "message": "Added 2 bottles of milk"}`

### Shopping List Management

- `GET /api/list/{userId}` - Fetch user's shopping list
- `POST /api/list/add` - Add new item
  - Input: `{"userId": 123, "item": "milk", "quantity": 2}`
- `PUT /api/list/update` - Update item quantity
  - Input: `{"userId": 123, "itemId": "item_id", "quantity": 3}`
- `DELETE /api/list/{userId}/{itemId}` - Remove item

### Recommendations

- `GET /api/recommendations/{userId}`
  - Output: `{"suggestions": ["bread", "eggs", "mangoes"]}`

### Product Search

- `GET /api/search?query=milk&brand=organic&maxPrice=50`
  - Output: Array of products with `id`, `name`, `brand`, `price`, `category`, `description`

### User History (Optional)

- `GET /api/history/{userId}` - Past purchases

### User Preferences (Optional)

- `PUT /api/user/preferences`
  - Input: `{"language": "en", "diet": "vegan"}`

## Configuration

### Backend URL

Update the base URL in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://your-backend-url:8082/api';
```

### User ID

Currently uses a mock user ID (123) for demo purposes. Replace with actual authentication:

```dart
static const int userId = 123; // Replace with actual user authentication
```

## Complete Setup Instructions

### Prerequisites
- **Java 17+** - Download from [Oracle](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://openjdk.org/)
- **Flutter SDK 3.x** - Install from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Maven 3.6+** - Download from [maven.apache.org](https://maven.apache.org/download.cgi)
- **Git** - For cloning the repository
- **MongoDB Atlas account** - Create free account at [mongodb.com](https://www.mongodb.com/atlas)
- **Google Gemini API key** - Get from [Google AI Studio](https://makersuite.google.com/app/apikey)

### Step 1: Clone the Repository
```bash
git clone https://github.com/Anshadi/Project_Repo.git
cd Project_Repo
```

### Step 2: Backend Setup

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Create environment configuration**
   Create a `.env` file in the `backend` directory:
   ```env
   GEMINI_API_KEY=your-gemini-api-key-here
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/voice_shopping
   SERVER_PORT=8082
   GEMINI_API_MODEL=gemini-1.5-flash
   GEMINI_API_MAX_TOKENS=150
   ```

3. **Install dependencies and run**
   ```bash
   mvn clean install
   mvn spring-boot:run
   ```
   
   Or use the PowerShell script (Windows):
   ```powershell
   .\load-env.ps1
   ```

4. **Verify backend is running**
   - Backend will start on `http://localhost:8082`
   - Check health endpoint: `http://localhost:8082/api/health`

### Step 3: Frontend Setup

1. **Navigate to project root**
   ```bash
   cd ..
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
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

3. **Running**:
   ```bash
   flutter run
   ```

## Permissions Required

### Android (`android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (`ios/Runner/Info.plist`):

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice commands</string>
```

## Voice Commands Supported

The frontend sends natural language voice commands to the backend. Examples:

- "Add 2 bottles of milk to my list"
- "Remove bread from list"
- "Add 5 apples"
- "Show my shopping list"
- "Find organic yogurt"

## Demo Mode

When backend is not available, the app shows mock data for demonstration:

- Sample shopping items (Milk, Bread, Eggs)
- Mock product search results
- Placeholder suggestions

## Next Steps for Backend Integration

1. **Set up Spring Boot backend** with the required endpoints
2. **Update API base URL** in `api_service.dart`
3. **Implement authentication** if needed
4. **Add error handling** for network failures
5. **Test voice command processing** with your NLP implementation

## ✅ Recently Added Features

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

## Features for Future Enhancement

- Offline mode with local storage
- Barcode scanning for products
- Smart shopping suggestions based on location
- Multilingual voice support
- Shopping list sharing between users
- Push notifications for shopping reminders

---
