//
//  UserLocation.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import CoreLocation

/// User location model
public struct UserLocation: Codable, Hashable, Sendable {
    /// Associated user ID
    public let userId: UUID

    /// Latitude coordinate
    public let latitude: Double

    /// Longitude coordinate
    public let longitude: Double

    /// Altitude (optional)
    public let altitude: Double?

    /// Horizontal accuracy in meters
    public let horizontalAccuracy: Double

    /// Vertical accuracy in meters (optional)
    public let verticalAccuracy: Double?

    /// Timestamp of location update
    public let timestamp: Date

    /// Associated trip ID (optional)
    public let tripId: UUID?

    // MARK: - Initialization

    public init(
        userId: UUID,
        latitude: Double,
        longitude: Double,
        altitude: Double? = nil,
        horizontalAccuracy: Double,
        verticalAccuracy: Double? = nil,
        timestamp: Date = Date(),
        tripId: UUID? = nil
    ) {
        self.userId = userId
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
        self.timestamp = timestamp
        self.tripId = tripId
    }

    /// Initialize from CLLocation
    /// - Parameters:
    ///   - userId: User identifier
    ///   - location: CoreLocation object
    ///   - tripId: Optional trip identifier
    public init(userId: UUID, from location: CLLocation, tripId: UUID? = nil) {
        self.userId = userId
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.horizontalAccuracy = location.horizontalAccuracy
        self.verticalAccuracy = location.verticalAccuracy
        self.timestamp = location.timestamp
        self.tripId = tripId
    }

    // MARK: - Computed Properties

    /// Convert to CLLocationCoordinate2D
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// Convert to CLLocation
    public var clLocation: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: altitude ?? 0,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: verticalAccuracy ?? 0,
            timestamp: timestamp
        )
    }

    /// Check if location is recent (within last 5 minutes)
    public var isRecent: Bool {
        Date().timeIntervalSince(timestamp) < 300 // 5 minutes
    }

    /// Check if location is accurate (< 50m)
    public var isAccurate: Bool {
        horizontalAccuracy < 50
    }
}

// MARK: - Distance Calculations

extension UserLocation {
    /// Calculate distance to another location
    /// - Parameter other: Other location
    /// - Returns: Distance in meters
    public func distance(to other: UserLocation) -> Double {
        clLocation.distance(from: other.clLocation)
    }

    /// Calculate distance to coordinate
    /// - Parameter coordinate: Target coordinate
    /// - Returns: Distance in meters
    public func distance(to coordinate: CLLocationCoordinate2D) -> Double {
        let target = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return clLocation.distance(from: target)
    }

    /// Format distance for display
    /// - Parameter distance: Distance in meters
    /// - Returns: Formatted string
    public static func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            return String(format: "%.1f km", distance / 1000)
        }
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension UserLocation {
    /// Sample location (San Francisco)
    public static var sample: UserLocation {
        UserLocation(
            userId: UUID(),
            latitude: 37.7749,
            longitude: -122.4194,
            horizontalAccuracy: 10
        )
    }
}
#endif
