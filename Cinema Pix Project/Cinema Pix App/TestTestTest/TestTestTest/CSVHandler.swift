//
//  CSVHandler.swift
//  CinemaPix
//
//  Created by Ashutosh Rai on 13/7/2024.
//

import Foundation

func cleanRows(file:String) -> String {
    var cleanFile = file
    cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
    return cleanFile
}

func loadCSVData() -> [Suburbs]{
    var csvToStruct = [Suburbs]()
    
    // Locate the CSV file
    guard let filePath = Bundle.main.path(forResource: "suburbs", ofType: "csv") else {
        print("Error: file not found")
        return []
    }
    
    // Convert the contents of the file into one very long string
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return []
    }
    
    // Clean up the \r and \n occurances
    data = cleanRows(file: data)
    
    // Split the long string into an array of 'rows' of data. Each row is a String.
    // When we detect the \n
    var rows = data.components(separatedBy: "\n")
    
    // Remove the header
    rows.removeFirst()
    
    // Now loop around and split each row into columns
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == rows.first?.components(separatedBy: ",").count {
            let linesStruct = Suburbs.init(raw: csvColumns)
            csvToStruct.append(linesStruct)
        }
    }
    
    return csvToStruct
}
