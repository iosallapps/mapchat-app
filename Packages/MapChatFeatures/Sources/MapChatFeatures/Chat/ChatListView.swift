//
//  ChatListView.swift
//  MapChatFeatures
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI
import MapChatCore
import MapChatDesign

/// Main chat list view showing all conversations
public struct ChatListView: View {
    // MARK: - Properties

    @State private var viewModel: ChatViewModel
    @State private var selectedConversation: Conversation?

    // MARK: - Initialization

    public init(viewModel: ChatViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            ZStack {
                ColorTokens.background
                    .ignoresSafeArea()

                if viewModel.conversations.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    conversationListContent
                }

                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { /* TODO: New conversation */ }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(ColorTokens.primary)
                    }
                }
            }
            .task {
                await viewModel.loadConversations()
            }
        }
    }

    // MARK: - Subviews

    private var conversationListContent: some View {
        ScrollView {
            LazyVStack(spacing: SpacingTokens.xs) {
                ForEach(viewModel.conversations) { conversation in
                    NavigationLink(value: conversation) {
                        ConversationRow(conversation: conversation)
                    }
                }
            }
        }
        .navigationDestination(for: Conversation.self) { conversation in
            ConversationView(viewModel: viewModel, conversation: conversation)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: SpacingTokens.xl) {
            Image(systemName: "message.fill")
                .font(.system(size: 80))
                .foregroundColor(ColorTokens.primary)

            Text("No Conversations")
                .font(TypographyTokens.title2)
                .foregroundColor(ColorTokens.textPrimary)

            Text("Start chatting with your travel buddies")
                .font(TypographyTokens.body)
                .foregroundColor(ColorTokens.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, SpacingTokens.xl)

            MapButton(
                title: "New Chat",
                icon: "plus",
                style: .primary
            ) {
                // TODO: Show new conversation sheet
            }
            .padding(.horizontal, SpacingTokens.xl)
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            ColorTokens.overlay
                .ignoresSafeArea()

            ProgressView()
                .tint(ColorTokens.primary)
                .scaleEffect(1.5)
        }
    }
}

// MARK: - Conversation Row

struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: SpacingTokens.md) {
            // Avatar (placeholder)
            Circle()
                .fill(ColorTokens.primaryGradient)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 24))
                )

            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Group Chat") // TODO: Get actual name
                        .font(TypographyTokens.bodyBold)
                        .foregroundColor(ColorTokens.textPrimary)

                    Spacer()

                    if let lastMessage = conversation.lastMessage {
                        Text(lastMessage.createdAt.timeAgoString)
                            .font(TypographyTokens.caption)
                            .foregroundColor(ColorTokens.textSecondary)
                    }
                }

                if let lastMessage = conversation.lastMessage {
                    Text(lastMessage.displayText)
                        .font(TypographyTokens.callout)
                        .foregroundColor(ColorTokens.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
        .padding(SpacingTokens.md)
        .background(ColorTokens.surface)
        .cornerRadius(CornerRadiusTokens.md)
        .padding(.horizontal, SpacingTokens.md)
    }
}

// MARK: - Preview

#Preview {
    ChatListView(viewModel: .preview)
}
