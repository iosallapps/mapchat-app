//
//  ChatViewModel.swift
//  MapChatFeatures
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import SwiftUI
import MapChatCore

/// View model for Chat feature
/// Manages conversations, messages, and real-time updates
@MainActor
@Observable
public final class ChatViewModel {
    // MARK: - Published Properties

    public var conversations: [Conversation] = []
    public var selectedConversation: Conversation?
    public var messages: [Message] = []
    public var isLoading = false
    public var errorMessage: String?
    public var searchText = ""

    // MARK: - Private Properties

    private let chatService: ChatServiceProtocol
    private var currentUser: User?
    private var messageListenerTask: Task<Void, Never>?

    // MARK: - Initialization

    public init(chatService: ChatServiceProtocol) {
        self.chatService = chatService
    }

    // MARK: - Public Methods

    /// Load conversations for current user
    public func loadConversations() async {
        isLoading = true
        errorMessage = nil

        // TODO: Fetch conversations from Firestore
        // For now, use empty array
        conversations = []

        isLoading = false
    }

    /// Select a conversation
    /// - Parameter conversation: Conversation to select
    public func selectConversation(_ conversation: Conversation) async {
        selectedConversation = conversation
        await loadMessages(for: conversation)
        startListeningToMessages()
    }

    /// Load messages for a conversation
    /// - Parameter conversation: Conversation to load messages for
    public func loadMessages(for conversation: Conversation) async {
        isLoading = true
        errorMessage = nil

        do {
            messages = try await chatService.fetchMessages(
                for: conversation.id,
                limit: 50
            )
            messages.sort { $0.createdAt < $1.createdAt }
        } catch {
            errorMessage = "Failed to load messages: \(error.localizedDescription)"
            print("❌ Load messages error: \(error)")
        }

        isLoading = false
    }

    /// Send a text message
    /// - Parameter text: Message text
    public func sendMessage(_ text: String) async {
        guard let conversation = selectedConversation else { return }
        guard !text.trimmed.isEmpty else { return }

        do {
            let message = try await chatService.sendMessage(
                text: text,
                to: conversation.id
            )
            messages.append(message)
            print("✅ Message sent")
        } catch {
            errorMessage = "Failed to send message: \(error.localizedDescription)"
            print("❌ Send message error: \(error)")
        }
    }

    /// Send media message
    /// - Parameters:
    ///   - data: Media data
    ///   - type: Media type
    public func sendMedia(_ data: Data, type: MediaType) async {
        guard let conversation = selectedConversation else { return }

        do {
            let message = try await chatService.sendMedia(
                data,
                type: type,
                to: conversation.id
            )
            messages.append(message)
            print("✅ Media sent")
        } catch {
            errorMessage = "Failed to send media: \(error.localizedDescription)"
            print("❌ Send media error: \(error)")
        }
    }

    /// Delete a message
    /// - Parameter message: Message to delete
    public func deleteMessage(_ message: Message) async {
        do {
            try await chatService.deleteMessage(id: message.id)
            messages.removeAll { $0.id == message.id }
            print("✅ Message deleted")
        } catch {
            errorMessage = "Failed to delete message: \(error.localizedDescription)"
            print("❌ Delete message error: \(error)")
        }
    }

    /// Set current user
    /// - Parameter user: Current user
    public func setCurrentUser(_ user: User) {
        currentUser = user
    }

    // MARK: - Real-time Updates

    private func startListeningToMessages() {
        guard let conversation = selectedConversation else { return }

        messageListenerTask?.cancel()

        messageListenerTask = Task {
            for await message in chatService.listenToMessages(for: conversation.id) {
                // Check if message already exists
                if !messages.contains(where: { $0.id == message.id }) {
                    messages.append(message)
                    messages.sort { $0.createdAt < $1.createdAt }
                }
            }
        }
    }

    private func stopListeningToMessages() {
        messageListenerTask?.cancel()
        messageListenerTask = nil
    }

    // MARK: - Cleanup

    deinit {
        stopListeningToMessages()
    }
}

// MARK: - Conversation Model

public struct Conversation: Identifiable, Codable, Hashable {
    public let id: UUID
    public var participants: [UUID]
    public var lastMessage: Message?
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        participants: [UUID],
        lastMessage: Message? = nil,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.participants = participants
        self.lastMessage = lastMessage
        self.updatedAt = updatedAt
    }
}

// MARK: - Preview

#if DEBUG
extension ChatViewModel {
    public static var preview: ChatViewModel {
        let vm = ChatViewModel(chatService: MockChatService())
        vm.messages = Message.samples
        return vm
    }
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

    func fetchMessages(for conversationId: UUID, limit: Int) async throws -> [Message] {
        Message.samples
    }

    func listenToMessages(for conversationId: UUID) -> AsyncStream<Message> {
        AsyncStream { _ in }
    }
}
#endif
