//
//  DependencyContainer.swift
//  MapChat
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import MapChatCore
import MapChatServices

/// Dependency injection container for the application
/// Provides centralized access to all services and manages their lifecycle
@MainActor
final class DependencyContainer: ObservableObject {
    // MARK: - Singleton

    static let shared = DependencyContainer()

    // MARK: - Services

    /// Authentication service
    private(set) lazy var authService: AuthServiceProtocol = {
        // TODO: Initialize actual FirebaseAuthService
        MockAuthService()
    }()

    /// Location service
    private(set) lazy var locationService: LocationServiceProtocol = {
        // TODO: Initialize actual LocationService
        MockLocationService()
    }()

    /// Trip service
    private(set) lazy var tripService: TripServiceProtocol = {
        // TODO: Initialize actual FirebaseTripService
        MockTripService()
    }()

    /// Group service
    private(set) lazy var groupService: GroupServiceProtocol = {
        // TODO: Initialize actual FirebaseGroupService
        MockGroupService()
    }()

    /// Chat service
    private(set) lazy var chatService: ChatServiceProtocol = {
        // TODO: Initialize actual FirebaseChatService
        MockChatService()
    }()

    // MARK: - Initialization

    private init() {
        // Private initialization to enforce singleton pattern
    }

    // MARK: - Configuration

    /// Configure all services
    func configure() {
        // TODO: Initialize Firebase
        // TODO: Configure services
        print("📦 DependencyContainer configured")
    }

    /// Reset all services (useful for logout)
    func reset() {
        // TODO: Reset service instances
        print("📦 DependencyContainer reset")
    }
}

// MARK: - Mock Services (Temporary)

private class MockAuthService: AuthServiceProtocol {
    var currentUser: User? {
        get async { nil }
    }

    var isAuthenticated: Bool {
        get async { false }
    }

    func signIn(with provider: AuthProvider) async throws -> User {
        throw AuthError.unknown("Not implemented")
    }

    func signOut() async throws {}

    func refreshToken() async throws {}

    func deleteAccount() async throws {}
}

private class MockLocationService: LocationServiceProtocol {
    var permissionStatus: LocationPermissionStatus {
        get async { .notDetermined }
    }

    var currentLocation: UserLocation? {
        get async { nil }
    }

    func requestPermission(_ type: LocationTrackingMode) async throws {}

    func startTracking() async throws {}

    func stopTracking() async {}

    func getCurrentLocation() async throws -> UserLocation {
        throw LocationError.failedToGetLocation
    }

    func updateLocation(_ location: UserLocation) async throws {}
}

private class MockTripService: TripServiceProtocol {
    func createTrip(_ trip: Trip) async throws -> Trip { trip }

    func updateTrip(_ trip: Trip) async throws {}

    func deleteTrip(id: UUID) async throws {}

    func fetchTrips(for user: User) async throws -> [Trip] { [] }

    func fetchActiveTrips() async throws -> [Trip] { [] }

    func fetchTrip(id: UUID) async throws -> Trip {
        throw TripError.notFound
    }
}

private class MockGroupService: GroupServiceProtocol {
    func createGroup(_ group: Group) async throws -> Group { group }

    func updateGroup(_ group: Group) async throws {}

    func deleteGroup(id: UUID) async throws {}

    func addMember(_ userId: UUID, to groupId: UUID) async throws {}

    func removeMember(_ userId: UUID, from groupId: UUID) async throws {}

    func promoteToAdmin(_ userId: UUID, in groupId: UUID) async throws {}

    func fetchGroups(for user: User) async throws -> [Group] { [] }
}

private class MockChatService: ChatServiceProtocol {
    func sendMessage(text: String, to conversationId: UUID) async throws -> Message {
        Message(conversationId: conversationId, senderId: UUID(), text: text)
    }

    func sendMedia(_ media: Data, type: MediaType, to conversationId: UUID) async throws -> Message {
        Message(conversationId: conversationId, senderId: UUID())
    }

    func editMessage(id messageId: UUID, newText: String) async throws {}

    func deleteMessage(id messageId: UUID) async throws {}

    func fetchMessages(for conversationId: UUID, limit: Int) async throws -> [Message] { [] }

    func listenToMessages(for conversationId: UUID) -> AsyncStream<Message> {
        AsyncStream { _ in }
    }
}
