//
//  LookAroundView.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 25/2/2024.
//

// Import necessary frameworks for map and UI functionalities.
import MapKit
import SwiftUI

// Defines a view for displaying Look Around features using a UIViewControllerRepresentable.
struct LookAroundView: UIViewControllerRepresentable {
    
    // Type alias to specify the type of UIViewController being represented.
    typealias UIViewControllerType = MKLookAroundViewController
    
    // Binding properties to manage the tapped location and visibility of the Look Around view.
    @Binding var tappedLocation: CLLocationCoordinate2D?
    @Binding var showLookAroundView: Bool
    
    // Creates and returns the MKLookAroundViewController.
    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        return MKLookAroundViewController()
    }
    
    // Updates the MKLookAroundViewController with new data or state changes.
    func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
        if let tappedLocation {
            Task {
                if let scene = await getScene(tappedLocation: .init(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude)) {
                    withAnimation {
                        self.showLookAroundView = true
                        uiViewController.scene = scene
                    }
                } else {
                    withAnimation {
                        self.showLookAroundView = false
                    }
                    return
                }
            }
        }
    }
    
    // Asynchronously fetches the Look Around scene for the given location.
    func getScene(tappedLocation: CLLocationCoordinate2D?) async -> MKLookAroundScene? {
        if let lat = tappedLocation?.latitude, let long = tappedLocation?.longitude {
            let sceneRequest = MKLookAroundSceneRequest(coordinate: .init(latitude: lat, longitude: long))
            
            do {
                return try await sceneRequest.scene
            } catch {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
}
