//
//  CarrotMarketApp.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/18.
//

import SwiftUI

@main
struct CarrotMarketApp: App {
  @StateObject private var addressStore: AddressStore
  
  init() {
    let addressStore: AddressStore
    do {
      addressStore = try AddressStore(withChecking: true)
    } catch {
      print("Could not load address data")
      do {
        addressStore = try AddressStore()
      } catch {
        fatalError("FatalError")
      }
    }
    _addressStore = StateObject(wrappedValue: addressStore)
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(LocationIndicatorManager())
        .environmentObject(addressStore)
    }
  }
}
