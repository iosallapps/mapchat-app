//
//  String+Extensions.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

extension String {
    /// Check if string is a valid email
    public var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    /// Check if string is a valid phone number (basic check)
    public var isValidPhoneNumber: Bool {
        let phoneRegex = "^[+]?[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self.replacingOccurrences(of: " ", with: ""))
    }

    /// Trimmed string (removing whitespace and newlines)
    public var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Check if string is empty or whitespace
    public var isBlank: Bool {
        trimmed.isEmpty
    }

    /// Truncate string to specified length with ellipsis
    /// - Parameters:
    ///   - length: Maximum length
    ///   - trailing: Trailing string (default "...")
    /// - Returns: Truncated string
    public func truncated(to length: Int, trailing: String = "...") -> String {
        if count > length {
            return String(prefix(length)) + trailing
        }
        return self
    }

    /// Initials from name (e.g., "John Doe" -> "JD")
    public var initials: String {
        let components = split(separator: " ")
        let initials = components.compactMap { $0.first }.map { String($0) }
        return initials.prefix(2).joined().uppercased()
    }
}
