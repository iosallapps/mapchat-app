//
//  TripServiceProtocol.swift
//  MapChatCore
//
//  Created by Claude on 09.02.2026.
//

import Foundation

/// Trip-related errors
public enum TripError: LocalizedError, Sendable {
    case notFound
    case invalidData
    case permissionDenied
    case conflictDetected
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "Trip not found"
        case .invalidData:
            return "Invalid trip data"
        case .permissionDenied:
            return "Permission denied"
        case .conflictDetected:
            return "Conflict detected, please try again"
        case .unknown(let message):
            return "Trip error: \(message)"
        }
    }
}

/// Protocol defining trip service contract
public protocol TripServiceProtocol: Sendable {
    /// Create a new trip
    /// - Parameter trip: Trip to create
    /// - Returns: Created trip with ID
    /// - Throws: TripError if creation fails
    func createTrip(_ trip: Trip) async throws -> Trip

    /// Update existing trip
    /// - Parameter trip: Trip to update
    /// - Throws: TripError if update fails
    func updateTrip(_ trip: Trip) async throws

    /// Delete trip
    /// - Parameter id: Trip identifier
    /// - Throws: TripError if deletion fails
    func deleteTrip(id: UUID) async throws

    /// Fetch trips for user
    /// - Parameter user: User to fetch trips for
    /// - Returns: Array of trips
    /// - Throws: TripError if fetch fails
    func fetchTrips(for user: User) async throws -> [Trip]

    /// Fetch active trips
    /// - Returns: Array of active trips
    /// - Throws: TripError if fetch fails
    func fetchActiveTrips() async throws -> [Trip]

    /// Fetch trip by ID
    /// - Parameter id: Trip identifier
    /// - Returns: Trip if found
    /// - Throws: TripError if fetch fails
    func fetchTrip(id: UUID) async throws -> Trip
}
