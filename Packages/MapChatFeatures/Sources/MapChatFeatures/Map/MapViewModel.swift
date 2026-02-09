//
//  MapViewModel.swift
//  MapChatFeatures
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import SwiftUI
import MapChatCore
import MapChatServices

/// View model for Map feature
/// Manages location tracking, user pins, and group filtering
@MainActor
@Observable
public final class MapViewModel {
    // MARK: - Published Properties

    public var userLocations: [UserLocation] = []
    public var selectedGroup: Group?
    public var availableGroups: [Group] = []
    public var isLoading = false
    public var errorMessage: String?
    public var isTrackingLocation = false

    // MARK: - Private Properties

    private let locationService: LocationServiceProtocol
    private let groupService: GroupServiceProtocol
    private var locationUpdateTask: Task<Void, Never>?

    // MARK: - Initialization

    public init(
        locationService: LocationServiceProtocol,
        groupService: GroupServiceProtocol
    ) {
        self.locationService = locationService
        self.groupService = groupService
    }

    // MARK: - Public Methods

    /// Start location tracking
    public func startTracking() async {
        isLoading = true
        errorMessage = nil

        do {
            // Request location permission if needed
            let status = await locationService.permissionStatus
            if status == .notDetermined {
                try await locationService.requestPermission(.always)
            }

            // Start tracking
            try await locationService.startTracking()
            isTrackingLocation = true

            // Start listening to location updates
            startLocationUpdates()

            print("📍 Location tracking started")
        } catch {
            errorMessage = "Failed to start location tracking: \(error.localizedDescription)"
            print("❌ Location tracking error: \(error)")
        }

        isLoading = false
    }

    /// Stop location tracking
    public func stopTracking() async {
        await locationService.stopTracking()
        locationUpdateTask?.cancel()
        isTrackingLocation = false
        print("📍 Location tracking stopped")
    }

    /// Load available groups
    public func loadGroups() async {
        isLoading = true

        // TODO: Fetch user's groups
        // For now, use sample data
        availableGroups = Group.samples

        isLoading = false
    }

    /// Select a group to filter locations
    /// - Parameter group: Group to select (nil for all)
    public func selectGroup(_ group: Group?) {
        selectedGroup = group
        filterLocations()
    }

    /// Refresh user locations
    public func refreshLocations() async {
        isLoading = true

        // TODO: Fetch locations from Firestore
        // Filter by selected group if any
        // For now, use sample data
        userLocations = [.sample]

        isLoading = false
    }

    /// Open external navigation app
    /// - Parameters:
    ///   - location: Destination location
    ///   - app: Navigation app to use
    public func openNavigation(to location: UserLocation, using app: NavigationApp) {
        app.openDirections(to: location.coordinate)
    }

    // MARK: - Private Methods

    private func startLocationUpdates() {
        locationUpdateTask = Task {
            // TODO: Listen to location stream from service
            // for await location in locationService.locationStream() {
            //     await handleLocationUpdate(location)
            // }
        }
    }

    private func handleLocationUpdate(_ location: UserLocation) async {
        // Update current user's location in array
        if let index = userLocations.firstIndex(where: { $0.userId == location.userId }) {
            userLocations[index] = location
        } else {
            userLocations.append(location)
        }

        // Upload to Firestore
        do {
            try await locationService.updateLocation(location)
        } catch {
            print("❌ Failed to update location: \(error)")
        }
    }

    private func filterLocations() {
        guard let group = selectedGroup else {
            // Show all locations
            return
        }

        // Filter locations by group members
        userLocations = userLocations.filter { location in
            group.isMember(location.userId)
        }
    }
}

// MARK: - Navigation App Enum

public enum NavigationApp: String, CaseIterable {
    case waze
    case appleMaps
    case googleMaps

    var title: String {
        switch self {
        case .waze: return "Waze"
        case .appleMaps: return "Apple Maps"
        case .googleMaps: return "Google Maps"
        }
    }

    var icon: String {
        switch self {
        case .waze: return "car.fill"
        case .appleMaps: return "map.fill"
        case .googleMaps: return "map.circle.fill"
        }
    }

    func openDirections(to coordinate: CLLocationCoordinate2D) {
        let lat = coordinate.latitude
        let lon = coordinate.longitude

        var urlString: String

        switch self {
        case .waze:
            urlString = "waze://?ll=\(lat),\(lon)&navigate=yes"
        case .appleMaps:
            urlString = "http://maps.apple.com/?daddr=\(lat),\(lon)"
        case .googleMaps:
            urlString = "comgooglemaps://?daddr=\(lat),\(lon)&directionsmode=driving"
        }

        guard let url = URL(string: urlString) else { return }

        // TODO: Open URL
        // UIApplication.shared.open(url)
        print("🗺️ Opening navigation: \(title)")
    }
}

// MARK: - Sample Data

#if DEBUG
extension MapViewModel {
    public static var preview: MapViewModel {
        MapViewModel(
            locationService: MockLocationService(),
            groupService: MockGroupService()
        )
    }
}

// Mock services for preview
private class MockLocationService: LocationServiceProtocol {
    var permissionStatus: LocationPermissionStatus {
        get async { .authorizedAlways }
    }

    var currentLocation: UserLocation? {
        get async { .sample }
    }

    func requestPermission(_ type: LocationTrackingMode) async throws {}
    func startTracking() async throws {}
    func stopTracking() async {}
    func getCurrentLocation() async throws -> UserLocation { .sample }
    func updateLocation(_ location: UserLocation) async throws {}
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
