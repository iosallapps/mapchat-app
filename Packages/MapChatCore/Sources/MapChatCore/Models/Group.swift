//
//  Group.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

/// Group model representing a collection of users
public struct Group: Identifiable, Codable, Hashable, Sendable {
    /// Unique identifier
    public let id: UUID

    /// Group name
    public var name: String

    /// Group admin user ID
    public var adminId: UUID

    /// Member user IDs
    public var memberIds: [UUID]

    /// Group avatar URL (optional)
    public var avatarURL: URL?

    /// Creation date
    public let createdAt: Date

    /// Last update date
    public var updatedAt: Date

    /// Group description (optional)
    public var description: String?

    // MARK: - Initialization

    public init(
        id: UUID = UUID(),
        name: String,
        adminId: UUID,
        memberIds: [UUID] = [],
        avatarURL: URL? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.adminId = adminId
        self.memberIds = memberIds
        self.avatarURL = avatarURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.description = description
    }

    // MARK: - Computed Properties

    /// Total member count (including admin)
    public var memberCount: Int {
        memberIds.count
    }

    /// Check if group has avatar
    public var hasAvatar: Bool {
        avatarURL != nil
    }

    /// All member IDs including admin
    public var allMemberIds: [UUID] {
        var all = memberIds
        if !all.contains(adminId) {
            all.append(adminId)
        }
        return all
    }
}

// MARK: - Member Management

extension Group {
    /// Check if user is admin
    /// - Parameter userId: User ID to check
    /// - Returns: True if user is admin
    public func isAdmin(_ userId: UUID) -> Bool {
        adminId == userId
    }

    /// Check if user is member
    /// - Parameter userId: User ID to check
    /// - Returns: True if user is member or admin
    public func isMember(_ userId: UUID) -> Bool {
        allMemberIds.contains(userId)
    }

    /// Add member (returns new group with member added)
    /// - Parameter userId: User ID to add
    /// - Returns: Updated group
    public func adding(member userId: UUID) -> Group {
        var updated = self
        if !updated.memberIds.contains(userId) && userId != adminId {
            updated.memberIds.append(userId)
            updated.updatedAt = Date()
        }
        return updated
    }

    /// Remove member (returns new group with member removed)
    /// - Parameter userId: User ID to remove
    /// - Returns: Updated group
    public func removing(member userId: UUID) -> Group {
        var updated = self
        updated.memberIds.removeAll { $0 == userId }
        updated.updatedAt = Date()
        return updated
    }

    /// Promote member to admin (returns new group with new admin)
    /// - Parameter userId: User ID to promote
    /// - Returns: Updated group
    public func promotingToAdmin(_ userId: UUID) -> Group {
        var updated = self
        // Add current admin to members if not already there
        if !updated.memberIds.contains(updated.adminId) {
            updated.memberIds.append(updated.adminId)
        }
        // Set new admin
        updated.adminId = userId
        // Remove new admin from regular members
        updated.memberIds.removeAll { $0 == userId }
        updated.updatedAt = Date()
        return updated
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension Group {
    /// Sample group for previews
    public static var sample: Group {
        Group(
            name: "Travel Buddies",
            adminId: UUID(),
            memberIds: [UUID(), UUID(), UUID()]
        )
    }

    /// Array of sample groups
    public static var samples: [Group] {
        [
            Group(name: "Family", adminId: UUID(), memberIds: [UUID(), UUID()]),
            Group(name: "Work Friends", adminId: UUID(), memberIds: [UUID(), UUID(), UUID()]),
            Group(name: "College Squad", adminId: UUID(), memberIds: [UUID()])
        ]
    }
}
#endif
