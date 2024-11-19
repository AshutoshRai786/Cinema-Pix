//
//  ContentView.swift
//  TestTestTest
//
//  Created by Ashutosh Rai on 13/7/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var locationManager = CLLocationManager()
    @State private var selectedResult: MKMapItem?
    @State private var position: MapCameraPosition = .automatic
    
    let mapStyles = ["Standard", "Hybride", "Satellite"]
    
    @State private var mapStyleIndex = 0
    
    
    @State private var mapStyle = MapStyle.standard
    
    @State private var annotations: [MKPointAnnotation] = []
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    
    
    var body: some View {
        ZStack {
            Map(position: $position, selection: $selectedResult) {
                UserAnnotation()
                Marker("My Location",systemImage: "paperplane", coordinate: .userLocation)
                    .tint(.green)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
            //.navigationBarTitle("Map")
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
                MapPitchToggle()
                MapScaleView()
            }
            .mapStyle(mapStyle)
            
            VStack {
                Spacer()
                
                Picker("Map Style", selection: $mapStyleIndex) {
                    ForEach(mapStyles.indices, id: \.self) { index in
                        Text(mapStyles[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.white.opacity(0.8)) // Fond transparent
                .cornerRadius(10) // Coins arrondis
                .padding() // Espace supplémentaire
                
            }
        }
        .onChange(of: mapStyleIndex) { newIndex in
            changeMapStyle(mapStyles[newIndex])
        }
    }
    
    
    func changeMapStyle(_ newStyle: String) {
        if mapStyles.firstIndex(of: newStyle) != nil {
            mapStyle = MapStyle(rawValue: newStyle) ?? .standard
        }
    }
    
    
    
    
}
extension MapStyle {
    init?(rawValue: String) {
        switch rawValue {
        case "Standard": self = .standard
        case "Hybride": self = .hybrid
        case "Satellite": self = .imagery
        default: return nil
        }
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 22.6522, longitude: -80.8241)
    }
}

struct LocationButtonTestView: View {
    @Namespace var mapScope
    var body: some View {
        VStack {
            Map(scope: mapScope)
            MapUserLocationButton(scope: mapScope)
        }
        .mapScope(mapScope)
    }
}


#Preview {
    MapView()
}
