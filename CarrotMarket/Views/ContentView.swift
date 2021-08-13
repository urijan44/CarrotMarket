//
//  ContentView.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/18.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var locationStore: LocationIndicatorManager
  @State var showMyAreaSetup = false
  var body: some View {
    VStack {
      Text(locationStore.selectedLocation)
      Button {
        showMyAreaSetup.toggle()
      } label: {
//        Text("내 동네 설정하기")
        Text(NSLocalizedString("Set My Location", comment: "setMyLocation"))
      }
      .fullScreenCover(isPresented: $showMyAreaSetup) {
        MyAreaSetupView()
      }
    }
  }
}
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(LocationIndicatorManager())
  }
}
