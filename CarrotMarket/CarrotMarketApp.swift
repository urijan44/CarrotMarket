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
  @StateObject private var listStore: ListStore
  
  init() {
    var addressStore: AddressStore
    let listStore: ListStore
    do {
      addressStore = try AddressStore(withChecking: true)
      listStore = try ListStore(withCheck: true)
    } catch {
      print("Could not load address data")
      do {
        addressStore = try AddressStore()
        listStore = try ListStore()
      } catch {
        fatalError("FatalError")
      }
    }
    _listStore = StateObject(wrappedValue: listStore)
    _addressStore = StateObject(wrappedValue: addressStore)
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(addressStore)
        .environmentObject(listStore)
        .environmentObject(LocationIndicatorManager())
    }
  }
}
