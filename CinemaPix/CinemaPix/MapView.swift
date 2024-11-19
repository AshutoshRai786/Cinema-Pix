//
//  MapView.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 25/2/2024.
//

import CoreLocation
import SwiftUI
import MapKit

// Defines a view for displaying a map using a UIViewRepresentable.
struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView // Specifies the type of UIView being represented.
    @Binding var tappedLocation: CLLocationCoordinate2D? // Binding to track the tapped location on the map.
    @Binding var region: MKCoordinateRegion // Binding to track the current region of the map.
    
    @StateObject var locationManager = LocationManager() // State object to manage location updates.
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.showsUserLocation = true // Display the user's location on the map.
        
        // Add a tap gesture recognizer to the map.
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(MapViewCoordinator.tappedOnMap(_:)))
        
        mapView.addGestureRecognizer(tapGesture)
        mapView.region = region // Set the initial region of the map.
        
        return mapView
    }
    
    // Updates the MKMapView with new data or state changes.
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if uiView.delegate != nil { return }
        // if let userLocation = locationManager.userLocation {
            uiView.setRegion(.init(center: region.center, latitudinalMeters: 400, longitudinalMeters: 400), animated: false)
            
            uiView.delegate = context.coordinator
        // }
    }
    
    // Creates and returns the coordinator for handling map interactions.
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self, tappedLocation: $tappedLocation)
    }
}

// Coordinator class to handle map interactions and updates.
final class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var tappedLocation: Binding<CLLocationCoordinate2D?> // Binding to track the tapped location.
    var parent: MapView // Reference to the parent MapView.
    
    // Initializer to set up the coordinator with the parent view and tapped location binding.
    init(_ mapView: MapView, tappedLocation: Binding<CLLocationCoordinate2D?>) {
        self.parent = mapView
        self.tappedLocation = tappedLocation
    }

    // Handles tap gestures on the map.
    @objc func tappedOnMap(_ sender: UITapGestureRecognizer) {
        guard let mapView = sender.view as? MKMapView else { return }
        
        let touchLocation = sender.location(in: sender.view)
        
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: sender.view)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = .init(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        self.tappedLocation.wrappedValue = Optional(locationCoordinate)
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
}
