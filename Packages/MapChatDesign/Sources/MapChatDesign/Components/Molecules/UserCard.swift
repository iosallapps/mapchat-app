//
//  UserCard.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI
import MapChatCore

/// User card component displaying user information
public struct UserCard: View {
    // MARK: - Properties

    let user: User
    let showLocation: Bool
    let showOnlineStatus: Bool
    let onTap: (() -> Void)?

    // MARK: - Initialization

    public init(
        user: User,
        showLocation: Bool = false,
        showOnlineStatus: Bool = true,
        onTap: (() -> Void)? = nil
    ) {
        self.user = user
        self.showLocation = showLocation
        self.showOnlineStatus = showOnlineStatus
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: SpacingTokens.md) {
                // Avatar
                MapAvatar(
                    user: user,
                    size: .medium,
                    showOnlineStatus: showOnlineStatus
                )

                // User info
                VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                    Text(user.displayName)
                        .font(TypographyTokens.bodyBold)
                        .foregroundColor(ColorTokens.textPrimary)

                    if showLocation, let location = user.currentLocation {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 10))

                            Text(location.timestamp.timeAgoString)
                                .font(TypographyTokens.caption)
                        }
                        .foregroundColor(ColorTokens.textSecondary)
                    } else if !showLocation {
                        Text(user.email)
                            .font(TypographyTokens.caption)
                            .foregroundColor(ColorTokens.textSecondary)
                    }
                }

                Spacer()

                // Status badge
                if user.isGhostMode {
                    MapBadge(
                        text: "Ghost",
                        variant: .secondary,
                        size: .small,
                        icon: "eye.slash.fill"
                    )
                } else if showOnlineStatus {
                    if user.isOnline {
                        Circle()
                            .fill(ColorTokens.success)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding(SpacingTokens.md)
            .background(ColorTokens.surface)
            .cornerRadius(CornerRadiusTokens.md)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: SpacingTokens.sm) {
        UserCard(user: .sample)

        UserCard(
            user: User(
                name: "Alice Smith",
                email: "alice@example.com",
                isOnline: false,
                isGhostMode: true
            )
        )

        UserCard(
            user: User(
                name: "Bob Johnson",
                email: "bob@example.com",
                currentLocation: .sample,
                isOnline: true
            ),
            showLocation: true
        )
    }
    .padding()
    .background(ColorTokens.background)
}
