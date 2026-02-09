//
//  ChatServiceProtocol.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

/// Chat-related errors
public enum ChatError: LocalizedError, Sendable {
    case conversationNotFound
    case messageNotFound
    case sendFailed
    case uploadFailed
    case encryptionFailed
    case permissionDenied
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .conversationNotFound:
            return "Conversation not found"
        case .messageNotFound:
            return "Message not found"
        case .sendFailed:
            return "Failed to send message"
        case .uploadFailed:
            return "Failed to upload media"
        case .encryptionFailed:
            return "Failed to encrypt message"
        case .permissionDenied:
            return "Permission denied"
        case .unknown(let message):
            return "Chat error: \(message)"
        }
    }
}

/// Protocol defining chat service contract
public protocol ChatServiceProtocol: Sendable {
    /// Send a text message
    /// - Parameters:
    ///   - text: Message text
    ///   - conversationId: Conversation identifier
    /// - Returns: Sent message
    /// - Throws: ChatError if sending fails
    func sendMessage(text: String, to conversationId: UUID) async throws -> Message

    /// Send media message
    /// - Parameters:
    ///   - media: Media data
    ///   - type: Media type
    ///   - conversationId: Conversation identifier
    /// - Returns: Sent message
    /// - Throws: ChatError if sending fails
    func sendMedia(_ media: Data, type: MediaType, to conversationId: UUID) async throws -> Message

    /// Edit message
    /// - Parameters:
    ///   - messageId: Message identifier
    ///   - newText: New message text
    /// - Throws: ChatError if edit fails
    func editMessage(id messageId: UUID, newText: String) async throws

    /// Delete message
    /// - Parameter messageId: Message identifier
    /// - Throws: ChatError if deletion fails
    func deleteMessage(id messageId: UUID) async throws

    /// Fetch messages for conversation
    /// - Parameters:
    ///   - conversationId: Conversation identifier
    ///   - limit: Maximum number of messages
    /// - Returns: Array of messages
    /// - Throws: ChatError if fetch fails
    func fetchMessages(for conversationId: UUID, limit: Int) async throws -> [Message]

    /// Listen to new messages
    /// - Parameter conversationId: Conversation identifier
    /// - Returns: AsyncStream of messages
    func listenToMessages(for conversationId: UUID) -> AsyncStream<Message>
}
