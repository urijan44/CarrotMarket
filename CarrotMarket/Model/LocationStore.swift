//
//  LocationStore.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/20.
//

import Foundation

class LocationStore: ObservableObject {
  @Published var selectedLocation: String = ""

  func setSelectedLocation(_ locate: String?) {
    guard let locate = locate else {
      return
    }
    selectedLocation = locate
  }
}
