//
//  MapContentView.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 12/7/2024.
//

import CoreLocation
import SwiftUI
import MapKit

// Represents a theater with essential details for mapping and display, encapsulating both geographical and operational data.
struct Theater: Identifiable {
    var name: String
    var iconURLString: String
    var coordinates: CLLocationCoordinate2D // Geographical location used for placing the theater on the map.
    var openSinceString: String
    var openUntilString: String
    var showtimes: [(iconURLString: String, title: String, hours: [(startsString: String, endsString: String)], id: UUID)] // Unique identifier for each theater to maintain identity across sessions.
    let id: UUID
    
    //Construct a struct that will be used across this file to identify theaters and shows.
}

// Provides observable object capabilities to enable responsive updates in the UI when theater data changes.
class ObservedTheater: ObservableObject {
    @Published var theater: Theater
    
    // Initializes with a specific theater, ensuring the observed object is ready for binding in SwiftUI views.
    init(theater: Theater) {
        self.theater = theater
    }
}

// Main view component for displaying the map and managing theater annotations, focusing on user interactions and dynamic data display.
struct MapContentView: View {
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var tappedLocation: CLLocationCoordinate2D?
    @State private var showLookAround = false
    @EnvironmentObject private var viewModel: ContentViewModel
    
    // Creation of different cinema brand locations with their respective movies and showtimes.
    let theaters = [Theater(name: "Reading Cinemas", iconURLString: "https://pbs.twimg.com/profile_images/953112688531456000/fnsR_2Ii_400x400.jpg", coordinates: CLLocationCoordinate2D(
        latitude: -33.69061701930429,
        longitude: 150.924357299979), openSinceString: "9:00 AM", openUntilString: "9:00 PM", showtimes: [
        ("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRyV6VaCSW2esZUTCtAqIieYXsfIjcWFxtug&s", "Inside Out 2", [("10:15 AM", "12:00 PM"), ("1:15 PM", "3:00 PM"), ("4:00 PM", "5:45 PM"),("6:30 PM", "8:15 PM")], UUID()),
        ("https://cdn.eventcinemas.com.au/cdn/resources/movies/17175/images/largeposter.jpg", "Despicable Me 4", [("10:45 AM", "12:30 PM"),("1:00 PM", "2:45 PM"),("3:30 PM", "5:15 PM"),("6:00 PM", "7:45 PM")], UUID()),
        ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105891-l.jpg", "Deadpool & Wolverine", [("10:00 AM", "12:00 PM"),("11:30 AM", "1:30 PM"),("12:15 PM", "2:15 PM"),("1:30 PM", "3:30 PM"),("2:30 PM", "4:30 PM"),("3:15 PM", "5:15 PM")], UUID()),
        ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/106169-l.jpg", "Longlegs", [("01:15 PM", "03:00 PM"), ("06:30 PM", "08:15 PM"), ("09:30 PM", "11:15 PM")], UUID()),
        ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105987-l.jpg", "A Quiet Place: Day One", [("8:45 PM", "10:30 PM")], UUID()),
        ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105953-l.jpg", "Fly Me to the Moon", [("3:00 PM", "5:30 PM")], UUID()),
        ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105991-l.jpg", "Sting", [("10:00 AM", "11:30 AM")], UUID())
        ], id: UUID()),
        Theater(name: "Event Cinemas", iconURLString: "https://i.ytimg.com/vi/g8eJW1yRE3Q/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDZbCIAgviE6tEhpz9ycMrofPH5EQ", coordinates: CLLocationCoordinate2D(
            latitude: -33.891069569579585,
            longitude: 151.25113390269308), openSinceString: "10:45 AM", openUntilString: "9:30 PM", showtimes: [
            ("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRyV6VaCSW2esZUTCtAqIieYXsfIjcWFxtug&s", "Inside Out 2", [("9:30 AM", "11:15 AM"), ("2:45 PM", "4:30 PM"), ("5:00 PM", "6:45 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/17175/images/largeposter.jpg", "Despicable Me 4", [("9:45 AM", "11:30 AM"), ("11:30 AM", "1:15 PM"), ("4:15 PM", "6:00 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105891-l.jpg", "Deadpool & Wolverine", [("9:30 AM", "11:30 AM"), ("12:30 PM", "2:30 PM"), ("3:00 PM", "5:00 PM"), ("4:00 PM", "6:00 PM"), ("6:30 PM", "8:30 PM"), ("7:30 PM", "9:30 PM"), ("9:00 PM", "11:00 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/106169-l.jpg", "Longlegs", [("4:00 PM", "5:45 PM"), ("7:15 PM", "9:00 PM"), ("9:30 PM", "11:15 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105987-l.jpg", "A Quiet Place: Day One", [("6:30 PM", "8:00 PM"), ("9:00 PM", "10:30 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105953-l.jpg", "Fly Me to the Moon", [("11:50 AM", "2:20 PM"), ("6:20 PM", "8:50 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105991-l.jpg", "Sting", [("9:10 PM", "10:40 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/19101/images/largeposter.jpg", "The Sloth Lane", [("1:50 PM", "3:20 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/19200/images/largeposter.jpg", "Zog & The Highway Rat", [("10:00 AM", "10:45 AM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/18734/images/largeposter.jpg", "Sleeping Dogs", [("10:00 AM", "11:45 AM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/18947/images/largeposter.jpg", "Treasure", [("1:45 PM", "3:30 PM")], UUID())
            ], id: UUID()),
        Theater(name: "Hoyts Cinemas", iconURLString: "https://assets-us-01.kc-usercontent.com/7af951a6-2a13-004b-f0eb-a87382a5b2e7/29f9e80d-91c2-4d5e-9094-8d4daff4c195/HOYTS.png", coordinates: CLLocationCoordinate2D(
            latitude: -33.76835472800352,
            longitude: 151.26623833000787), openSinceString: "10:00 AM", openUntilString: "9:30 PM", showtimes: [
            ("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRyV6VaCSW2esZUTCtAqIieYXsfIjcWFxtug&s", "Inside Out 2", [("10:45 AM", "12:30 PM"), ("12:45 PM", "2:30 PM"), ("6:00 PM", "7:45 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/17175/images/largeposter.jpg", "Despicable Me 4", [("10:20 AM", "12:05 PM"), ("3:50 PM", "5:35 PM"), ("6:30 PM", "8:15 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105891-l.jpg", "Deadpool & Wolverine", [("10:00 AM", "12:00 PM"), ("1:00 PM", "3:00 PM"), ("4:30 PM", "6:30 PM"), ("6:00 PM", "8:00 PM"), ("8:30 PM", "10:30 PM"), ("9:00 PM", "11:00 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/106169-l.jpg", "Longlegs", [("1:15 PM", "3:00 PM"), ("3:45 PM", "5:30 PM"), ("6:15 PM", "8:00 PM"), ("8:45 PM", "10:30 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105987-l.jpg", "A Quiet Place: Day One", [("10:50 AM", "12:20 PM"), ("1:20 PM", "2:50 PM"), ("4:00 PM", "5:30 PM"), ("8:50 PM", "10:20 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105953-l.jpg", "Fly Me to the Moon", [("10:30 AM", "1:00 PM"), ("1:30 PM", "4:00 PM"), ("5:50 PM", "8:20 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105991-l.jpg", "Sting", [("3:30 PM", "5:00 PM"), ("9:10 PM", "10:40 PM")], UUID()),
            ("https://imgix.hoyts.com.au/mx/posters/au/the-garfield-movie-751d537c.jpg?w=234&h=347&fit=crop&auto=compress,format", "The Garfield Movie", [("10:00 AM", "11:45 AM")], UUID())
            ], id: UUID()),
        Theater(name: "Palace Cinemas", iconURLString: "https://homecinema.palacecinemas.com.au/images/common/facebook-image.png", coordinates: CLLocationCoordinate2D(
            latitude: -33.88417602887886,
            longitude: 151.20047030537768), openSinceString: "10:00 AM", openUntilString: "10:00 PM", showtimes: [
            ("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRyV6VaCSW2esZUTCtAqIieYXsfIjcWFxtug&s", "Inside Out 2", [("11:00 AM", "12:45 PM"), ("6:15 PM", "8:00 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/17175/images/largeposter.jpg", "Despicable Me 4", [("10:00 AM", "11:45 AM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105891-l.jpg", "Deadpool & Wolverine", [("10:00 AM", "12:00 PM"), ("1:00 PM", "3:00 PM"), ("4:30 PM", "6:30 PM"), ("6:00 PM", "8:00 PM"), ("8:30 PM", "10:30 PM"), ("9:00 PM", "11:00 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/106169-l.jpg", "Longlegs", [("11:50 AM", "1:30 PM"), ("2:10 PM", "3:50 PM"), ("6:20 PM", "8:00 PM"), ("8:40 PM", "10:20 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105987-l.jpg", "A Quiet Place: Day One", [("5:45 PM", "7:15 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105953-l.jpg", "Fly Me to the Moon", [("12:45 PM", "3:15 PM"), ("6:00 PM", "8:30 PM")], UUID()),
            ("https://www.palacecinemas.com.au/poster/HO00018063", "Birdeater", [("3:50 PM", "5:50 PM")], UUID()),
            ("https://www.palacecinemas.com.au/poster/HO00017984", "Kinds of Kindness", [("8:00 PM", "10:45 PM")], UUID()),
            ("https://www.palacecinemas.com.au/poster/HO00017985", "MaXXXine", [("1:15 PM", "3:00 PM"),("3:45 PM", "5:30 PM"),("8:45 PM", "10:30 PM")], UUID())
            ], id: UUID()),
        Theater(name: "Dendy Cinemas", iconURLString: "https://kangacup.com/wp-content/uploads/2023/05/Dendy-Cinemas-LogoB.jpg", coordinates: CLLocationCoordinate2D(
            latitude: -33.895927689447454,
            longitude: 151.18043302925184), openSinceString: "10:00 AM", openUntilString: "11:00 PM", showtimes: [
            ("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRyV6VaCSW2esZUTCtAqIieYXsfIjcWFxtug&s", "Inside Out 2", [("4:40 PM", "6:36 PM"), ("6:00 PM", "7:56 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/17175/images/largeposter.jpg", "Despicable Me 4", [("1:00 PM", "2:44 PM"), ("6:00 PM", "7:54 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105891-l.jpg", "Deadpool & Wolverine", [("10:10 AM", "12:38 PM"), ("2:00 PM", "4:28 PM"), ("4:45 PM", "7:13 PM"), ("6:00 PM", "8:18 PM"), ("7:30 PM", "9:58 PM"), ("9:00 PM", "11:28 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/106169-l.jpg", "Longlegs", [("10:00 AM", "12:01 PM"), ("12:10 PM", "2:11 PM"), ("4:30 PM", "6:31 PM"), ("6:45 PM", "8:46 PM"), ("10:10 PM", "12:11 AM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105987-l.jpg", "A Quiet Place: Day One", [("12:15 PM", "2:15 PM"), ("3:20 PM", "5:20 PM"), ("9:15 PM", "11:15 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105953-l.jpg", "Fly Me to the Moon", [("10:40 AM", "1:08 PM"), ("3:40 PM", "6:08 PM")], UUID()),
            ("https://www.palacecinemas.com.au/poster/HO00018063", "Birdeater", [("10:00 AM", "12:15 PM"), ("1:20 PM", "3:35 PM")], UUID()),
            ("https://www.palacecinemas.com.au/poster/HO00017984", "Kinds of Kindness", [("12:30 PM", "3:34 PM"), ("2:45 PM", "5:49 PM"), ("8:30 PM", "11:34 PM")], UUID()),
            ("https://www.palacecinemas.com.au/poster/HO00017985", "MaXXXine", [("1:15 PM", "3:18 PM"), ("3:45 PM", "5:48 PM"), ("6:45 PM", "8:48 PM")], UUID())
            ], id: UUID()),
        Theater(name: "Event Cinemas", iconURLString: "https://i.ytimg.com/vi/g8eJW1yRE3Q/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDZbCIAgviE6tEhpz9ycMrofPH5EQ", coordinates: CLLocationCoordinate2D(
            latitude: -33.81715679547613,
            longitude: 151.00378392580873), openSinceString: "10:30 AM", openUntilString: "9:00 PM", showtimes: [
            ("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRyV6VaCSW2esZUTCtAqIieYXsfIjcWFxtug&s", "Inside Out 2", [("10:10 AM", "12:00 PM"), ("12:25 PM", "2:15 PM"), ("2:40 PM", "4:30 PM"), ("5:00 PM", "6:50 PM"), ("6:10 PM", "8:00 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/17175/images/largeposter.jpg", "Despicable Me 4", [("10:00 AM", "11:45 AM"), ("12:15 PM", "2:00 PM"), ("2:30 PM", "4:15 PM"), ("4:45 PM", "6:30 PM"), ("7:15 PM", "9:00 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105891-l.jpg", "Deadpool & Wolverine", [("10:15 AM", "12:15 PM"), ("1:20 PM", "3:20 PM"), ("4:20 PM", "6:20 PM"), ("7:20 PM", "9:20 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/106169-l.jpg", "Longlegs", [("1:00 PM", "2:45 PM"), ("3:45 PM", "5:30 PM"), ("7:00 PM", "8:45 PM"), ("9:30 PM", "11:15 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105987-l.jpg", "A Quiet Place: Day One", [("3:30 PM", "5:00 PM"), ("9:30 PM", "11:00 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105953-l.jpg", "Fly Me to the Moon", [("10:10 AM", "11:50 AM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105991-l.jpg", "Sting", [("1:10 PM", "2:40 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/19101/images/largeposter.jpg", "The Sloth Lane", [("10:00 AM", "11:30 AM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/19200/images/largeposter.jpg", "Zog & The Highway Rat", [("10:10 AM", "11:05 AM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/18734/images/largeposter.jpg", "Sleeping Dogs", [("10:20 AM", "12:05 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/18046/images/largeposter.jpg", "Twisters", [("10:20 AM", "12:25 PM"),("12:55 PM", "3:00 PM"),("9:10 PM", "11:15 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/19191/images/largeposter.jpg", "Bad Newz", [("6:00 PM", "8:20 PM")], UUID())
            ], id: UUID()),
        Theater(name: "Event Cinemas", iconURLString: "https://i.ytimg.com/vi/g8eJW1yRE3Q/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDZbCIAgviE6tEhpz9ycMrofPH5EQ", coordinates: CLLocationCoordinate2D(
            latitude: -34.034220476802176,
            longitude: 151.0996995887545), openSinceString: "10:00 AM", openUntilString: "8:00 PM", showtimes: [
            ("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRyV6VaCSW2esZUTCtAqIieYXsfIjcWFxtug&s", "Inside Out 2", [("12:30 PM", "2:20 PM"), ("5:00 PM", "6:50 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/17175/images/largeposter.jpg", "Despicable Me 4", [("4:45 PM", "6:25 PM"), ("7:20 PM", "9:00 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105891-l.jpg", "Deadpool & Wolverine", [("10:30 AM", "12:30 PM"), ("1:30 PM", "3:30 PM"), ("4:00 PM", "6:00 PM"), ("6:50 PM", "8:50 PM"), ("9:40 PM", "11:40 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/106169-l.jpg", "Longlegs", [("12:00 PM", "1:45 PM"), ("7:00 PM", "8:45 PM"), ("9:20 PM", "11:05 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105987-l.jpg", "A Quiet Place: Day One", [("2:20 PM", "3:50 PM"), ("9:40 PM", "11:10 PM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105953-l.jpg", "Fly Me to the Moon", [("10:10 AM", "11:50 AM")], UUID()),
            ("https://d2apwscfoijj3f.cloudfront.net/wpdata/images/105991-l.jpg", "Sting", [("2:45 PM", "4:15 PM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/19200/images/largeposter.jpg", "Zog & The Highway Rat", [("10:00 AM", "10:55 AM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/18734/images/largeposter.jpg", "Sleeping Dogs", [("10:00 AM", "11:45 AM")], UUID()),
            ("https://cdn.eventcinemas.com.au/cdn/resources/movies/18046/images/largeposter.jpg", "Twisters", [("10:00 AM", "12:05 PM"),("1:00 PM", "3:05 PM"),("3:45 PM", "5:50 PM"),("6:30 PM", "8:35 PM"),("9:15 PM", "11:20 PM")], UUID())
            ], id: UUID())
    ] //Initialize the theaters with sample data.
    
    // State variables to manage UI behavior and data binding for theater information.
    @State private var sheetTheater = false // Controls visibility of the theater detail sheet.
    @StateObject private var observedTheater = ObservedTheater(theater: Theater(name: "Placeholder", iconURLString: "", coordinates: CLLocationCoordinate2D(), openSinceString: "", openUntilString: "", showtimes: [], id: UUID())) // An observed object for the currently selected theater, initialized with placeholder data.
    var body: some View {
        ZStack {
            // Main map view displaying theater locations as annotations.
            Map(coordinateRegion: $viewModel.region, annotationItems: theaters) { theater in
                // Custom annotation view for each theater on the map.
                MapAnnotation(coordinate: theater.coordinates) {
                    VStack {
                        // Asynchronously load and display theater icons from URLs.
                        AsyncImage(url: URL(string: theater.iconURLString)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .scaledToFill()
                                .frame(width: 30, height: 30) // Set icon size for map annotations.
                                .cornerRadius(100) // Rounded corners for aesthetic purposes.
                        } placeholder: {
                            Color.gray
                                .frame(width: 30, height: 30) // Placeholder while images load.
                                .cornerRadius(100)
                        } // Using an AsyncImage allows us to load images from the Internet.
                        Text(theater.name).background(.white)
                            .font(.caption) // Display theater name below the icon.
                    }
                    .onTapGesture {
                        observedTheater.theater = theater // Update observed theater on tap.
                        sheetTheater = true // Show detail sheet for the selected theater.
                        
                    }
                }
            }
            .edgesIgnoringSafeArea(.all) // Allow the map to extend to the screen edges.
            .accentColor(Color(.systemPink)) // Accent color for map elements.
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled() // Ensures location services are active when the view appears.
            }
            // Container for navigation buttons and additional UI elements.
            VStack(spacing: 0) {
                NavigationButtonsBar(hasCenterButton: false)
                    .background(Color(red: 1.0, green: 0.94, blue: 0.83))
                
                Spacer()
                
                VStack(spacing: 0) {
                    NavigationButtonsBar(hasCenterButton: true)
                        .background(Color(red: 1.0, green: 0.94, blue: 0.83))
                    // Conditional rendering of the LookAroundView based on a selected location.
                    if tappedLocation != nil {
                        LookAroundView(tappedLocation: $tappedLocation, showLookAroundView: $showLookAround)
                            .cornerRadius(20) // Rounded corners for the LookAroundView.
                    }
                }
                .ignoresSafeArea()
            }
        }
        .onSubmit(of: .text) {
            Task { await searchPlaces() } // Perform a search based on text input when submitted.
        }
        .sheet(isPresented: $sheetTheater) {
            TheaterView()
                .environmentObject(observedTheater)
                .presentationDetents([.fraction(0.4), .large])
        } //Sheet, or "popup", with the information about the theater we selected from the map.
    }
}

struct TheaterView: View {
    @EnvironmentObject var observedTheater: ObservedTheater
    @Environment(\.dismiss) var dismiss
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        return df
    }() //Define a custom DateFormatter for displaying hours and showtimes.
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Good to Know")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                        .padding(.vertical,7)
                        .padding(.bottom,5)
                    Text("Hours")
                        .font(.headline)
                        .padding(.bottom,5)
                    let dateOpen = dateFormatter.date(from: observedTheater.theater.openSinceString) ?? Date()
                    let dateClosed = dateFormatter.date(from: observedTheater.theater.openUntilString) ?? Date()
                    //Get the date from the String of the theater's hours.
                    HStack {
                        Text("Everyday")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(DateFormatter.localizedString(from: dateOpen, dateStyle: .none, timeStyle: .short))-\(DateFormatter.localizedString(from: dateClosed, dateStyle: .none, timeStyle: .short))")
                            .font(.subheadline.bold())
                        //Get back to a String.
                    }
                    Text("Showtimes")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top,30)
                    Divider()
                        .padding(.vertical,7)
                        .padding(.bottom,5)
                    ForEach(observedTheater.theater.showtimes, id: \.id) { show in
                        HStack(alignment: .top) {
                            AsyncImage(url: URL(string: show.iconURLString)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .scaledToFill()
                                    .frame(width: 100, height: 125)
                                    .cornerRadius(10)
                            } placeholder: {
                                Color.gray
                                    .frame(width: 100, height: 125)
                                    .cornerRadius(10)
                            }
                            .padding(.trailing,5)
                            //AsyncImage to load the show's thumbnail.
                            VStack(alignment: .leading, spacing: 0) {
                                Text(show.title)
                                    .font(.headline)
                                    .padding(.bottom,15)
                                ForEach(show.hours, id: \.startsString) { time in
                                    let dateStarts = dateFormatter.date(from: time.startsString) ?? Date()
                                    let dateEnds = dateFormatter.date(from: time.endsString) ?? Date()
                                    Text("\(DateFormatter.localizedString(from: dateStarts, dateStyle: .none, timeStyle: .short))-\(DateFormatter.localizedString(from: dateEnds, dateStyle: .none, timeStyle: .short))")
                                        .font(.subheadline)
                                        .padding(.bottom,5)
                                }
                            }
                        }
                        .padding(.bottom,20)
                    }
                }
                .padding(15)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                                    AsyncImage(url: URL(string: observedTheater.theater.iconURLString)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .scaledToFill()
                                            .frame(width: 30, height: 30)
                                            .cornerRadius(100)
                                    } placeholder: {
                                        Color.gray
                                            .frame(width: 30, height: 30)
                                            .cornerRadius(100)
                                    }
                                    Text(observedTheater.theater.name)
                                        .font(.title2.bold())
                                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Extension for providing search functionality within the map, leveraging natural language queries.
extension MapContentView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
}

// Extend CLLocationCoordinate2D to include a predefined location for Sydney.
extension CLLocationCoordinate2D {
    // Provides a default location coordinate for Sydney, used in setting initial map regions or defaults.
    static var sydney: CLLocationCoordinate2D {
        return .init(latitude: -33.8688, longitude: 151.2093)
    }
}

// Define a custom MKCoordinateRegion for managing map views specific to user regions.
extension MKCoordinateRegion {
    // Custom region based on user location with a predefined span for zoom level.
    static var userRegion: MKCoordinateRegion {
        return .init(center: .sydney, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}

// Simplistic view to render navigation buttons with potential for expansion.
struct NavigationButtonsBar: View {
    let hasCenterButton: Bool // Determines if a center button is present, allowing for dynamic UI adjustments.

    var body: some View {
        ZStack { // Background color setup for the navigation bar.
            Color(red: 0.9, green: 0.9, blue: 0.9)
                .edgesIgnoringSafeArea(.all)
        }
        .frame(height: 1) // Set a minimal height to maintain a discrete appearance.
    }
}

struct MapContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapContentView().environmentObject(ContentViewModel())
    }
}
