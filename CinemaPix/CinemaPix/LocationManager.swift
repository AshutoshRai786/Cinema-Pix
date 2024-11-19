//
//  LocationManager.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 25/2/2024.
//

// Import the CoreLocation framework to use location services.
import CoreLocation

// Define a final class LocationManager to manage location updates and permissions.
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Initialize a CLLocationManager instance to handle location services.
    private let locationManager = CLLocationManager()
    
    // Published property to store and update the user's location.
    @Published var userLocation: CLLocationCoordinate2D?
    
    // Initializer to set up the location manager and its delegate.
    override init() {
        super.init()
        
        // Set the delegate to self to handle location updates and permissions.
        locationManager.delegate = self
        // Set the desired accuracy for location updates to the best available.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Request permission to use location services when the app is in use.
        locationManager.requestWhenInUseAuthorization()
        // Start updating the location to get the user's current location.
        locationManager.startUpdatingLocation()
    }
    
    // Delegate method called when the location manager updates locations.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Ensure there is at least one location update.
        guard let location = locations.last else { return }
        
        // Update the userLocation property with the new location's coordinates.
        userLocation = location.coordinate
        
    }
}
