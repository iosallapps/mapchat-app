//
//  SpacingTokens.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI

/// Spacing tokens for the design system
/// Uses 4pt base grid system
public enum SpacingTokens {
    /// Extra extra small: 2pt
    public static let xxs: CGFloat = 2

    /// Extra small: 4pt
    public static let xs: CGFloat = 4

    /// Small: 8pt
    public static let sm: CGFloat = 8

    /// Medium: 12pt
    public static let md: CGFloat = 12

    /// Large: 16pt
    public static let lg: CGFloat = 16

    /// Extra large: 20pt
    public static let xl: CGFloat = 20

    /// 2X large: 24pt
    public static let xxl: CGFloat = 24

    /// 3X large: 32pt
    public static let xxxl: CGFloat = 32

    /// 4X large: 40pt
    public static let xxxxl: CGFloat = 40

    /// 5X large: 48pt
    public static let xxxxxl: CGFloat = 48
}

/// Corner radius tokens
public enum CornerRadiusTokens {
    /// Extra small: 4pt
    public static let xs: CGFloat = 4

    /// Small: 8pt
    public static let sm: CGFloat = 8

    /// Medium: 12pt
    public static let md: CGFloat = 12

    /// Large: 16pt
    public static let lg: CGFloat = 16

    /// Extra large: 20pt
    public static let xl: CGFloat = 20

    /// 2X large: 24pt
    public static let xxl: CGFloat = 24

    /// Circle (max radius)
    public static let circle: CGFloat = 9999
}

/// Shadow tokens
public enum ShadowTokens {
    /// Small shadow
    public static let sm = ShadowStyle(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

    /// Medium shadow
    public static let md = ShadowStyle(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)

    /// Large shadow
    public static let lg = ShadowStyle(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)

    /// Glow shadow (for futuristic effect)
    public static let glow = ShadowStyle(color: ColorTokens.primary.opacity(0.5), radius: 12, x: 0, y: 0)
}

/// Shadow style helper
public struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - View Extensions

extension View {
    /// Apply shadow style
    /// - Parameter style: Shadow style to apply
    /// - Returns: View with shadow
    public func shadow(_ style: ShadowStyle) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}
