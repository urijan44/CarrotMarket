//
//  LegalDongLibrary.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/18.
//

import Foundation

class LegalDongLibrary: ObservableObject {
  var legal: [Legal] {
    let csvName = "AreaCode"
    var csvToStruct: [Legal] = []

    //locate the csv file
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
      return []
    }

    //convert the contents of the file into one very long string
    var data = ""
    do {
      data = try String(contentsOfFile: filePath)
    } catch {
      print(error)
      return []
    }

    //data split
    var rows = data.components(separatedBy: "\r")

    //remove header
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()

    for row in rows {
      var csvColumns = row.components(separatedBy: ",")
      csvColumns[0].removeFirst()
      if csvColumns.count == columnCount {
        let legalStruct = Legal.init(raw: csvColumns)
        csvToStruct.append(legalStruct)
      }
    }

    return csvToStruct
  }
}
