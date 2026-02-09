//
//  MapButton.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI

/// Button style variants
public enum MapButtonStyle {
    case primary
    case secondary
    case outline
    case ghost
    case destructive
}

/// Button size variants
public enum MapButtonSize {
    case small
    case medium
    case large

    var height: CGFloat {
        switch self {
        case .small: return 36
        case .medium: return 44
        case .large: return 52
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .small: return TypographyTokens.sizeSM
        case .medium: return TypographyTokens.sizeMD
        case .large: return TypographyTokens.sizeLG
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return SpacingTokens.md
        case .medium: return SpacingTokens.lg
        case .large: return SpacingTokens.xl
        }
    }
}

/// Custom button component with MapChat design
public struct MapButton: View {
    // MARK: - Properties

    let title: String
    let icon: String?
    let style: MapButtonStyle
    let size: MapButtonSize
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    // MARK: - Initialization

    public init(
        title: String,
        icon: String? = nil,
        style: MapButtonStyle = .primary,
        size: MapButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            HStack(spacing: SpacingTokens.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: size.fontSize, weight: .semibold))
                    }

                    Text(title)
                        .font(.system(size: size.fontSize, weight: .semibold))
                }
            }
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .background(backgroundColor)
            .cornerRadius(CornerRadiusTokens.md)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTokens.md)
                    .stroke(borderColor, lineWidth: style == .outline ? 2 : 0)
            )
            .shadow(shadowStyle)
        }
        .disabled(isDisabled || isLoading)
        .opacity((isDisabled || isLoading) ? 0.5 : 1.0)
    }

    // MARK: - Style Helpers

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return ColorTokens.primary
        case .secondary:
            return ColorTokens.surface
        case .outline, .ghost:
            return Color.clear
        case .destructive:
            return ColorTokens.error
        }
    }

    private var textColor: Color {
        switch style {
        case .primary, .destructive:
            return .black
        case .secondary, .outline, .ghost:
            return ColorTokens.textPrimary
        }
    }

    private var borderColor: Color {
        switch style {
        case .outline:
            return ColorTokens.primary
        default:
            return Color.clear
        }
    }

    private var shadowStyle: ShadowStyle {
        switch style {
        case .primary:
            return ShadowTokens.glow
        case .secondary, .outline:
            return ShadowTokens.sm
        case .ghost, .destructive:
            return ShadowStyle(color: .clear, radius: 0, x: 0, y: 0)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: SpacingTokens.lg) {
        MapButton(title: "Primary Button", style: .primary) {}
        MapButton(title: "Secondary Button", style: .secondary) {}
        MapButton(title: "Outline Button", style: .outline) {}
        MapButton(title: "Ghost Button", style: .ghost) {}
        MapButton(title: "With Icon", icon: "plus", style: .primary) {}
        MapButton(title: "Loading", style: .primary, isLoading: true) {}
        MapButton(title: "Disabled", style: .primary, isDisabled: true) {}
        MapButton(title: "Small", style: .primary, size: .small) {}
        MapButton(title: "Large", style: .primary, size: .large) {}
        MapButton(title: "Destructive", style: .destructive) {}
    }
    .padding()
    .background(ColorTokens.background)
}
