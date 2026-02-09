# MapChat 🗺️

A modern travel companion app with real-time location tracking, trip management, and group chat functionality. Think "Find My Friends" meets travel planning with WhatsApp-style messaging.

![Platform](https://img.shields.io/badge/platform-iOS%2017%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![Architecture](https://img.shields.io/badge/architecture-MVVM-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## Features

### 🗺️ Real-Time Location Tracking
- Live location sharing with friends and travel groups
- Custom MapBox integration with beautiful pins
- Battery-optimized location updates
- External navigation (Waze, Apple Maps, Google Maps)
- Group-based location filtering
- Ghost mode for privacy

### ✈️ Trip Management
- Create trips with location, dates, and groups
- Active, upcoming, and past trip organization
- Trip history with search and filters
- Group management with admin controls
- Invite system via deep links
- Export trips as PDF

### 💬 Group Chat
- WhatsApp-style messaging
- Text, images, videos, voice messages
- Location sharing in chat
- WebRTC voice/video calls (P2P)
- End-to-end encryption
- Message editing and deletion
- Read receipts and typing indicators
- Online/offline presence

### 🔐 Privacy & Security
- Apple Sign-In and Google Sign-In
- Biometric authentication
- End-to-end message encryption
- Ghost mode (pause location sharing)
- Block users
- Auto-delete location history (30 days)
- GDPR-compliant data export

## Design

- **Color Scheme**: Radiant Green (#00FF41), Yellow (#FFD700), Black (#0A0A0A)
- **Style**: Clean, futuristic, business-focused
- **Themes**: Full light/dark mode support
- **Accessibility**: VoiceOver, Dynamic Type, high contrast

## Architecture

### Tech Stack
- **Language**: Swift 5.9 (Swift 6 concurrency)
- **UI Framework**: SwiftUI (iOS 17+)
- **Architecture**: MVVM + Protocol-Oriented + Coordinator
- **Dependency Injection**: Custom DependencyContainer
- **Navigation**: NavigationStack (iOS 16+)
- **Modularization**: Swift Package Manager

### Backend Services
- **Firebase**: Auth, Firestore, Storage, Messaging, Crashlytics
- **MapBox**: Maps SDK
- **WebRTC**: Voice/video calls
- **Kingfisher**: Image caching

### Project Structure

```
MapChat/
├── Packages/                          # SPM Modules
│   ├── MapChatCore/                   # 📦 Core Layer
│   │   ├── Models/                   # User, Trip, Group, Message, Location
│   │   ├── Protocols/                # Service protocols
│   │   └── Extensions/               # Utilities
│   │
│   ├── MapChatDesign/                 # 🎨 Design System
│   │   ├── Tokens/                   # Colors, Typography, Spacing
│   │   ├── Components/
│   │   │   ├── Atoms/                # Button, Avatar, TextField, Badge
│   │   │   ├── Molecules/            # UserCard, TripCard, SearchBar
│   │   │   └── Organisms/            # Complex components
│   │   └── Modifiers/                # Custom view modifiers
│   │
│   ├── MapChatServices/               # 🔧 Business Logic
│   │   ├── Auth/                     # Authentication
│   │   ├── Location/                 # Location tracking
│   │   ├── Firebase/                 # Firebase integration
│   │   ├── Trip/                     # Trip management
│   │   ├── Chat/                     # Messaging
│   │   ├── Search/                   # User search
│   │   ├── Notifications/            # Push notifications
│   │   ├── Sync/                     # Offline sync
│   │   └── Media/                    # Image/video processing
│   │
│   └── MapChatFeatures/               # 📱 UI Features
│       ├── Map/                      # Map tab
│       ├── Trip/                     # Trip tab
│       ├── Chat/                     # Chat tab
│       ├── Onboarding/               # First-run experience
│       └── Settings/                 # App settings
│
├── MapChat/                           # Main App Target
│   ├── Core/
│   │   ├── DependencyContainer.swift # IoC container
│   │   └── AppCoordinator.swift      # Navigation coordinator
│   ├── MapChatApp.swift               # App entry point
│   ├── MainTabView.swift             # Tab bar
│   ├── Info.plist                    # Permissions & config
│   └── GoogleService-Info.plist      # Firebase config
│
├── Podfile                           # CocoaPods dependencies
├── .swiftlint.yml                    # Code quality rules
├── SETUP.md                          # Setup instructions
└── README.md                         # This file
```

## Code Quality Standards

### Enforced Rules
- **Max file length**: 450 lines (SwiftLint enforced)
- **Max function length**: 100 lines
- **Cyclomatic complexity**: ≤15
- **Swift Concurrency**: Actor isolation, Sendable conformance
- **Test Coverage**: ≥50%

### Best Practices
- Protocol-oriented design
- Dependency injection
- Async/await (no completion handlers)
- Observation framework (iOS 17+)
- Comprehensive error handling
- Defensive programming

## Development Setup

See [SETUP.md](SETUP.md) for detailed installation instructions.

### Quick Start

```bash
# Clone repository
git clone [repository-url]
cd MapChat

# Install dependencies
pod install

# Open workspace
open MapChat.xcworkspace

# Add Firebase config
# 1. Download GoogleService-Info.plist from Firebase Console
# 2. Add to MapChat/ directory in Xcode

# Add MapBox token to Info.plist
# MBXAccessToken: YOUR_TOKEN_HERE

# Build and run
# Cmd + R in Xcode
```

## Testing

```bash
# Run unit tests
Cmd + U in Xcode

# Run UI tests
Cmd + U with UI test target selected

# Run SwiftLint
swiftlint

# Generate coverage report
xccov view --report --only-targets MapChat Coverage.xccovreport
```

## File Organization

### Naming Conventions
- **Models**: Noun (e.g., `User.swift`, `Trip.swift`)
- **Protocols**: `<Name>Protocol` (e.g., `AuthServiceProtocol.swift`)
- **ViewModels**: `<Feature>ViewModel` (e.g., `MapViewModel.swift`)
- **Views**: `<Feature>View` (e.g., `TripListView.swift`)
- **Services**: `<Name>Service` (e.g., `LocationService.swift`)

### File Templates
All files follow this structure:
```swift
//
//  FileName.swift
//  ModuleName
//
//  Created by [Name] on [Date].
//

import Foundation

// MARK: - Main Type

/// Documentation
public struct/class TypeName {
    // MARK: - Properties

    // MARK: - Initialization

    // MARK: - Public Methods

    // MARK: - Private Methods
}

// MARK: - Extensions

// MARK: - Preview Helpers (DEBUG only)
```

## Key Components

### DependencyContainer
Centralized service management with lazy initialization:
```swift
let container = DependencyContainer.shared
let authService = container.authService
let locationService = container.locationService
```

### AppCoordinator
Navigation management:
```swift
coordinator.navigate(to: .tripDetail(trip))
coordinator.presentSheet(.createTrip)
coordinator.switchTab(to: .map)
```

### Design System
Consistent UI with design tokens:
```swift
MapButton(title: "Create Trip", style: .primary) { }
MapAvatar(user: user, showOnlineStatus: true)
TripCard(trip: trip, memberCount: 5)
```

## Performance Optimizations

- **Location Updates**: Adaptive frequency based on movement
- **Image Loading**: Automatic compression, caching, prefetching
- **List Performance**: Pagination (20 items/page), lazy loading
- **Offline Support**: Local queue with background sync
- **Memory**: Aggressive cache management, downsampling

## Security

- End-to-end encryption for messages (AES-256)
- Keychain storage for sensitive data
- Certificate pinning for Firebase/MapBox
- No hardcoded secrets (environment config)
- HTTPS-only communication

## Roadmap

### Phase 1 (Complete)
- ✅ Project foundation
- ✅ Design system
- ✅ Architecture setup

### Phase 2 (In Progress)
- 🔄 Firebase integration
- 🔄 Authentication flow
- 🔄 Location services

### Phase 3 (Upcoming)
- ⏳ Map feature
- ⏳ Trip management
- ⏳ Group chat

### Phase 4 (Future)
- ⏳ Voice/video calls
- ⏳ Advanced features
- ⏳ Performance optimization

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Follow code quality standards (SwiftLint will enforce)
4. Write tests for new functionality
5. Commit changes (`git commit -m 'Add amazing feature'`)
6. Push to branch (`git push origin feature/amazing-feature`)
7. Open Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Firebase for backend services
- MapBox for beautiful maps
- The SwiftUI community for inspiration

## Contact

For questions or support, please open an issue on GitHub.

---

Built with ❤️ using SwiftUI and modern iOS development practices.
