// Main container view for the CinemaPix app, providing a tab-based navigation system.
import CoreLocation
import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var viewModel = ContentViewModel() // ViewModel that manages data and app state used across multiple views.
    @State var selectedTab = 0 // Tracks the currently selected tab in the TabView.
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // The MapContentView is embedded within a tab item, providing mapping functionalities.
            MapContentView()
                .tabItem {
                    Image(systemName: "map") // Icon representing the map tab.
                    Text("Map")
                }
                .tag(0) // Unique identifier for the Map tab.
                .environmentObject(viewModel) // Passes the viewModel to the MapContentView.
            
            // SuburbsView allows users to search for and select suburbs.
            SuburbsView(selection: $selectedTab)
                .tabItem {
                    Image(systemName: "magnifyingglass") // Icon representing the suburb search tab.
                    Text("Suburb Search")
                }
                .tag(1) // Unique identifier for the Suburb Search tab.
                .environmentObject(viewModel) // Ensures SuburbsView has access to the shared viewModel.
            
            // User preferences view for settings adjustments within the app.
            User_Preferences_View()
                .tabItem {
                    Image(systemName: "gearshape") // Icon representing the settings tab.
                    Text("Settings")
                }
                .tag(2) // Unique identifier for the Settings tab.
            
            // Provides help and documentation to assist users in navigating and using the app.
            Help_Documentation_View()
                .tabItem {
                    Image(systemName: "questionmark.circle") // Icon representing the help tab.
                    Text("Help")
                }
                .tag(3) // Unique identifier for the Help tab.
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
