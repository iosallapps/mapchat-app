//
//  AuthServiceProtocol.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

/// Authentication provider types
public enum AuthProvider: String, Sendable {
    case apple
    case google
}

/// Authentication errors
public enum AuthError: LocalizedError, Sendable {
    case cancelled
    case invalidCredentials
    case networkError
    case tokenExpired
    case userNotFound
    case accountDeleted
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .cancelled:
            return "Authentication was cancelled"
        case .invalidCredentials:
            return "Invalid credentials provided"
        case .networkError:
            return "Network error occurred"
        case .tokenExpired:
            return "Authentication token expired"
        case .userNotFound:
            return "User not found"
        case .accountDeleted:
            return "Account has been deleted"
        case .unknown(let message):
            return "Authentication error: \(message)"
        }
    }
}

/// Protocol defining authentication service contract
@MainActor
public protocol AuthServiceProtocol: Sendable {
    /// Current authenticated user
    var currentUser: User? { get async }

    /// Check if user is authenticated
    var isAuthenticated: Bool { get async }

    /// Sign in with specified provider
    /// - Parameter provider: Authentication provider (Apple or Google)
    /// - Returns: Authenticated user
    /// - Throws: AuthError if authentication fails
    func signIn(with provider: AuthProvider) async throws -> User

    /// Sign out current user
    /// - Throws: AuthError if sign out fails
    func signOut() async throws

    /// Refresh authentication token
    /// - Throws: AuthError if token refresh fails
    func refreshToken() async throws

    /// Delete user account
    /// - Throws: AuthError if deletion fails
    func deleteAccount() async throws
}
