//
//  MapBadge.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI

/// Badge variant
public enum BadgeVariant {
    case primary
    case secondary
    case success
    case error
    case warning
    case info
}

/// Badge size
public enum BadgeSize {
    case small
    case medium
    case large

    var fontSize: CGFloat {
        switch self {
        case .small: return TypographyTokens.sizeXS
        case .medium: return TypographyTokens.sizeSM
        case .large: return TypographyTokens.sizeMD
        }
    }

    var padding: EdgeInsets {
        switch self {
        case .small:
            return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        case .medium:
            return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        case .large:
            return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        }
    }
}

/// Custom badge component
public struct MapBadge: View {
    // MARK: - Properties

    let text: String
    let variant: BadgeVariant
    let size: BadgeSize
    let icon: String?

    // MARK: - Initialization

    public init(
        text: String,
        variant: BadgeVariant = .primary,
        size: BadgeSize = .medium,
        icon: String? = nil
    ) {
        self.text = text
        self.variant = variant
        self.size = size
        self.icon = icon
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: size.fontSize - 2))
            }

            Text(text)
                .font(.system(size: size.fontSize, weight: .semibold))
        }
        .foregroundColor(textColor)
        .padding(size.padding)
        .background(backgroundColor)
        .cornerRadius(CornerRadiusTokens.sm)
    }

    // MARK: - Style Helpers

    private var backgroundColor: Color {
        switch variant {
        case .primary:
            return ColorTokens.primary
        case .secondary:
            return ColorTokens.surface
        case .success:
            return ColorTokens.success
        case .error:
            return ColorTokens.error
        case .warning:
            return ColorTokens.warning
        case .info:
            return ColorTokens.info
        }
    }

    private var textColor: Color {
        switch variant {
        case .primary, .success, .error:
            return .black
        case .secondary:
            return ColorTokens.textPrimary
        case .warning, .info:
            return .white
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: SpacingTokens.lg) {
        HStack(spacing: SpacingTokens.sm) {
            MapBadge(text: "Primary", variant: .primary)
            MapBadge(text: "Secondary", variant: .secondary)
            MapBadge(text: "Success", variant: .success)
        }

        HStack(spacing: SpacingTokens.sm) {
            MapBadge(text: "Error", variant: .error)
            MapBadge(text: "Warning", variant: .warning)
            MapBadge(text: "Info", variant: .info)
        }

        HStack(spacing: SpacingTokens.sm) {
            MapBadge(text: "Small", size: .small)
            MapBadge(text: "Medium", size: .medium)
            MapBadge(text: "Large", size: .large)
        }

        HStack(spacing: SpacingTokens.sm) {
            MapBadge(text: "Active", variant: .success, icon: "checkmark.circle.fill")
            MapBadge(text: "3", variant: .error, size: .small)
            MapBadge(text: "New", variant: .warning, icon: "star.fill")
        }
    }
    .padding()
    .background(ColorTokens.background)
}
