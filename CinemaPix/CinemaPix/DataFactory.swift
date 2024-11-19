//
//  DataFactory.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 14/7/2024.
//

import Foundation

// Defines a struct to represent a suburb with necessary properties.
struct Suburbs: Identifiable {
    var Suburb: String = ""
    var Latitude: String = ""
    var Longitude: String = ""
    var id = UUID()
    
    // Initializer to create a Suburbs instance from a raw array of strings.
    init(raw: [String]) {
        Suburb = raw[0]
        Latitude = raw[1]
        Longitude = raw[2]
    }
    
}

// Function to load suburbs data from a CSV file.
func loadCSV(from csvName: String) -> [Suburbs] {
    var csvToStruct = [Suburbs]()
    
    // Locate the CSV file within the app bundle.
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return []
    }
    
    // Convert the contents of the file into a single string.
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return []
    }
    
    // Split the string into an array of rows based on new line characters.
    var rows = data.components(separatedBy: "\n")
    
    // Remove the header row.
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()
    
    // Loop through each row and split it into columns.
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == columnCount {
            let suburbsStruct = Suburbs.init(raw: csvColumns)
            csvToStruct.append(suburbsStruct)
        }
    }
    
    return csvToStruct
}
