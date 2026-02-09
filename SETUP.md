# MapChat Setup Instructions

## Prerequisites

- Xcode 15.0+ (for iOS 17+ support)
- CocoaPods 1.12+
- Swift 5.9+
- macOS 14.0+ (for development)

## Installation Steps

### 1. Install Dependencies

```bash
# Install CocoaPods if not already installed
sudo gem install cocoapods

# Install project dependencies
cd /path/to/MapChat
pod install
```

**Important:** Always open `MapChat.xcworkspace` (not `MapChat.xcodeproj`) after running `pod install`.

### 2. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "MapChat"
3. Add an iOS app with bundle ID: `iosallapps.MapChat`
4. Download `GoogleService-Info.plist`
5. Add the file to the `MapChat/` directory in Xcode

#### Firebase Services to Enable:
- Authentication (Apple Sign-In, Google Sign-In)
- Firestore Database
- Storage
- Cloud Messaging
- Crashlytics
- Analytics
- Remote Config
- Performance Monitoring

#### Firestore Security Rules:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Trips collection
    match /trips/{tripId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    // Groups collection
    match /groups/{groupId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    // Conversations collection
    match /conversations/{conversationId} {
      allow read: if request.auth.uid in resource.data.participants;
      allow write: if request.auth.uid in resource.data.participants;

      match /messages/{messageId} {
        allow read: if request.auth.uid in get(/databases/$(database)/documents/conversations/$(conversationId)).data.participants;
        allow write: if request.auth.uid in get(/databases/$(database)/documents/conversations/$(conversationId)).data.participants;
      }
    }

    // User locations collection
    match /locations/{locationId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

### 3. MapBox Setup

1. Go to [MapBox](https://www.mapbox.com/)
2. Create a free account
3. Get your public access token
4. Add to `Info.plist`:

```xml
<key>MBXAccessToken</key>
<string>YOUR_MAPBOX_TOKEN_HERE</string>
```

### 4. Apple Sign-In Setup

1. Go to [Apple Developer Portal](https://developer.apple.com/)
2. Enable "Sign in with Apple" capability
3. Add capability in Xcode: `Signing & Capabilities` → `+ Capability` → `Sign in with Apple`

### 5. Google Sign-In Setup

1. In Firebase Console, enable Google Sign-In provider
2. Download updated `GoogleService-Info.plist`
3. Add URL scheme to `Info.plist` (will be auto-added from GoogleService-Info.plist)

### 6. Permissions Configuration

The following permissions are already configured in `Info.plist`:

- **Location** (Always & When In Use)
  ```xml
  <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
  <string>We need your location to show you on the map and share with your travel buddies.</string>

  <key>NSLocationWhenInUseUsageDescription</key>
  <string>We need your location to show you on the map.</string>
  ```

- **Camera**
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Take photos to share in chat.</string>
  ```

- **Photo Library**
  ```xml
  <key>NSPhotoLibraryUsageDescription</key>
  <string>Select photos to share in chat.</string>
  ```

- **Microphone**
  ```xml
  <key>NSMicrophoneUsageDescription</key>
  <string>Record voice messages and make voice calls.</string>
  ```

### 7. Build and Run

```bash
# Open workspace
open MapChat.xcworkspace

# Build and run in Xcode (Cmd + R)
```

## Project Structure

```
MapChat/
├── Packages/                      # Swift Package Manager modules
│   ├── MapChatCore/               # Models, Protocols, Extensions
│   ├── MapChatDesign/             # Design System (Tokens, Components)
│   ├── MapChatServices/           # Business Logic (Auth, Location, etc.)
│   └── MapChatFeatures/           # UI Features (Map, Trip, Chat)
│
├── MapChat/                       # Main app target
│   ├── Core/                     # DependencyContainer, AppCoordinator
│   ├── Features/                 # Feature-specific views
│   ├── OnboardingViews/          # Onboarding flow
│   └── Resources/                # Assets, Info.plist
│
├── Podfile                       # CocoaPods dependencies
├── .swiftlint.yml               # Linting rules (450 line limit)
└── SETUP.md                     # This file
```

## Development Guidelines

### Code Quality
- **File Length**: Max 450 lines (enforced by SwiftLint)
- **Function Length**: Max 100 lines
- **Architecture**: MVVM + Protocol-Oriented + Coordinator
- **Concurrency**: Swift 6 strict concurrency (actor isolation, sendable)
- **Testing**: TDD approach, 50% minimum coverage

### Running SwiftLint

```bash
# Lint entire project
swiftlint

# Auto-fix issues
swiftlint --fix
```

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Commit with descriptive messages
git commit -m "feat: add user location tracking"

# Push and create PR
git push origin feature/your-feature-name
```

## Troubleshooting

### Pod install fails
```bash
# Clear cache and reinstall
pod cache clean --all
pod deintegrate
pod install
```

### Build errors with SPM packages
```bash
# Reset package cache in Xcode
File → Packages → Reset Package Caches
```

### Firebase not working
- Verify `GoogleService-Info.plist` is added to target
- Check bundle ID matches Firebase console
- Ensure Firebase is initialized in AppDelegate

## Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Firebase iOS Documentation](https://firebase.google.com/docs/ios/setup)
- [MapBox iOS SDK](https://docs.mapbox.com/ios/maps/guides/)
- [Apple Sign In Guide](https://developer.apple.com/sign-in-with-apple/)

## Support

For issues or questions, create an issue in the repository.
