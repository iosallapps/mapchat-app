//
//  Message.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

/// Message status
public enum MessageStatus: String, Codable, Sendable {
    case sending
    case sent
    case delivered
    case read
    case failed
}

/// Media type for messages
public enum MediaType: String, Codable, Sendable {
    case image
    case video
    case voice
    case location
}

/// Message model representing a chat message
public struct Message: Identifiable, Codable, Hashable, Sendable {
    /// Unique identifier
    public let id: UUID

    /// Conversation ID
    public let conversationId: UUID

    /// Sender user ID
    public let senderId: UUID

    /// Message text (optional for media messages)
    public var text: String?

    /// Media URL (optional)
    public var mediaURL: URL?

    /// Media type (optional)
    public var mediaType: MediaType?

    /// Shared location (optional)
    public var sharedLocation: UserLocation?

    /// Message status
    public var status: MessageStatus

    /// Creation timestamp
    public let createdAt: Date

    /// Last update timestamp
    public var updatedAt: Date

    /// Flag indicating if message was edited
    public var isEdited: Bool

    /// Flag indicating if message was deleted
    public var isDeleted: Bool

    /// Reply to message ID (optional)
    public var replyToId: UUID?

    // MARK: - Initialization

    public init(
        id: UUID = UUID(),
        conversationId: UUID,
        senderId: UUID,
        text: String? = nil,
        mediaURL: URL? = nil,
        mediaType: MediaType? = nil,
        sharedLocation: UserLocation? = nil,
        status: MessageStatus = .sending,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isEdited: Bool = false,
        isDeleted: Bool = false,
        replyToId: UUID? = nil
    ) {
        self.id = id
        self.conversationId = conversationId
        self.senderId = senderId
        self.text = text
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.sharedLocation = sharedLocation
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isEdited = isEdited
        self.isDeleted = isDeleted
        self.replyToId = replyToId
    }

    // MARK: - Computed Properties

    /// Check if message is text only
    public var isTextOnly: Bool {
        text != nil && mediaURL == nil && sharedLocation == nil
    }

    /// Check if message contains media
    public var hasMedia: Bool {
        mediaURL != nil && mediaType != nil
    }

    /// Check if message contains location
    public var hasLocation: Bool {
        sharedLocation != nil
    }

    /// Display text (handling deleted/media messages)
    public var displayText: String {
        if isDeleted {
            return "This message was deleted"
        }

        if let text = text, !text.isEmpty {
            return text
        }

        if hasMedia {
            switch mediaType {
            case .image:
                return "📷 Photo"
            case .video:
                return "🎥 Video"
            case .voice:
                return "🎙️ Voice message"
            case .location:
                return "📍 Location"
            case .none:
                return "Media"
            }
        }

        if hasLocation {
            return "📍 Shared location"
        }

        return ""
    }

    /// Check if message is reply
    public var isReply: Bool {
        replyToId != nil
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension Message {
    /// Sample text message
    public static var sampleText: Message {
        Message(
            conversationId: UUID(),
            senderId: UUID(),
            text: "Hey! How's it going?",
            status: .delivered
        )
    }

    /// Sample media message
    public static var sampleMedia: Message {
        Message(
            conversationId: UUID(),
            senderId: UUID(),
            text: "Check this out!",
            mediaURL: URL(string: "https://example.com/image.jpg"),
            mediaType: .image,
            status: .read
        )
    }

    /// Sample messages array
    public static var samples: [Message] {
        [
            Message(
                conversationId: UUID(),
                senderId: UUID(),
                text: "Hello!",
                status: .read,
                createdAt: Date().addingTimeInterval(-3600)
            ),
            Message(
                conversationId: UUID(),
                senderId: UUID(),
                text: "How are you?",
                status: .delivered,
                createdAt: Date().addingTimeInterval(-1800)
            ),
            Message(
                conversationId: UUID(),
                senderId: UUID(),
                mediaURL: URL(string: "https://example.com/photo.jpg"),
                mediaType: .image,
                status: .sent,
                createdAt: Date().addingTimeInterval(-900)
            )
        ]
    }
}
#endif
