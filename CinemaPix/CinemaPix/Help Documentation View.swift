//
//  Help Documentation View.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 9/7/2024.
//

import SwiftUI

// Defines the view for displaying help and documentation related to the CinemaPix app.
struct Help_Documentation_View: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title for the help documentation section, centered for emphasis.
                Text("CinemaPix Help Documentation")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 20)
                
                // Section header for explaining the Map View features.
                Text("Map View:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                // Image illustrating the Map View, with fitting and padding adjustments for clarity.
                Image("Map View")
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 300)
                    .padding(.bottom, 20)
                // Section header for detailing the Movie Showtimes Popup View.
                Text("Movie Showtimes Popup View:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                // Image showing the Movie Showtimes Popup View, properly scaled and padded.
                Image("Movie Showtimes")
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 300)
                    .padding(.bottom, 20)
                // Section header for the Suburb Search Selection View explanation.
                Text("Suburb Search Selection View:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                // Image demonstrating the Suburb Search Selection View.
                Image("Suburb Search")
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 300)
                    .padding(.bottom, 20)
                // Section header for the User Preferences Selection View.
                Text("User Preferences Selection View:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                // Image illustrating how users can interact with the User Preferences View.
                Image("User Preferences")
                    .resizable()
                    .scaledToFit()
                    .frame(minHeight: 300)
            }
            .padding() // Adds padding around the VStack content for better layout and spacing.
        }
    }
}

struct Help_Documentation_View_Previews: PreviewProvider {
    static var previews: some View {
        Help_Documentation_View()
    }
}
