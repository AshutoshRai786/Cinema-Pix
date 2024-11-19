//
//  ContentView.swift
//  test 1234
//
//  Created by Ashutosh Rai on 12/7/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .tabItem {
                    Image(systemName: "plus")
                    Text("Tab 1")
                }
                .tag(0)
            
            Text("Hello, world!")
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Tab 2")
                }
                .tag(1)
            
            Text("Wassup!")
                .tabItem {
                    Image(systemName: "globe")
                    Text("Tab 2")
                }
                .tag(2)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
