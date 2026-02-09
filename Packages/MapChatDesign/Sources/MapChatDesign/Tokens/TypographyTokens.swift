//
//  TypographyTokens.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI

/// Typography tokens for the design system
/// Uses SF Pro font family with custom weights and sizes
public enum TypographyTokens {
    // MARK: - Font Sizes

    /// Extra small: 12pt
    public static let sizeXS: CGFloat = 12

    /// Small: 14pt
    public static let sizeSM: CGFloat = 14

    /// Medium (base): 16pt
    public static let sizeMD: CGFloat = 16

    /// Large: 18pt
    public static let sizeLG: CGFloat = 18

    /// Extra large: 20pt
    public static let sizeXL: CGFloat = 20

    /// 2X large: 24pt
    public static let size2XL: CGFloat = 24

    /// 3X large: 32pt
    public static let size3XL: CGFloat = 32

    /// 4X large: 40pt
    public static let size4XL: CGFloat = 40

    // MARK: - Font Styles

    /// Large title (40pt, bold)
    public static let largeTitle = Font.system(size: size4XL, weight: .bold)

    /// Title 1 (32pt, bold)
    public static let title1 = Font.system(size: size3XL, weight: .bold)

    /// Title 2 (24pt, semibold)
    public static let title2 = Font.system(size: size2XL, weight: .semibold)

    /// Title 3 (20pt, semibold)
    public static let title3 = Font.system(size: sizeXL, weight: .semibold)

    /// Headline (18pt, semibold)
    public static let headline = Font.system(size: sizeLG, weight: .semibold)

    /// Body (16pt, regular)
    public static let body = Font.system(size: sizeMD, weight: .regular)

    /// Body bold (16pt, semibold)
    public static let bodyBold = Font.system(size: sizeMD, weight: .semibold)

    /// Callout (14pt, regular)
    public static let callout = Font.system(size: sizeSM, weight: .regular)

    /// Subheadline (14pt, medium)
    public static let subheadline = Font.system(size: sizeSM, weight: .medium)

    /// Footnote (12pt, regular)
    public static let footnote = Font.system(size: sizeXS, weight: .regular)

    /// Caption (12pt, medium)
    public static let caption = Font.system(size: sizeXS, weight: .medium)

    // MARK: - Line Heights

    /// Tight line height (1.2x)
    public static let lineHeightTight: CGFloat = 1.2

    /// Normal line height (1.5x)
    public static let lineHeightNormal: CGFloat = 1.5

    /// Relaxed line height (1.75x)
    public static let lineHeightRelaxed: CGFloat = 1.75

    // MARK: - Letter Spacing

    /// Tight letter spacing
    public static let letterSpacingTight: CGFloat = -0.5

    /// Normal letter spacing
    public static let letterSpacingNormal: CGFloat = 0

    /// Wide letter spacing
    public static let letterSpacingWide: CGFloat = 0.5
}

// MARK: - Font Weight Extension

extension Font.Weight {
    /// Ultra light
    public static let ultraLight = Font.Weight.ultraLight

    /// Thin
    public static let thin = Font.Weight.thin

    /// Light
    public static let light = Font.Weight.light

    /// Regular (default)
    public static let regular = Font.Weight.regular

    /// Medium
    public static let medium = Font.Weight.medium

    /// Semibold
    public static let semibold = Font.Weight.semibold

    /// Bold
    public static let bold = Font.Weight.bold

    /// Heavy
    public static let heavy = Font.Weight.heavy

    /// Black
    public static let black = Font.Weight.black
}
