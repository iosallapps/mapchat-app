//
//  AppCoordinator.swift
//  MapChat
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import SwiftUI
import MapChatCore

/// Application routes
enum AppRoute: Hashable {
    // Map routes
    case map
    case userDetail(User)

    // Trip routes
    case tripList
    case tripDetail(Trip)
    case createTrip
    case editTrip(Trip)
    case tripHistory

    // Group routes
    case groupDetail(Group)
    case createGroup
    case editGroup(Group)
    case addMembers(Group)

    // Chat routes
    case chatList
    case conversation(UUID)

    // Settings routes
    case settings
    case privacySettings
    case profile
}

/// Navigation coordinator for the application
/// Manages navigation state and routing using iOS 16+ NavigationStack
@MainActor
final class AppCoordinator: ObservableObject {
    // MARK: - Published Properties

    /// Current navigation path
    @Published var path = NavigationPath()

    /// Current selected tab
    @Published var selectedTab: Tab = .map

    /// Sheet presentation
    @Published var presentedSheet: SheetRoute?

    // MARK: - Tab Enum

    enum Tab: Int, CaseIterable {
        case map
        case trip
        case chat

        var title: String {
            switch self {
            case .map: return "Map"
            case .trip: return "Trips"
            case .chat: return "Chat"
            }
        }

        var icon: String {
            switch self {
            case .map: return "map.fill"
            case .trip: return "car.fill"
            case .chat: return "message.fill"
            }
        }
    }

    // MARK: - Sheet Routes

    enum SheetRoute: Identifiable {
        case createTrip
        case createGroup
        case settings
        case profile

        var id: String {
            switch self {
            case .createTrip: return "createTrip"
            case .createGroup: return "createGroup"
            case .settings: return "settings"
            case .profile: return "profile"
            }
        }
    }

    // MARK: - Navigation Methods

    /// Navigate to a route
    /// - Parameter route: Route to navigate to
    func navigate(to route: AppRoute) {
        path.append(route)
    }

    /// Navigate back one level
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Navigate to root (clear entire stack)
    func navigateToRoot() {
        path.removeLast(path.count)
    }

    /// Present sheet
    /// - Parameter sheet: Sheet route to present
    func presentSheet(_ sheet: SheetRoute) {
        presentedSheet = sheet
    }

    /// Dismiss current sheet
    func dismissSheet() {
        presentedSheet = nil
    }

    /// Switch to a specific tab
    /// - Parameter tab: Tab to switch to
    func switchTab(to tab: Tab) {
        selectedTab = tab
        navigateToRoot() // Clear navigation stack when switching tabs
    }

    /// Deep link navigation
    /// - Parameter url: URL to handle
    func handleDeepLink(_ url: URL) {
        // TODO: Implement deep link handling
        print("🔗 Deep link: \(url)")
    }
}
