# Rumour

An anonymous room-code chat app built with Flutter and Firebase. Users join or create chat rooms using short codes, get assigned a random identity, and chat in real time — no sign-up required.

## Features

- **Anonymous Chat** — No account needed, fully anonymous
- **Room Codes** — Create a room (auto-generates a 4–6 char code) or join by entering one
- **Random Identities** — Each user gets a random name and avatar via RandomUser.me API
- **Identity Persistence** — Your identity sticks per room per device (SharedPreferences)
- **Real-time Messaging** — Live message sync via Firestore snapshot streams
- **Offline Support** — Firestore's built-in offline cache keeps messages available
- **Date Separators** — Messages grouped by date for readability
- **Dark Theme** — Lime green (#B2E844) accent on dark backgrounds

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter (Dart 3.9+) |
| Backend | Firebase Cloud Firestore |
| State Management | Bloc / flutter_bloc 8.x |
| HTTP | `http` package (RandomUser.me API) |
| Local Storage | SharedPreferences |
| IDs | `uuid` package |

## Project Structure

```
lib/
├── main.dart                      # App entry, Firebase init, BlocProviders
├── firebase_options.dart          # Firebase config
│
├── models/
│   ├── user.dart                  # User (id, name, avatar, deviceId)
│   ├── message.dart               # Message (text, timestamp, userId)
│   ├── room.dart                  # Room (code, memberCount, lastMessage)
│   └── random_user.dart           # RandomUser.me API response
│
├── services/
│   ├── firestore_service.dart     # Firestore CRUD operations
│   ├── random_user_service.dart   # RandomUser.me API + caching
│   └── local_storage_service.dart # SharedPreferences wrapper
│
├── repositories/
│   ├── room_repository.dart       # Room creation, joining, code generation
│   ├── message_repository.dart    # Send messages, message stream
│   └── user_repository.dart       # Get/create identity per room
│
├── blocs/
│   ├── user_bloc.dart             # User identity lifecycle
│   ├── room_bloc.dart             # Room create/join
│   ├── chat_bloc.dart             # Real-time message stream + send
│   └── theme_bloc.dart            # Dark/light toggle
│
├── screens/
│   ├── join_room_screen.dart      # Home — enter code or create room
│   └── chat_screen.dart           # Chat UI — messages, input, header
│
├── widgets/
│   ├── message_bubble.dart        # Individual message card
│   ├── date_separator.dart        # Date divider between groups
│   ├── message_input.dart         # Text field + send button
│   ├── room_header.dart           # Room info bar
│   └── loading_indicator.dart     # Loading state
│
├── theme/
│   ├── app_colors.dart            # Color constants
│   ├── app_theme.dart             # ThemeData (dark + light)
│   └── app_text_styles.dart       # Typography
│
└── constants/
    └── app_constants.dart
```

## Firestore Schema

```
rooms/{roomId}
├── code: string            # Join code (e.g. "A3KF")
├── createdAt: timestamp
├── memberCount: number
└── lastMessage: string?

messages/{roomId}/messages/{messageId}
├── userId: string
├── userName: string
├── userAvatar: string      # Avatar URL
├── text: string
├── timestamp: timestamp    # Server timestamp
└── hidden: boolean
```

## Architecture

```
Screens / Widgets  (UI)
        │
      Blocs        (State)
        │
   Repositories    (Business logic)
        │
     Services      (I/O)
   ┌────┼────┐
   ▼    ▼    ▼
Firestore  API  SharedPrefs
```

- **Services** — raw I/O: Firestore reads/writes, HTTP calls, local storage
- **Repositories** — business logic: code generation, identity creation, validation
- **Blocs** — UI state: loading → loaded → error transitions
- **Screens** — render UI, dispatch bloc events

## Setup

### Prerequisites

- Flutter SDK 3.x
- Firebase project with Firestore enabled
- Android Studio / VS Code

### Steps

1. Clone
   ```bash
   git clone https://github.com/lucifer1200/rumour.git
   cd rumour
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Firebase setup
   - Create a project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable Cloud Firestore
   - Download `google-services.json` → place in `android/app/`
   - Update `lib/firebase_options.dart` with your config

4. Firestore rules (test mode)
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if true;
       }
     }
   }
   ```

5. Run
   ```bash
   flutter run
   ```

## Build APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## How It Works

1. Open app → JoinRoomScreen
2. **Create room** → generates random code, creates Firestore doc
3. **Join room** → looks up room by code
4. **Identity assigned** → fetches random name/avatar from RandomUser.me, saves to SharedPreferences keyed by roomId
5. **Chat** → messages written to Firestore subcollection, streamed back in real time
6. **Rejoin** → same room + same device = same identity (from local storage)
