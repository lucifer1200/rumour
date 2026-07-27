# Rumour - Anonymous Room-Code Chat App

An open-source Flutter application for anonymous, real-time messaging through room codes. Create or join chat rooms instantly without registration, get a random anonymous identity, and start chatting.

## ✨ Features

- **🔐 Anonymous Chat**: No account required, completely anonymous
- **🎫 Room Codes**: Simple 4-6 character codes to join rooms  
- **👤 Random Identities**: Auto-generated names and avatars from RandomUser.me API
- **⚡ Real-time Messaging**: Live message sync via Firebase Cloud Firestore
- **📱 Offline Support**: View cached messages even without internet
- **🌙 Dark Mode**: Beautiful dark UI with lime green accents
- **✨ Smooth Animations**: Polish transitions and message animations
- **💾 Local Persistence**: Identities persist per device per room

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart 3.9+)
- **State Management**: Flutter Riverpod
- **Backend**: Firebase Cloud Firestore
- **APIs**: RandomUser.me for avatars
- **Local Storage**: SharedPreferences
- **Architecture**: Clean architecture (Services → Repositories → Providers → UI)

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/                             # Data models
│   ├── user.dart
│   ├── room.dart
│   ├── message.dart
│   └── random_user.dart
├── services/                           # Business logic
│   ├── firestore_service.dart
│   ├── random_user_service.dart
│   └── local_storage_service.dart
├── repositories/                       # Data access
│   ├── user_repository.dart
│   ├── room_repository.dart
│   └── message_repository.dart
├── providers/                          # State management (Riverpod)
│   ├── services_provider.dart
│   ├── repository_provider.dart
│   ├── app_state_provider.dart
│   └── message_provider.dart
├── screens/                            # UI Screens
│   ├── splash_screen.dart
│   ├── join_room_screen.dart
│   └── chat_screen.dart
├── widgets/                            # Reusable widgets
│   ├── message_bubble.dart
│   ├── date_separator.dart
│   ├── room_header.dart
│   ├── message_input.dart
│   └── loading_indicator.dart
├── theme/                              # Design system
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   └── app_theme.dart
├── constants/
│   └── app_constants.dart
└── firebase_options.dart               # Firebase config
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9+
- Dart 3.9+
- Firebase account
- Android SDK (for APK builds)

### Setup Instructions

#### 1. Clone Repository

```bash
git clone https://github.com/yourusername/rumour.git
cd rumour
```

#### 2. Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project named "rumour"
3. Enable Cloud Firestore (Production mode, asia-south1 region recommended)
4. Update Firestore Security Rules:
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /rooms/{roomId} {
      allow read, write: if true;
    }
    match /messages/{roomId}/messages/{messageId} {
      allow read, write: if true;
    }
    match /userIdentities/{docId} {
      allow read, write: if true;
    }
  }
}
```

#### 3. Configure Firebase for Flutter

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

#### 4. Install Dependencies

```bash
flutter pub get
```

#### 5. Run

```bash
flutter run
```

## 🗄️ Firestore Data Structure

### `rooms` Collection
```json
{
  "code": "ABC123",
  "createdAt": "server_timestamp",
  "memberCount": 5,
  "lastMessage": "Hello everyone!"
}
```

### `messages/{roomId}/messages` Subcollection
```json
{
  "userId": "uuid",
  "userName": "Brave Badger",
  "userAvatar": "url",
  "text": "Hello everyone!",
  "timestamp": "server_timestamp",
  "hidden": false
}
```

### `userIdentities` Collection
```json
{
  "roomId": "doc-id",
  "deviceId": "device-id",
  "userId": "uuid",
  "name": "Brave Badger",
  "avatar": "url",
  "createdAt": "timestamp",
  "lastAccessed": "timestamp"
}
```

## 🏗️ Architecture

**Layer Diagram:**
```
UI Layer (Screens & Widgets)
    ↓ Riverpod Providers
State Management
    ↓
Repositories (Data Access)
    ↓
Services (Business Logic)
    ↓
Firebase, APIs, SharedPreferences
```

**Key Patterns:**
- **Riverpod**: Reactive state management
- **Repository Pattern**: Data access abstraction
- **Service Layer**: Encapsulated business logic
- **Provider Dependencies**: Hierarchical and testable

## 📲 Building Release APK

```bash
# Generate signing key (first time)
keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias rumour

# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-app/release/app-release.apk
```

## 📋 Testing Checklist

- [ ] Create new room with generated identity
- [ ] Join existing room with code
- [ ] Send and receive messages in real-time
- [ ] Date separators show correctly
- [ ] Offline mode shows cached messages
- [ ] Reconnect syncs messages
- [ ] Long messages wrap properly
- [ ] Dark mode colors are accessible
- [ ] High message volume doesn't crash

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Firebase not connecting | Check `firebase_options.dart`, verify Firestore rules |
| Messages not appearing | Verify room ID, check Firestore console |
| Random user API failing | Check internet, API is cached for 1hr |
| App crashes on startup | Run `flutter pub get` and `flutter doctor` |

## 🔐 Security Notes

⚠️ **This app uses anonymous access.** For production:
- Implement Firebase Authentication
- Add message encryption
- Set rate limiting
- Enable moderation

## 🗺️ Future Roadmap

- [ ] Push notifications
- [ ] Typing indicators
- [ ] Message reactions (emoji)
- [ ] Message search
- [ ] Room history
- [ ] Direct messages
- [ ] Image/media sharing
- [ ] End-to-end encryption

## 📄 License

MIT License - See LICENSE file

## 🎥 Demo Video

[Link to demo video will be added]

---

**Built with ❤️ using Flutter**
