//
//  TripService.swift
//  MapChatServices
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import MapChatCore

/// Trip service implementation using Firestore
public actor TripService: TripServiceProtocol {
    // MARK: - Properties

    private let firestoreManager = FirestoreManager.shared
    private let collection = FirestoreManager.Collection.trips

    // MARK: - Initialization

    public init() {}

    // MARK: - Public Methods

    public func createTrip(_ trip: Trip) async throws -> Trip {
        var newTrip = trip

        // Generate ID if not provided
        if trip.id == UUID(uuidString: "00000000-0000-0000-0000-000000000000") {
            newTrip = Trip(
                id: UUID(),
                name: trip.name,
                locationName: trip.locationName,
                coordinate: trip.coordinate,
                startDate: trip.startDate,
                endDate: trip.endDate,
                groupId: trip.groupId,
                adminId: trip.adminId,
                description: trip.description,
                imageURL: trip.imageURL
            )
        }

        // Validate trip
        try validateTrip(newTrip)

        // Save to Firestore
        try await firestoreManager.setDocument(
            newTrip,
            in: collection,
            documentId: newTrip.id.uuidString
        )

        print("✅ Trip created: \(newTrip.name)")
        return newTrip
    }

    public func updateTrip(_ trip: Trip) async throws {
        // Validate trip
        try validateTrip(trip)

        // Update in Firestore
        try await firestoreManager.setDocument(
            trip,
            in: collection,
            documentId: trip.id.uuidString
        )

        print("✅ Trip updated: \(trip.name)")
    }

    public func deleteTrip(id: UUID) async throws {
        // Delete from Firestore
        try await firestoreManager.deleteDocument(
            from: collection,
            documentId: id.uuidString
        )

        print("✅ Trip deleted: \(id)")
    }

    public func fetchTrips(for user: User) async throws -> [Trip] {
        // Query trips where user is in the group
        // For now, return empty array
        // TODO: Implement proper Firestore query
        return []
    }

    public func fetchActiveTrips() async throws -> [Trip] {
        // Query trips where current date is between start and end
        // TODO: Implement Firestore query with date filters
        return []
    }

    public func fetchTrip(id: UUID) async throws -> Trip {
        guard let trip: Trip = try await firestoreManager.getDocument(
            from: collection,
            documentId: id.uuidString
        ) else {
            throw TripError.notFound
        }

        return trip
    }

    // MARK: - Validation

    private func validateTrip(_ trip: Trip) throws {
        // Validate name
        guard !trip.name.trimmed.isEmpty else {
            throw TripError.invalidData
        }

        // Validate dates
        guard trip.startDate < trip.endDate else {
            throw TripError.invalidData
        }

        // Validate location
        guard !trip.locationName.trimmed.isEmpty else {
            throw TripError.invalidData
        }
    }
}

// MARK: - Real-time Updates

extension TripService {
    /// Listen to trip changes
    /// - Parameter tripId: Trip identifier
    /// - Returns: AsyncStream of trip updates
    public func listenToTrip(id: UUID) -> AsyncStream<Trip?> {
        firestoreManager.listenToDocument(
            from: collection,
            documentId: id.uuidString
        )
    }

    /// Listen to all trips for a user
    /// - Parameter userId: User identifier
    /// - Returns: AsyncStream of trip arrays
    public func listenToUserTrips(userId: UUID) -> AsyncStream<[Trip]> {
        // TODO: Filter by user's groups
        firestoreManager.listenToCollection(from: collection)
    }
}
