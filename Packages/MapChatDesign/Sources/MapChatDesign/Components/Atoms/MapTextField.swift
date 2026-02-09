//
//  MapTextField.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI

/// Text field variant
public enum TextFieldVariant {
    case standard
    case search
    case secure
}

/// Custom text field component
public struct MapTextField: View {
    // MARK: - Properties

    let placeholder: String
    @Binding var text: String
    let icon: String?
    let variant: TextFieldVariant
    let errorMessage: String?
    let isDisabled: Bool

    @FocusState private var isFocused: Bool

    // MARK: - Initialization

    public init(
        placeholder: String,
        text: Binding<String>,
        icon: String? = nil,
        variant: TextFieldVariant = .standard,
        errorMessage: String? = nil,
        isDisabled: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.variant = variant
        self.errorMessage = errorMessage
        self.isDisabled = isDisabled
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.xs) {
            HStack(spacing: SpacingTokens.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: TypographyTokens.sizeMD))
                }

                textFieldContent
            }
            .padding(.horizontal, SpacingTokens.md)
            .padding(.vertical, SpacingTokens.sm)
            .background(backgroundColor)
            .cornerRadius(CornerRadiusTokens.md)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTokens.md)
                    .stroke(borderColor, lineWidth: 2)
            )

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.error)
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var textFieldContent: some View {
        switch variant {
        case .standard, .search:
            TextField(placeholder, text: $text)
                .font(TypographyTokens.body)
                .foregroundColor(ColorTokens.textPrimary)
                .focused($isFocused)
                .disabled(isDisabled)
                .autocorrectionDisabled()
                .textInputAutocapitalization(variant == .search ? .never : .sentences)

        case .secure:
            SecureField(placeholder, text: $text)
                .font(TypographyTokens.body)
                .foregroundColor(ColorTokens.textPrimary)
                .focused($isFocused)
                .disabled(isDisabled)
        }
    }

    // MARK: - Style Helpers

    private var backgroundColor: Color {
        isDisabled ? ColorTokens.surface.opacity(0.5) : ColorTokens.surface
    }

    private var borderColor: Color {
        if errorMessage != nil {
            return ColorTokens.error
        } else if isFocused {
            return ColorTokens.primary
        } else {
            return ColorTokens.borderSubtle
        }
    }

    private var iconColor: Color {
        if errorMessage != nil {
            return ColorTokens.error
        } else if isFocused {
            return ColorTokens.primary
        } else {
            return ColorTokens.textSecondary
        }
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var text1 = ""
        @State private var text2 = "Hello"
        @State private var text3 = ""
        @State private var text4 = ""

        var body: some View {
            VStack(spacing: SpacingTokens.lg) {
                MapTextField(
                    placeholder: "Enter your name",
                    text: $text1,
                    icon: "person.fill"
                )

                MapTextField(
                    placeholder: "Search",
                    text: $text2,
                    icon: "magnifyingglass",
                    variant: .search
                )

                MapTextField(
                    placeholder: "Password",
                    text: $text3,
                    icon: "lock.fill",
                    variant: .secure
                )

                MapTextField(
                    placeholder: "Email",
                    text: $text4,
                    icon: "envelope.fill",
                    errorMessage: "Invalid email address"
                )

                MapTextField(
                    placeholder: "Disabled",
                    text: $text1,
                    isDisabled: true
                )
            }
            .padding()
            .background(ColorTokens.background)
        }
    }

    return PreviewWrapper()
}
