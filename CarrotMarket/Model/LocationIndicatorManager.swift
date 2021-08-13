//
//  LocationStore.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/20.
//

import Foundation
import SwiftUI

enum FileError: Error {
  case loadFailure
  case saveFailure
  case urlFailure
}

class LocationIndicatorManager: ObservableObject {
  @AppStorage("selectedLocation") var selectedLocation: String = ""
  @Published var storedLocate: [String?] = [nil, nil]
  @AppStorage("leftStored") var left: String = ""
  @AppStorage("rightStored") var right: String = ""
  @AppStorage("buttonIndicator")var buttonIndicator: String = ""

  init() {
    if !left.isEmpty {
      storedLocate[0] = left
    }
    if !right.isEmpty  {
      storedLocate[1] = right
    }
  }

  func setSelectedLocation(_ locate: String?) {
    guard let locate = locate else {
      return
    }
    selectedLocation = locate
  }

  func setStoredLocate(_ locate: String?, _ index: Int) {
    guard index == 1 || index == 0 else {
      return
    }
    storedLocate[index] = locate
    if index == 0 {
      left = locate ?? ""
    } else {
      right = locate ?? ""
    }
  }

  func setIndicator(_ locate: String?) {
    guard let locate = locate else {
      return
    }
    buttonIndicator = locate
  }
}
