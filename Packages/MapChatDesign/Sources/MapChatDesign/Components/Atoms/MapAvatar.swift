//
//  MapAvatar.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI
import MapChatCore

/// Avatar size variants
public enum AvatarSize {
    case small
    case medium
    case large
    case extraLarge

    var dimension: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 44
        case .large: return 64
        case .extraLarge: return 96
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .small: return TypographyTokens.sizeXS
        case .medium: return TypographyTokens.sizeSM
        case .large: return TypographyTokens.sizeLG
        case .extraLarge: return TypographyTokens.size2XL
        }
    }

    var statusSize: CGFloat {
        dimension * 0.25
    }
}

/// Custom avatar component
public struct MapAvatar: View {
    // MARK: - Properties

    let imageURL: URL?
    let initials: String
    let size: AvatarSize
    let showOnlineStatus: Bool
    let isOnline: Bool

    // MARK: - Initialization

    public init(
        imageURL: URL? = nil,
        initials: String,
        size: AvatarSize = .medium,
        showOnlineStatus: Bool = false,
        isOnline: Bool = false
    ) {
        self.imageURL = imageURL
        self.initials = initials
        self.size = size
        self.showOnlineStatus = showOnlineStatus
        self.isOnline = isOnline
    }

    public init(
        user: User,
        size: AvatarSize = .medium,
        showOnlineStatus: Bool = false
    ) {
        self.imageURL = user.avatarURL
        self.initials = user.name.initials
        self.size = size
        self.showOnlineStatus = showOnlineStatus
        self.isOnline = user.isOnline
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Avatar content
            if let imageURL = imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        loadingView
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        fallbackView
                    @unknown default:
                        fallbackView
                    }
                }
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
            } else {
                fallbackView
            }

            // Online status indicator
            if showOnlineStatus {
                Circle()
                    .fill(isOnline ? ColorTokens.success : ColorTokens.textTertiary)
                    .frame(width: size.statusSize, height: size.statusSize)
                    .overlay(
                        Circle()
                            .stroke(ColorTokens.background, lineWidth: 2)
                    )
            }
        }
    }

    // MARK: - Subviews

    private var fallbackView: some View {
        ZStack {
            Circle()
                .fill(ColorTokens.primaryGradient)

            Text(initials)
                .font(.system(size: size.fontSize, weight: .semibold))
                .foregroundColor(.black)
        }
        .frame(width: size.dimension, height: size.dimension)
    }

    private var loadingView: some View {
        ZStack {
            Circle()
                .fill(ColorTokens.surface)

            ProgressView()
                .tint(ColorTokens.primary)
        }
        .frame(width: size.dimension, height: size.dimension)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: SpacingTokens.xl) {
        HStack(spacing: SpacingTokens.lg) {
            MapAvatar(initials: "JD", size: .small)
            MapAvatar(initials: "JD", size: .medium)
            MapAvatar(initials: "JD", size: .large)
            MapAvatar(initials: "JD", size: .extraLarge)
        }

        HStack(spacing: SpacingTokens.lg) {
            MapAvatar(initials: "AS", size: .medium, showOnlineStatus: true, isOnline: true)
            MapAvatar(initials: "BJ", size: .medium, showOnlineStatus: true, isOnline: false)
        }

        MapAvatar(user: .sample, size: .large, showOnlineStatus: true)
    }
    .padding()
    .background(ColorTokens.background)
}
