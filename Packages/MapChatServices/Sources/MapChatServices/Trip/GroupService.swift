//
//  GroupService.swift
//  MapChatServices
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import MapChatCore

/// Group service implementation using Firestore
public actor GroupService: GroupServiceProtocol {
    // MARK: - Properties

    private let firestoreManager = FirestoreManager.shared
    private let collection = FirestoreManager.Collection.groups
    private var currentUserId: UUID?

    // MARK: - Initialization

    public init() {}

    // MARK: - Public Methods

    public func createGroup(_ group: Group) async throws -> Group {
        var newGroup = group

        // Generate ID if needed
        if group.id == UUID(uuidString: "00000000-0000-0000-0000-000000000000") {
            newGroup = Group(
                id: UUID(),
                name: group.name,
                adminId: group.adminId,
                memberIds: group.memberIds,
                avatarURL: group.avatarURL,
                description: group.description
            )
        }

        // Validate group
        try validateGroup(newGroup)

        // Save to Firestore
        try await firestoreManager.setDocument(
            newGroup,
            in: collection,
            documentId: newGroup.id.uuidString
        )

        print("✅ Group created: \(newGroup.name)")
        return newGroup
    }

    public func updateGroup(_ group: Group) async throws {
        // Validate group
        try validateGroup(group)

        // Check admin permission
        try await checkAdminPermission(groupId: group.id, userId: group.adminId)

        // Update in Firestore
        try await firestoreManager.setDocument(
            group,
            in: collection,
            documentId: group.id.uuidString
        )

        print("✅ Group updated: \(group.name)")
    }

    public func deleteGroup(id: UUID) async throws {
        // Check admin permission
        guard let userId = currentUserId else {
            throw GroupError.notAdmin
        }

        try await checkAdminPermission(groupId: id, userId: userId)

        // Delete from Firestore
        try await firestoreManager.deleteDocument(
            from: collection,
            documentId: id.uuidString
        )

        print("✅ Group deleted: \(id)")
    }

    public func addMember(_ userId: UUID, to groupId: UUID) async throws {
        // Fetch group
        guard var group: Group = try await firestoreManager.getDocument(
            from: collection,
            documentId: groupId.uuidString
        ) else {
            throw GroupError.notFound
        }

        // Add member
        if !group.memberIds.contains(userId) && userId != group.adminId {
            group.memberIds.append(userId)
            group.updatedAt = Date()

            // Update in Firestore
            try await firestoreManager.setDocument(
                group,
                in: collection,
                documentId: groupId.uuidString
            )

            print("✅ Member added to group: \(userId)")
        }
    }

    public func removeMember(_ userId: UUID, from groupId: UUID) async throws {
        // Check admin permission
        guard let currentUserId = currentUserId else {
            throw GroupError.notAdmin
        }

        try await checkAdminPermission(groupId: groupId, userId: currentUserId)

        // Fetch group
        guard var group: Group = try await firestoreManager.getDocument(
            from: collection,
            documentId: groupId.uuidString
        ) else {
            throw GroupError.notFound
        }

        // Cannot remove admin
        guard userId != group.adminId else {
            throw GroupError.notAdmin
        }

        // Remove member
        group.memberIds.removeAll { $0 == userId }
        group.updatedAt = Date()

        // Update in Firestore
        try await firestoreManager.setDocument(
            group,
            in: collection,
            documentId: groupId.uuidString
        )

        print("✅ Member removed from group: \(userId)")

        // If no members left, delete group
        if group.memberCount == 0 {
            try await deleteGroup(id: groupId)
        }
    }

    public func promoteToAdmin(_ userId: UUID, in groupId: UUID) async throws {
        // Check current admin permission
        guard let currentUserId = currentUserId else {
            throw GroupError.notAdmin
        }

        try await checkAdminPermission(groupId: groupId, userId: currentUserId)

        // Fetch group
        guard var group: Group = try await firestoreManager.getDocument(
            from: collection,
            documentId: groupId.uuidString
        ) else {
            throw GroupError.notFound
        }

        // Check if user is member
        guard group.isMember(userId) else {
            throw GroupError.memberNotFound
        }

        // Promote to admin
        group = group.promotingToAdmin(userId)

        // Update in Firestore
        try await firestoreManager.setDocument(
            group,
            in: collection,
            documentId: groupId.uuidString
        )

        print("✅ User promoted to admin: \(userId)")
    }

    public func fetchGroups(for user: User) async throws -> [Group] {
        // Query groups where user is member or admin
        // TODO: Implement proper Firestore query
        return []
    }

    // MARK: - User Management

    public func setCurrentUser(_ userId: UUID) {
        currentUserId = userId
    }

    // MARK: - Validation

    private func validateGroup(_ group: Group) throws {
        guard !group.name.trimmed.isEmpty else {
            throw GroupError.invalidData
        }
    }

    private func checkAdminPermission(groupId: UUID, userId: UUID) async throws {
        guard let group: Group = try await firestoreManager.getDocument(
            from: collection,
            documentId: groupId.uuidString
        ) else {
            throw GroupError.notFound
        }

        guard group.isAdmin(userId) else {
            throw GroupError.notAdmin
        }
    }
}

// MARK: - Real-time Updates

extension GroupService {
    /// Listen to group changes
    /// - Parameter groupId: Group identifier
    /// - Returns: AsyncStream of group updates
    public func listenToGroup(id: UUID) -> AsyncStream<Group?> {
        firestoreManager.listenToDocument(
            from: collection,
            documentId: id.uuidString
        )
    }

    /// Listen to all groups for a user
    /// - Parameter userId: User identifier
    /// - Returns: AsyncStream of group arrays
    public func listenToUserGroups(userId: UUID) -> AsyncStream<[Group]> {
        firestoreManager.listenToCollection(from: collection)
    }
}
