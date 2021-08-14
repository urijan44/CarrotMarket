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
    return documentsURL.appendingPathComponent("LocationIndicatorManager.plist")
  }
  
  func save() throws {
    guard let path = getURL() else {
      throw FileError.urlFailure
    }
    let plistData = storedLists.flatMap{$0}
    print(plistData)
    do {
      let data = try PropertyListSerialization.data(fromPropertyList: plistData, format: .binary, options: .zero)
      try data.write(to: path, options: .atomic)
    } catch {
      throw FileError.saveFailure
    }
  }
  
  func load() throws {
    guard let path = getURL() else {
      throw FileError.urlFailure
    }
    guard let data = try? Data(contentsOf: path) else { return }
    let plistData = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
    let convertedPlistData = plistData as? [[AddressModel]] ?? []
    storedLists = convertedPlistData
  }
  
}
