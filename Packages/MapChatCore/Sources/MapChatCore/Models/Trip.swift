//
//  Trip.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import CoreLocation

/// Trip model representing a travel session
public struct Trip: Identifiable, Codable, Hashable, Sendable {
    /// Unique identifier
    public let id: UUID

    /// Trip name
    public var name: String

    /// Trip location name
    public var locationName: String

    /// Trip coordinates
    public var coordinate: Coordinate

    /// Start date
    public var startDate: Date

    /// End date
    public var endDate: Date

    /// Associated group ID
    public var groupId: UUID

    /// Trip admin (creator)
    public let adminId: UUID

    /// Creation date
    public let createdAt: Date

    /// Last update date
    public var updatedAt: Date

    /// Trip description (optional)
    public var description: String?

    /// Trip image URL (optional)
    public var imageURL: URL?

    // MARK: - Initialization

    public init(
        id: UUID = UUID(),
        name: String,
        locationName: String,
        coordinate: Coordinate,
        startDate: Date,
        endDate: Date,
        groupId: UUID,
        adminId: UUID,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        description: String? = nil,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.locationName = locationName
        self.coordinate = coordinate
        self.startDate = startDate
        self.endDate = endDate
        self.groupId = groupId
        self.adminId = adminId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.description = description
        self.imageURL = imageURL
    }

    // MARK: - Computed Properties

    /// Check if trip is currently active
    public var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }

    /// Check if trip is upcoming
    public var isUpcoming: Bool {
        Date() < startDate
    }

    /// Check if trip is past
    public var isPast: Bool {
        Date() > endDate
    }

    /// Trip duration in days
    public var durationDays: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }

    /// Formatted date range
    public var dateRangeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }

    /// Status text
    public var statusText: String {
        if isActive {
            return "Active"
        } else if isUpcoming {
            return "Upcoming"
        } else {
            return "Completed"
        }
    }
}

// MARK: - Coordinate Model

/// Coordinate model for Trip location
public struct Coordinate: Codable, Hashable, Sendable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    public init(from coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    public var clLocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension Trip {
    /// Sample trip for previews
    public static var sample: Trip {
        Trip(
            name: "Paris Vacation",
            locationName: "Paris, France",
            coordinate: Coordinate(latitude: 48.8566, longitude: 2.3522),
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            groupId: UUID(),
            adminId: UUID()
        )
    }

    /// Array of sample trips
    public static var samples: [Trip] {
        [
            Trip(
                name: "Tokyo Adventure",
                locationName: "Tokyo, Japan",
                coordinate: Coordinate(latitude: 35.6762, longitude: 139.6503),
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
                groupId: UUID(),
                adminId: UUID()
            ),
            Trip(
                name: "NYC Trip",
                locationName: "New York, USA",
                coordinate: Coordinate(latitude: 40.7128, longitude: -74.0060),
                startDate: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
                endDate: Calendar.current.date(byAdding: .month, value: 1, to: Date().addingTimeInterval(5 * 86400))!,
                groupId: UUID(),
                adminId: UUID()
            )
        ]
    }
}
#endif
