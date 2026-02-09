//
//  TripViewModel.swift
//  MapChatFeatures
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import SwiftUI
import MapChatCore

/// View model for Trip management
/// Handles trip CRUD, group management, and filtering
@MainActor
@Observable
public final class TripViewModel {
    // MARK: - Published Properties

    public var trips: [Trip] = []
    public var activeTrips: [Trip] = []
    public var upcomingTrips: [Trip] = []
    public var pastTrips: [Trip] = []
    public var selectedTrip: Trip?
    public var isLoading = false
    public var errorMessage: String?
    public var searchText = ""

    // MARK: - Private Properties

    private let tripService: TripServiceProtocol
    private let groupService: GroupServiceProtocol
    private var currentUser: User?

    // MARK: - Initialization

    public init(
        tripService: TripServiceProtocol,
        groupService: GroupServiceProtocol
    ) {
        self.tripService = tripService
        self.groupService = groupService
    }

    // MARK: - Public Methods

    /// Load all trips for current user
    public func loadTrips() async {
        guard let user = currentUser else {
            errorMessage = "User not logged in"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            trips = try await tripService.fetchTrips(for: user)
            categorizeTrips()
        } catch {
            errorMessage = "Failed to load trips: \(error.localizedDescription)"
            print("❌ Load trips error: \(error)")
        }

        isLoading = false
    }

    /// Create a new trip
    /// - Parameter trip: Trip to create
    public func createTrip(_ trip: Trip) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let createdTrip = try await tripService.createTrip(trip)
            trips.append(createdTrip)
            categorizeTrips()
            print("✅ Trip created: \(createdTrip.name)")
            isLoading = false
            return true
        } catch {
            errorMessage = "Failed to create trip: \(error.localizedDescription)"
            print("❌ Create trip error: \(error)")
            isLoading = false
            return false
        }
    }

    /// Update existing trip
    /// - Parameter trip: Trip to update
    public func updateTrip(_ trip: Trip) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            try await tripService.updateTrip(trip)

            // Update in local array
            if let index = trips.firstIndex(where: { $0.id == trip.id }) {
                trips[index] = trip
            }
            categorizeTrips()
            print("✅ Trip updated: \(trip.name)")
            isLoading = false
            return true
        } catch {
            errorMessage = "Failed to update trip: \(error.localizedDescription)"
            print("❌ Update trip error: \(error)")
            isLoading = false
            return false
        }
    }

    /// Delete a trip
    /// - Parameter tripId: ID of trip to delete
    public func deleteTrip(id tripId: UUID) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            try await tripService.deleteTrip(id: tripId)

            // Remove from local array
            trips.removeAll { $0.id == tripId }
            categorizeTrips()
            print("✅ Trip deleted: \(tripId)")
            isLoading = false
            return true
        } catch {
            errorMessage = "Failed to delete trip: \(error.localizedDescription)"
            print("❌ Delete trip error: \(error)")
            isLoading = false
            return false
        }
    }

    /// Select a trip
    /// - Parameter trip: Trip to select
    public func selectTrip(_ trip: Trip?) {
        selectedTrip = trip
    }

    /// Filter trips by search text
    /// - Returns: Filtered trips
    public func filteredTrips() -> [Trip] {
        guard !searchText.isEmpty else { return trips }

        return trips.filter { trip in
            trip.name.localizedCaseInsensitiveContains(searchText) ||
            trip.locationName.localizedCaseInsensitiveContains(searchText)
        }
    }

    /// Set current user
    /// - Parameter user: Current user
    public func setCurrentUser(_ user: User) {
        currentUser = user
    }

    // MARK: - Private Methods

    private func categorizeTrips() {
        activeTrips = trips.filter { $0.isActive }
        upcomingTrips = trips.filter { $0.isUpcoming }
        pastTrips = trips.filter { $0.isPast }
    }
}

// MARK: - Group Management

extension TripViewModel {
    /// Create a group for a trip
    /// - Parameters:
    ///   - name: Group name
    ///   - members: Member user IDs
    ///   - adminId: Admin user ID
    /// - Returns: Created group
    public func createGroup(
        name: String,
        members: [UUID],
        adminId: UUID
    ) async -> Group? {
        let group = Group(
            name: name,
            adminId: adminId,
            memberIds: members
        )

        do {
            let createdGroup = try await groupService.createGroup(group)
            print("✅ Group created: \(createdGroup.name)")
            return createdGroup
        } catch {
            errorMessage = "Failed to create group: \(error.localizedDescription)"
            print("❌ Create group error: \(error)")
            return nil
        }
    }

    /// Fetch groups for current user
    /// - Returns: Array of groups
    public func fetchUserGroups() async -> [Group] {
        guard let user = currentUser else { return [] }

        do {
            return try await groupService.fetchGroups(for: user)
        } catch {
            errorMessage = "Failed to fetch groups: \(error.localizedDescription)"
            print("❌ Fetch groups error: \(error)")
            return []
        }
    }
}

// MARK: - Validation

extension TripViewModel {
    /// Validate trip data before creation
    /// - Parameter trip: Trip to validate
    /// - Returns: Validation result
    public func validateTrip(_ trip: Trip) -> (isValid: Bool, message: String?) {
        // Check name
        guard !trip.name.trimmed.isEmpty else {
            return (false, "Trip name is required")
        }

        // Check location
        guard !trip.locationName.trimmed.isEmpty else {
            return (false, "Location is required")
        }

        // Check dates
        guard trip.startDate < trip.endDate else {
            return (false, "End date must be after start date")
        }

        // Check if dates are in the future (for new trips)
        guard trip.startDate >= Date() || trip.isPast else {
            return (false, "Start date must be in the future")
        }

        return (true, nil)
    }
}

// MARK: - Preview

#if DEBUG
extension TripViewModel {
    public static var preview: TripViewModel {
        let vm = TripViewModel(
            tripService: MockTripService(),
            groupService: MockGroupService()
        )
        vm.trips = Trip.samples
        vm.categorizeTrips()
        return vm
    }
}

private class MockTripService: TripServiceProtocol {
    func createTrip(_ trip: Trip) async throws -> Trip { trip }
    func updateTrip(_ trip: Trip) async throws {}
    func deleteTrip(id: UUID) async throws {}
    func fetchTrips(for user: User) async throws -> [Trip] { Trip.samples }
    func fetchActiveTrips() async throws -> [Trip] { [] }
    func fetchTrip(id: UUID) async throws -> Trip { Trip.sample }
}

private class MockGroupService: GroupServiceProtocol {
    func createGroup(_ group: Group) async throws -> Group { group }
    func updateGroup(_ group: Group) async throws {}
    func deleteGroup(id: UUID) async throws {}
    func addMember(_ userId: UUID, to groupId: UUID) async throws {}
    func removeMember(_ userId: UUID, from groupId: UUID) async throws {}
    func promoteToAdmin(_ userId: UUID, in groupId: UUID) async throws {}
    func fetchGroups(for user: User) async throws -> [Group] { Group.samples }
}
#endif
