//
//  LocationService.swift
//  MapChatServices
//
//  Created by Claude on 09.02.2026.
//

import Foundation
import CoreLocation
import MapChatCore

/// Location service implementation with CoreLocation
/// Handles real-time location tracking with battery optimization
public actor LocationService: NSObject, LocationServiceProtocol {
    // MARK: - Properties

    private let locationManager = CLLocationManager()
    private var continuation: AsyncStream<UserLocation>.Continuation?
    private var userId: UUID?

    private var _permissionStatus: LocationPermissionStatus = .notDetermined
    private var _currentLocation: UserLocation?
    private var _isTracking = false

    // MARK: - Public Properties

    public var permissionStatus: LocationPermissionStatus {
        get async {
            _permissionStatus
        }
    }

    public var currentLocation: UserLocation? {
        get async {
            _currentLocation
        }
    }

    // MARK: - Initialization

    public override init() {
        super.init()
        Task {
            await setupLocationManager()
        }
    }

    // MARK: - Public Methods

    public func requestPermission(_ type: LocationTrackingMode) async throws {
        switch type {
        case .disabled:
            await stopTracking()

        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()

        case .always:
            locationManager.requestAlwaysAuthorization()
        }

        // Update permission status
        await updatePermissionStatus()
    }

    public func startTracking() async throws {
        guard !_isTracking else { return }

        // Check permission
        let status = await permissionStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            throw LocationError.permissionDenied
        }

        _isTracking = true

        // Start location updates
        locationManager.startUpdatingLocation()

        // Start significant location change monitoring (battery efficient)
        locationManager.startMonitoringSignificantLocationChanges()

        print("📍 Started location tracking")
    }

    public func stopTracking() async {
        guard _isTracking else { return }

        _isTracking = false
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()

        print("📍 Stopped location tracking")
    }

    public func getCurrentLocation() async throws -> UserLocation {
        // Request one-time location
        locationManager.requestLocation()

        // Wait for location update
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds timeout

        guard let location = _currentLocation else {
            throw LocationError.failedToGetLocation
        }

        return location
    }

    public func updateLocation(_ location: UserLocation) async throws {
        // TODO: Update location in Firestore
        // let db = Firestore.firestore()
        // let locationData = try Firestore.Encoder().encode(location)
        // try await db.collection("locations").document(location.userId.uuidString)
        //     .setData(locationData, merge: true)

        print("📍 Updated location: \(location.latitude), \(location.longitude)")
    }

    // MARK: - Private Methods

    private func setupLocationManager() async {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50 // Update every 50 meters
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .other
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true

        await updatePermissionStatus()
    }

    private func updatePermissionStatus() async {
        let status: CLAuthorizationStatus

        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }

        _permissionStatus = mapAuthorizationStatus(status)
    }

    private func mapAuthorizationStatus(_ status: CLAuthorizationStatus) -> LocationPermissionStatus {
        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorizedWhenInUse:
            return .authorizedWhenInUse
        case .authorizedAlways:
            return .authorizedAlways
        @unknown default:
            return .notDetermined
        }
    }

    private func updateCurrentLocation(_ location: CLLocation) async {
        guard let userId = userId else {
            // Generate temporary user ID if not set
            self.userId = UUID()
            return
        }

        let userLocation = UserLocation(userId: userId, from: location)
        _currentLocation = userLocation

        // Upload to backend
        try? await updateLocation(userLocation)

        // Notify continuation if streaming
        continuation?.yield(userLocation)
    }

    // MARK: - Location Streaming

    public func locationStream() -> AsyncStream<UserLocation> {
        AsyncStream { continuation in
            self.continuation = continuation

            continuation.onTermination = { @Sendable _ in
                Task {
                    await self.stopTracking()
                }
            }
        }
    }

    // MARK: - User ID Management

    public func setUserId(_ id: UUID) async {
        userId = id
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    nonisolated public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        Task {
            await updateCurrentLocation(location)
        }
    }

    nonisolated public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("❌ Location error: \(error.localizedDescription)")
    }

    nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task {
            await updatePermissionStatus()
        }
    }
}

// MARK: - Battery Optimization

extension LocationService {
    /// Adjust location accuracy based on device state
    private func optimizeForBatteryLevel() async {
        // TODO: Check battery level
        // let batteryLevel = UIDevice.current.batteryLevel

        // Adjust accuracy based on battery
        // if batteryLevel < 0.2 {
        //     locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        // } else if batteryLevel < 0.5 {
        //     locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // } else {
        //     locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // }
    }

    /// Adjust update frequency based on movement
    private func adjustUpdateFrequency(speed: Double) async {
        // Fast movement (driving): Update every 30 seconds
        if speed > 15 { // ~54 km/h
            locationManager.distanceFilter = 500
        }
        // Walking: Update every minute
        else if speed > 1 { // ~3.6 km/h
            locationManager.distanceFilter = 100
        }
        // Stationary: Update every 5 minutes
        else {
            locationManager.distanceFilter = 50
        }
    }
}
