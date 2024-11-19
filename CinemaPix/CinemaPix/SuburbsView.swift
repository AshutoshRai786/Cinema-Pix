//
//  SuburbsView.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 14/7/2024.
//

import SwiftUI
import MapKit

// Defines the view for searching and selecting suburbs, updating the map accordingly.
struct SuburbsView: View {
    // Load suburb data from a CSV file named "sydney".
    var suburbs = loadCSV(from: "sydney")
    // State to manage the search text entered by the user.
    @State private var searchText = ""
    // Environment object to access and modify the shared view model.
    @EnvironmentObject private var viewModel: ContentViewModel
    // Binding to manage tab selection from the parent view.
    @Binding var selection: Int
    
    var body: some View {
        // Navigation view to provide a container for the list and its navigation capabilities.
        NavigationView {
            // List to display suburbs that match the search criteria.
            List {
                // Loop through the search results and display each suburb.
                ForEach(searchResults) { suburb in
                    Text(suburb.Suburb) // Display the name of the suburb.
                        .onTapGesture {
                            // When a suburb is tapped, update the map region to the selected suburb's coordinates.
                            if let latitudeDouble = Double(suburb.Latitude), let longitudeDouble = Double(suburb.Longitude) {
                                viewModel.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble), span: viewModel.standardSpan)
                                selection = 0 // Switch back to the map view tab.
                            }
                        }
                }
            }
            // Add a search bar to the list for filtering suburbs.
            .searchable(text: $searchText)
        }
    }
    
    // Computed property to filter suburbs based on the search text.
    var searchResults: [Suburbs] {
        if searchText.isEmpty {
            return suburbs // Return all suburbs if search text is empty.
        } else {
            // Filter suburbs to only those that contain the search text.
            return suburbs.filter { $0.Suburb.contains(searchText) }
        }
    }
}

struct SuburbsView_Previews: PreviewProvider {
    static var previews: some View {
        SuburbsView(selection: .constant(0)).environmentObject(ContentViewModel())
    }
}
