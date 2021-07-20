//
//  LocationStore.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/20.
//

import Foundation

class LocationStore: ObservableObject {
  @Published var selectedLocation: String = ""
  @Published var storedLocate: [String?] = [nil, nil]
  @Published var buttonIndicator: String = ""

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
  }

  func setIndicator(_ locate: String?) {
    guard let locate = locate else {
      return
    }
    buttonIndicator = locate
  }
}
