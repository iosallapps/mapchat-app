//
//  UUID+Extensions.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

extension UUID {
    /// Short string representation (first 8 characters)
    public var shortString: String {
        String(uuidString.prefix(8))
    }

    /// Check if UUID is valid
    public var isValid: Bool {
        !uuidString.isEmpty && uuidString.count == 36
    }
}
