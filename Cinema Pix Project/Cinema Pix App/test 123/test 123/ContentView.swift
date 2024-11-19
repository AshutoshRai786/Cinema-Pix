//
//  ContentView.swift
//  test 123
//
//  Created by Ashutosh Rai on 8/7/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.0000), // Sydney coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.55, longitudeDelta: 0.55) // Span to control the zoom level
    )

    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                // Additional setup if needed
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
