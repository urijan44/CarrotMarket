//
//  ListStore.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/08/15.
//

import Foundation

class ListStore: ObservableObject {
  @Published var storedLists: [[AddressModel]] = []
  
  init() throws {
    do {
      try load()
    } catch {
      throw error
    }
  }
  
  init(withCheck: Bool) throws {
    do {
      try load()
    } catch {
      print(error)
    }
  }
  
  func getURL() -> URL? {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    return documentsURL.appendingPathComponent("ListStore.plist")
  }
  
  func save() throws {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .binary
    
    guard let path = getURL() else {
      throw FileError.urlFailure
    }
    
    do {
      let encodeData = try encoder.encode(storedLists)
      try encodeData.write(to: path, options: .atomic)
    } catch let EncodingError.invalidValue(type, context) {
      print("invalidValue")
      print("type: \(type), context: \(context.debugDescription)")
      print("\(context.codingPath)")
    }
  }
  
  func load() throws {
    let decoder = PropertyListDecoder()
    
    guard let path = getURL() else {
      throw FileError.urlFailure
    }
    
    guard let contents = try? Data(contentsOf: path) else {
      throw ListStoreError.dataConvertFailure
    }
    
    var decodedData: [[AddressModel]] = []
    do {
      decodedData = try decoder.decode([[AddressModel]].self, from: contents)
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
    storedLists = decodedData
    
//    guard let data = try? Data(contentsOf: path) else { return }
//
//
//    let plistData = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
//    let convertedPlistData = plistData as? [[AddressModel]] ?? []
//    storedLists = convertedPlistData
  }
  
}
private enum ListStoreError: Error {
  case dataConvertFailure
}
