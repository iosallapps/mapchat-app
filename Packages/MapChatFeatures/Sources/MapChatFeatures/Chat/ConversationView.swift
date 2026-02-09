//
//  ConversationView.swift
//  MapChatFeatures
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI
import MapChatCore
import MapChatDesign

/// Conversation view showing messages and input
public struct ConversationView: View {
    // MARK: - Properties

    @State private var viewModel: ChatViewModel
    @State private var messageText = ""
    @State private var showMediaPicker = false
    let conversation: Conversation

    // MARK: - Initialization

    public init(viewModel: ChatViewModel, conversation: Conversation) {
        self._viewModel = State(initialValue: viewModel)
        self.conversation = conversation
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: SpacingTokens.sm) {
                        ForEach(viewModel.messages) { message in
                            MessageBubbleView(
                                message: message,
                                isCurrentUser: true // TODO: Check actual user
                            )
                            .id(message.id)
                            .contextMenu {
                                if !message.isDeleted {
                                    Button(role: .destructive) {
                                        Task {
                                            await viewModel.deleteMessage(message)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .padding(SpacingTokens.md)
                }
                .background(ColorTokens.background)
                .onAppear {
                    if let lastMessage = viewModel.messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
                .onChange(of: viewModel.messages.count) { _, _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Message input
            messageInputBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text("Group Chat") // TODO: Get actual name
                        .font(TypographyTokens.bodyBold)
                        .foregroundColor(ColorTokens.textPrimary)

                    Text("\(conversation.participants.count) members")
                        .font(TypographyTokens.caption)
                        .foregroundColor(ColorTokens.textSecondary)
                }
            }
        }
        .task {
            await viewModel.selectConversation(conversation)
        }
    }

    // MARK: - Subviews

    private var messageInputBar: some View {
        HStack(spacing: SpacingTokens.sm) {
            // Media button
            Button(action: { showMediaPicker = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorTokens.primary)
            }

            // Text input
            HStack(spacing: SpacingTokens.xs) {
                TextField("Message", text: $messageText, axis: .vertical)
                    .font(TypographyTokens.body)
                    .foregroundColor(ColorTokens.textPrimary)
                    .lineLimit(1...5)
                    .padding(.horizontal, SpacingTokens.sm)
                    .padding(.vertical, SpacingTokens.xs)
            }
            .background(ColorTokens.surface)
            .cornerRadius(CornerRadiusTokens.lg)

            // Send button
            Button(action: sendMessage) {
                Image(systemName: messageText.isEmpty ? "mic.fill" : "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(messageText.isEmpty ? ColorTokens.textSecondary : ColorTokens.primary)
            }
            .disabled(viewModel.isLoading)
        }
        .padding(SpacingTokens.md)
        .background(ColorTokens.background)
    }

    // MARK: - Actions

    private func sendMessage() {
        guard !messageText.trimmed.isEmpty else {
            // TODO: Handle voice recording
            return
        }

        let text = messageText
        messageText = ""

        Task {
            await viewModel.sendMessage(text)
        }
    }
}

// MARK: - Message Bubble View

struct MessageBubbleView: View {
    let message: Message
    let isCurrentUser: Bool

    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }

            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                // Message content
                if message.isDeleted {
                    Text("This message was deleted")
                        .font(TypographyTokens.callout)
                        .italic()
                        .foregroundColor(ColorTokens.textTertiary)
                } else if let text = message.text {
                    Text(text)
                        .font(TypographyTokens.body)
                        .foregroundColor(isCurrentUser ? .black : ColorTokens.textPrimary)
                }

                // Media preview
                if message.hasMedia, let type = message.mediaType {
                    HStack(spacing: 4) {
                        Image(systemName: mediaIcon(for: type))
                        Text(mediaLabel(for: type))
                    }
                    .font(TypographyTokens.caption)
                    .foregroundColor(isCurrentUser ? .black.opacity(0.7) : ColorTokens.textSecondary)
                }

                // Timestamp
                HStack(spacing: 4) {
                    Text(message.createdAt.formattedTime)
                        .font(TypographyTokens.caption)
                        .foregroundColor(isCurrentUser ? .black.opacity(0.6) : ColorTokens.textTertiary)

                    if isCurrentUser {
                        Image(systemName: statusIcon(for: message.status))
                            .font(.system(size: 10))
                            .foregroundColor(.black.opacity(0.6))
                    }
                }
            }
            .padding(SpacingTokens.sm)
            .background(isCurrentUser ? ColorTokens.primary : ColorTokens.surface)
            .cornerRadius(CornerRadiusTokens.md)
            .frame(maxWidth: 280, alignment: isCurrentUser ? .trailing : .leading)

            if !isCurrentUser {
                Spacer()
            }
        }
    }

    private func mediaIcon(for type: MediaType) -> String {
        switch type {
        case .image: return "photo"
        case .video: return "video"
        case .voice: return "mic"
        case .location: return "location"
        }
    }

    private func mediaLabel(for type: MediaType) -> String {
        switch type {
        case .image: return "Photo"
        case .video: return "Video"
        case .voice: return "Voice"
        case .location: return "Location"
        }
    }

    private func statusIcon(for status: MessageStatus) -> String {
        switch status {
        case .sending: return "clock"
        case .sent: return "checkmark"
        case .delivered: return "checkmark.circle"
        case .read: return "checkmark.circle.fill"
        case .failed: return "exclamationmark.circle"
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ConversationView(
            viewModel: .preview,
            conversation: Conversation(participants: [UUID(), UUID()])
        )
    }
}
