//
//  Suburb Selection View.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 3/2/2024.
//

import SwiftUI

struct User_Preferences_View: View {
    @State var currentTime = Date() // State to manage the current time selection for settings.
    @State private var selectedSuburb: String = ""
    @State private var familyName: String = ""
    @State private var sliderValue: Double = .zero // Slider value to represent a range setting (e.g., search radius).
    @State private var selectedCinema: String = "Select Cinema" // Placeholder for user's cinema selection.
    @State private var selectedMovie: String = "Select Movie" // Placeholder for user's movie selection.
    var closedRange = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
    
    // Sample data for cinemas and movies to populate menu options.
    var cinemas = ["Event Cinemas","Hoyts","Village Cinemas","Palace Cinemas","Dendy Cinemas","Reading Cinemas"]
    var movies = ["Deadpool & Wolverine","Despicable Me 4","Inside Out 2","Twisters","Longlegs","A Quiet Place: Day One","Fly Me to the Moon","Sting"]


    var body: some View {
        VStack {
            Image("pin point")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 70)
            
            Text("User Preferences")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
            // Main container for user preference settings.
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        // Dropdown menu for selecting a cinema.
                        Text("Cinemas:")
                            .font(.body)
                            .fontWeight(.bold)
                        
                        Menu(selectedCinema) {
                            ForEach(cinemas, id: \.self) { cinema in
                                Button(cinema, action: {
                                    selectedCinema = cinema
                                })
                            }
                        }
                        .padding()
                        .background(Color(UIColor.lightGray).opacity(0.4))
                        .cornerRadius(10)
                        // Dropdown menu for selecting a movie.
                        Text("Movies:")
                            .font(.body)
                            .fontWeight(.bold)
                        
                        Menu(selectedMovie) {
                            ForEach(movies, id: \.self) { movie in
                                Button(movie, action: {
                                    selectedMovie = movie
                                })
                            }
                        }
                        .padding()
                        .background(Color(UIColor.lightGray).opacity(0.4))
                        .cornerRadius(10)
                    }
                    // Slider for adjusting a range, such as search radius.
                    Text("Radius:")
                        .font(.body)
                        .fontWeight(.bold)
                    
                    VStack {
                        Slider(value: $sliderValue, in: 0...10)
                        Text("\(sliderValue, specifier: "%.0f") km")
                    }
                    .padding()
                    // DatePicker for selecting a date and time.
                    Text("Date and Time:")
                        .font(.body)
                        .fontWeight(.bold)
                    
                    DatePicker("Choose a date + time", selection: $currentTime, in: Date()...)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .padding()
                // Button to save the settings.
                Button(action: {
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding(.bottom, 20)
            }


            
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct User_Preferences_View_Previews: PreviewProvider {
    static var previews: some View {
        User_Preferences_View()
    }
}
