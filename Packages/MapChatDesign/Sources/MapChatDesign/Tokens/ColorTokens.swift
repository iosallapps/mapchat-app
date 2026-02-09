//
//  ColorTokens.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI

/// Color tokens for the design system
/// Supports both light and dark mode
public enum ColorTokens {
    // MARK: - Primary Colors

    /// Radiant Green (#00FF41) - Primary brand color
    public static let primary = Color("Primary", bundle: .module)

    /// Yellow (#FFD700) - Accent color
    public static let accent = Color("Accent", bundle: .module)

    // MARK: - Background Colors

    /// Main background - Black in dark, White in light
    public static let background = Color("Background", bundle: .module)

    /// Surface color - Dark Gray in dark, Light Gray in light
    public static let surface = Color("Surface", bundle: .module)

    /// Secondary surface
    public static let surfaceSecondary = Color("SurfaceSecondary", bundle: .module)

    // MARK: - Text Colors

    /// Primary text color
    public static let textPrimary = Color("TextPrimary", bundle: .module)

    /// Secondary text color
    public static let textSecondary = Color("TextSecondary", bundle: .module)

    /// Tertiary text color
    public static let textTertiary = Color("TextTertiary", bundle: .module)

    // MARK: - Semantic Colors

    /// Success color (green)
    public static let success = Color("Success", bundle: .module)

    /// Error color (red)
    public static let error = Color("Error", bundle: .module)

    /// Warning color (orange)
    public static let warning = Color("Warning", bundle: .module)

    /// Info color (blue)
    public static let info = Color("Info", bundle: .module)

    // MARK: - Border Colors

    /// Default border color
    public static let border = Color("Border", bundle: .module)

    /// Subtle border color
    public static let borderSubtle = Color("BorderSubtle", bundle: .module)

    // MARK: - Overlay Colors

    /// Dim overlay (for modals/sheets)
    public static let overlay = Color.black.opacity(0.4)

    /// Glow effect color
    public static let glow = primary.opacity(0.3)
}

// MARK: - Gradient Definitions

extension ColorTokens {
    /// Primary gradient (Green to Yellow)
    public static let primaryGradient = LinearGradient(
        colors: [primary, accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Dark gradient for backgrounds
    public static let darkGradient = LinearGradient(
        colors: [Color.black, Color(hex: "1A1A1A")],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Futuristic glow gradient
    public static let glowGradient = RadialGradient(
        colors: [primary.opacity(0.3), Color.clear],
        center: .center,
        startRadius: 0,
        endRadius: 100
    )
}

// MARK: - Color Extension

extension Color {
    /// Initialize color from hex string
    /// - Parameter hex: Hex string (e.g., "00FF41")
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
