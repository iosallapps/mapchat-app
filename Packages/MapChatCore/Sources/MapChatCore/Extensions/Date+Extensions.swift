//
//  Date+Extensions.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

extension Date {
    /// Check if date is today
    public var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Check if date is yesterday
    public var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// Check if date is in the past
    public var isPast: Bool {
        self < Date()
    }

    /// Check if date is in the future
    public var isFuture: Bool {
        self > Date()
    }

    /// Time ago string (e.g., "5m ago", "2h ago", "3d ago")
    public var timeAgoString: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: self, to: now)

        if let year = components.year, year > 0 {
            return year == 1 ? "1y ago" : "\(year)y ago"
        }
        if let month = components.month, month > 0 {
            return month == 1 ? "1mo ago" : "\(month)mo ago"
        }
        if let week = components.weekOfYear, week > 0 {
            return week == 1 ? "1w ago" : "\(week)w ago"
        }
        if let day = components.day, day > 0 {
            return day == 1 ? "1d ago" : "\(day)d ago"
        }
        if let hour = components.hour, hour > 0 {
            return hour == 1 ? "1h ago" : "\(hour)h ago"
        }
        if let minute = components.minute, minute > 0 {
            return minute == 1 ? "1m ago" : "\(minute)m ago"
        }

        return "Just now"
    }

    /// Formatted date string (e.g., "Jan 15, 2026")
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    /// Formatted time string (e.g., "3:45 PM")
    public var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// Formatted date and time (e.g., "Jan 15, 2026 at 3:45 PM")
    public var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// Smart formatted string (Today/Yesterday or date)
    public var smartFormatted: String {
        if isToday {
            return "Today at \(formattedTime)"
        } else if isYesterday {
            return "Yesterday at \(formattedTime)"
        } else {
            return formattedDateTime
        }
    }
}
