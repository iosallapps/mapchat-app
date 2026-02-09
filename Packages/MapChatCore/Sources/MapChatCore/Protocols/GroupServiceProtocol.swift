//
//  GroupServiceProtocol.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

/// Group-related errors
public enum GroupError: LocalizedError, Sendable {
    case notFound
    case notAdmin
    case memberNotFound
    case invalidData
    case conflictDetected
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "Group not found"
        case .notAdmin:
            return "Admin permission required"
        case .memberNotFound:
            return "Member not found in group"
        case .invalidData:
            return "Invalid group data"
        case .conflictDetected:
            return "Conflict detected, please try again"
        case .unknown(let message):
            return "Group error: \(message)"
        }
    }
}

/// Protocol defining group service contract
public protocol GroupServiceProtocol: Sendable {
    /// Create a new group
    /// - Parameter group: Group to create
    /// - Returns: Created group with ID
    /// - Throws: GroupError if creation fails
    func createGroup(_ group: Group) async throws -> Group

    /// Update group
    /// - Parameter group: Group to update
    /// - Throws: GroupError if update fails
    func updateGroup(_ group: Group) async throws

    /// Delete group
    /// - Parameter id: Group identifier
    /// - Throws: GroupError if deletion fails
    func deleteGroup(id: UUID) async throws

    /// Add member to group
    /// - Parameters:
    ///   - userId: User identifier
    ///   - groupId: Group identifier
    /// - Throws: GroupError if addition fails
    func addMember(_ userId: UUID, to groupId: UUID) async throws

    /// Remove member from group
    /// - Parameters:
    ///   - userId: User identifier
    ///   - groupId: Group identifier
    /// - Throws: GroupError if removal fails
    func removeMember(_ userId: UUID, from groupId: UUID) async throws

    /// Promote member to admin
    /// - Parameters:
    ///   - userId: User identifier
    ///   - groupId: Group identifier
    /// - Throws: GroupError if promotion fails
    func promoteToAdmin(_ userId: UUID, in groupId: UUID) async throws

    /// Fetch groups for user
    /// - Parameter user: User to fetch groups for
    /// - Returns: Array of groups
    /// - Throws: GroupError if fetch fails
    func fetchGroups(for user: User) async throws -> [Group]
}
