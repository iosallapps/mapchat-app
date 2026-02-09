//
//  SearchBar.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI

/// Search bar component
public struct SearchBar: View {
    // MARK: - Properties

    @Binding var text: String
    let placeholder: String
    let onSubmit: (() -> Void)?
    let onCancel: (() -> Void)?

    @FocusState private var isFocused: Bool

    // MARK: - Initialization

    public init(
        text: Binding<String>,
        placeholder: String = "Search",
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: SpacingTokens.sm) {
            HStack(spacing: SpacingTokens.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorTokens.textSecondary)
                    .font(.system(size: TypographyTokens.sizeMD))

                TextField(placeholder, text: $text)
                    .font(TypographyTokens.body)
                    .foregroundColor(ColorTokens.textPrimary)
                    .focused($isFocused)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onSubmit {
                        onSubmit?()
                    }

                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorTokens.textSecondary)
                            .font(.system(size: TypographyTokens.sizeMD))
                    }
                }
            }
            .padding(.horizontal, SpacingTokens.md)
            .padding(.vertical, SpacingTokens.sm)
            .background(ColorTokens.surface)
            .cornerRadius(CornerRadiusTokens.md)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTokens.md)
                    .stroke(isFocused ? ColorTokens.primary : ColorTokens.borderSubtle, lineWidth: 2)
            )

            if isFocused {
                Button(action: {
                    text = ""
                    isFocused = false
                    onCancel?()
                }) {
                    Text("Cancel")
                        .font(TypographyTokens.body)
                        .foregroundColor(ColorTokens.primary)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var searchText = ""

        var body: some View {
            VStack(spacing: SpacingTokens.lg) {
                SearchBar(text: $searchText)

                SearchBar(
                    text: $searchText,
                    placeholder: "Search users..."
                )

                SearchBar(
                    text: .constant("Active search"),
                    placeholder: "Search"
                )
            }
            .padding()
            .background(ColorTokens.background)
        }
    }

    return PreviewWrapper()
}
