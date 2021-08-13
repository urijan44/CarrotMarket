//
//  PlistManager.swift
//
//
//  Created by hoseung Lee on 2021/08/13.
//

import Foundation

private enum PlistManagerError: Error {
  case PathNotFound, DecodingError
}

struct PlistManager {
  
  func convertToPlist(_ addresses: [AddressModel]) throws {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    
//    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Addresses.plist")
    guard let path = Bundle.main.url(forResource: "Addresses", withExtension: "plist") else {
      throw PlistManagerError.PathNotFound
    }
    print(path)
    do {
      let encodeData = try encoder.encode(addresses)
//      print(String(data: encodeData, encoding: .utf8)!)
      try encodeData.write(to: path, options: .atomic)
    } catch {
      print(error.localizedDescription)
    }
    print("Convert Success")
  }
  
  func convertToDataStructure() throws -> [AddressModel] {
    let decoder = PropertyListDecoder()

    guard let plist = Bundle.main.url(forResource: "Addresses", withExtension: "plist"), let contents = try? Data(contentsOf: plist) else {
      throw PlistManagerError.PathNotFound
    }
    
    var decodedData: [AddressModel] = []
    do {
      decodedData = try decoder.decode([AddressModel].self, from: contents)
    } catch let DecodingError.dataCorrupted(context) {
        print(context)
    } catch let DecodingError.keyNotFound(key, context) {
        print("Key '\(key)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch let DecodingError.valueNotFound(value, context) {
        print("Value '\(value)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch let DecodingError.typeMismatch(type, context)  {
        print("Type '\(type)' mismatch:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch {
        print("error: ", error)
    }
    
    
    #if DEBUG
    print("plist load success")
    #endif
    return decodedData
  }
}
