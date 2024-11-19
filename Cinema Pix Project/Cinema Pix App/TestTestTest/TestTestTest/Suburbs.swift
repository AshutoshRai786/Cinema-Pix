//
//  Suburbs.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 13/7/2024.
//

import Foundation

//Source of the CSV Data: https://www.kaggle.com/code/kerneler/starter-suburbs-in-sydney-australia-90007a54-5/input?select=sydney_suburbs.csv

struct Suburbs: Identifiable {
    let Name: String
    let Latitude: Float
    let Longitude: Float
    
    var id: String { Name }
    
    init(raw: [String]) {
        self.Name = raw[1]
        self.Latitude = Float(raw[2])!
        self.Longitude = Float(raw[3])!
    }
}
