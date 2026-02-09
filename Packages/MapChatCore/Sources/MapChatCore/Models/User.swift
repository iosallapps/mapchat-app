//
//  User.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

/// User model representing an app user
public struct User: Identifiable, Codable, Hashable, Sendable {
    /// Unique identifier
    public let id: UUID

    /// User's full name
    public var name: String

    /// User's email address
    public var email: String

    /// User's phone number (optional)
    public var phoneNumber: String?

    /// Avatar image URL
    public var avatarURL: URL?

    /// User's current location
    public var currentLocation: UserLocation?

    /// Groups the user belongs to
    public var groupIds: [UUID]

    /// Account creation date
    public let createdAt: Date

    /// Last update date
    public var updatedAt: Date

    /// Online status
    public var isOnline: Bool

    /// Last seen timestamp
    public var lastSeen: Date?

    /// Ghost mode (location sharing paused)
    public var isGhostMode: Bool

    /// Blocked user IDs
    public var blockedUserIds: [UUID]

    // MARK: - Initialization

    public init(
        id: UUID = UUID(),
        name: String,
        email: String,
        phoneNumber: String? = nil,
        avatarURL: URL? = nil,
        currentLocation: UserLocation? = nil,
        groupIds: [UUID] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isOnline: Bool = false,
        lastSeen: Date? = nil,
        isGhostMode: Bool = false,
        blockedUserIds: [UUID] = []
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.avatarURL = avatarURL
        self.currentLocation = currentLocation
        self.groupIds = groupIds
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isOnline = isOnline
        self.lastSeen = lastSeen
        self.isGhostMode = isGhostMode
        self.blockedUserIds = blockedUserIds
    }

    // MARK: - Computed Properties

    /// Display name for the user
    public var displayName: String {
        name.isEmpty ? "Unknown User" : name
    }

    /// Check if user has avatar
    public var hasAvatar: Bool {
        avatarURL != nil
    }

    /// Check if user's location is visible
    public var isLocationVisible: Bool {
        !isGhostMode && currentLocation != nil
    }
}

// MARK: - Extensions

extension User {
    /// Check if user is blocked
    /// - Parameter userId: User ID to check
    /// - Returns: True if user is blocked
    public func isBlocked(_ userId: UUID) -> Bool {
        blockedUserIds.contains(userId)
    }

    /// Check if user belongs to group
    /// - Parameter groupId: Group ID to check
    /// - Returns: True if user belongs to group
    public func belongsToGroup(_ groupId: UUID) -> Bool {
        groupIds.contains(groupId)
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension User {
    /// Sample user for previews
    public static var sample: User {
        User(
            name: "John Doe",
            email: "john@example.com",
            phoneNumber: "+1234567890",
            isOnline: true
        )
    }

    /// Array of sample users
    public static var samples: [User] {
        [
            User(name: "Alice Smith", email: "alice@example.com", isOnline: true),
            User(name: "Bob Johnson", email: "bob@example.com", isOnline: false),
            User(name: "Carol White", email: "carol@example.com", isOnline: true)
        ]
    }
}
#endif
