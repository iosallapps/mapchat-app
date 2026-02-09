//
//  LocationServiceProtocol.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import CoreLocation

/// Location permission status
public enum LocationPermissionStatus: Sendable {
    case notDetermined
    case restricted
    case denied
    case authorizedWhenInUse
    case authorizedAlways
}

/// Location tracking mode
public enum LocationTrackingMode: Sendable {
    case disabled
    case whenInUse
    case always
}

/// Location errors
public enum LocationError: LocalizedError, Sendable {
    case permissionDenied
    case locationServicesDisabled
    case failedToGetLocation
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission denied"
        case .locationServicesDisabled:
            return "Location services are disabled"
        case .failedToGetLocation:
            return "Failed to get current location"
        case .unknown(let message):
            return "Location error: \(message)"
        }
    }
}

/// Protocol defining location service contract
public protocol LocationServiceProtocol: Sendable {
    /// Current location permission status
    var permissionStatus: LocationPermissionStatus { get async }

    /// Current user location
    var currentLocation: UserLocation? { get async }

    /// Request location permission
    /// - Parameter type: When in use or always
    /// - Throws: LocationError if permission request fails
    func requestPermission(_ type: LocationTrackingMode) async throws

    /// Start tracking user location
    /// - Throws: LocationError if tracking cannot start
    func startTracking() async throws

    /// Stop tracking user location
    func stopTracking() async

    /// Get current location once
    /// - Returns: Current user location
    /// - Throws: LocationError if location cannot be determined
    func getCurrentLocation() async throws -> UserLocation

    /// Update location for user in backend
    /// - Parameter location: Location to update
    /// - Throws: LocationError if update fails
    func updateLocation(_ location: UserLocation) async throws
}
