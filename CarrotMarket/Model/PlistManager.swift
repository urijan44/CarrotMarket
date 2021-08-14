//
//  PlistManager.swift
//
//
//  Created by hoseung Lee on 2021/08/13.
//

import Foundation

private enum PlistManagerError: Error {
  case PathNotFound, DecodingError
  case DataConvertError
}

struct PlistManager {
  
  func getURL() -> URL? {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    return documentsURL.appendingPathComponent("Addresses.plist")
  }
  
  func convertToPlist(_ addresses: [AddressModel]) throws {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    
    guard let path = getURL() else {
      throw FileError.urlFailure
    }
    
    do {
      let encodeData = try encoder.encode(addresses)
      try encodeData.write(to: path, options: .atomic)
    } catch let EncodingError.invalidValue(type, context) {
      print("invalidValue")
      print("type: \(type), context: \(context.debugDescription)")
      print("\(context.codingPath)")
    }
  }
  
  func convertToDataStructure(defaultLoad: Bool) throws -> [AddressModel] {
    let decoder = PropertyListDecoder()
    
    var plist: URL
    if defaultLoad {
      guard let url = Bundle.main.url(forResource: "Addresses", withExtension: "plist") else {
        throw FileError.urlFailure
      }
      plist = url
    } else {
      guard let url = getURL() else {
        throw FileError.urlFailure
      }
      plist = url
    }
    
    guard let contents = try? Data(contentsOf: plist) else {
      throw PlistManagerError.DataConvertError
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
    return decodedData
  }
}
