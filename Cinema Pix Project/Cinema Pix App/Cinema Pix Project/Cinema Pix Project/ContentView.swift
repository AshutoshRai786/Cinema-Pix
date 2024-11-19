//
//  ContentView.swift
//  Cinema Pix Project
//
//  Created by Ashutosh Rai on 14/5/2024.
//
import MapKit
import SwiftUI
import CoreLocation

struct ContentView: View {
    
    let locationManager = CLLocationManager()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.required
    }
}
