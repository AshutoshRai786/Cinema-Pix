//
//  ContentViewModel.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 23/2/2024.
//

// ContentViewModel.swift

import MapKit

// Define the ViewModel class for managing the map's data and state.
final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    let standardSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) // Standard span for the map region to control the zoom level.
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)) // Published property to store and update the current region of the map.
    private var locationManager: CLLocationManager? // Private property to manage the device's location services.
    
    // Initializer to set up the location manager and its delegate.
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization() // Proceed to check authorization status if services are enabled.
        } else {
            // Handle the case where location services are not enabled.
        }
    }
    
    // Function to handle the authorization status of location services.
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // Request permission to use location services.
        case .restricted, .denied:
            // Handle cases where location services are restricted or denied.
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation() // Start updating location when authorized.
        @unknown default:
            break
        }
    }
    
    // Delegate method called when the location manager updates locations.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return } // Ensure there's at least one location.
        DispatchQueue.main.async {
            // Update the map region to center on the new location.
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
    
    // Delegate method called when the authorization status of location services changes.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization() // Re-check authorization whenever it changes.
    }
}
