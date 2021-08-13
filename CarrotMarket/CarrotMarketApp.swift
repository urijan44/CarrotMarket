//
//  CarrotMarketApp.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/18.
//

import SwiftUI

@main
struct CarrotMarketApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(LocationIndicatorManager())
        .environmentObject(AddressStore())
    }
  }
}
