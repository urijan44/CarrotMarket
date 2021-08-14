//
//  LegalDongLibrary.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/18.
//

import Foundation
import OrderedCollections
import CoreLocation
import Combine
import SwiftUI

private enum AddressStoreError: Error {
  case initFail, saveFail
}

class AddressStore: ObservableObject {
  @Published var sortedAddresses: [AddressModel] = []
  @AppStorage("distances") var distances: String = ""
  
  func save() throws {
    do {
      try PlistManager().convertToPlist(sortedAddresses)
    } catch {
      throw FileError.saveFailure
    }
  }
  
  func load() throws {
    do {
      sortedAddresses = try PlistManager().convertToDataStructure(defaultLoad: false)
      if sortedAddresses.count == 0 {
        try defaultLoad()
      }
    } catch {
      throw FileError.loadFailure
    }
  }
  
  func defaultLoad() throws {
    do {
      sortedAddresses = try PlistManager().convertToDataStructure(defaultLoad: true)
    } catch {
      throw FileError.loadFailure
    }
  }
  
  func updateData(location: CLLocation) throws {
    sortedAddresses.forEach {value in
      value.distance = value.location.distance(from: location)
    }
    sortedAddresses.sort { lhs, rhs in
      lhs.distance < rhs.distance
    }

    do {
      try save()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  init() throws {
    do {
      try defaultLoad()
    } catch {
      throw error
    }
  }
  init(withChecking: Bool) throws {
    do {
      try load()
    } catch {
      throw error
    }
  }
}
