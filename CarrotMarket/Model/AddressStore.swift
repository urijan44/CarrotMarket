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
    sortedAddresses.forEach {
      let str = String($0.distance)
      distances.append(str)
      distances.append(",")
    }
    
    guard let _ = try? PlistManager().convertToPlist(sortedAddresses) else {
      throw AddressStoreError.saveFail
    }
  }
  
  init() {
    #if DEBUG
    print("addressStore init")
    #endif
    guard let store = try? PlistManager().convertToDataStructure() else {
      print("load fail")
      return
    }
    sortedAddresses = store
    var rows = distances.components(separatedBy: ",")
    for address in sortedAddresses {
      guard let _ = rows.first else {
        return
      }
      address.distance = (rows.removeFirst() as NSString).doubleValue
    }
    sortedAddresses.sort { lhs, rhs in
      lhs.distance < rhs.distance
    }
  }
}
