//
//  AreaSearchView.swift
//  AreaSearchView
//
//  Created by hoseung Lee on 2021/07/16.
//

import SwiftUI

struct AreaSearchView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var locationStore: LocationStore
  @State var showDuplicatedLocate: Bool = false
  let legal = LegalDongLibrary()
  @State var maxRange: Int = 20000
  var index: Int

  var nextLocateID: UUID {
    guard let locate = legal.legal.first else {
      return legal.legal.last!.id
    }
    return locate.id
  }

  var body: some View {
    VStack {
      HStack {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image(systemName: "arrow.backward")
        }
        .foregroundColor(.black)
        Spacer()
        Text("검색 필드")
      }
      .padding([.leading, .trailing], 10)
      CurrentLocationButton()
        .padding()
      Text(NSLocalizedString("Near Location", comment: "neighborhood"))
      ScrollViewReader { scrollProxy in
        List {
          ForEach(legal.legal[0...maxRange]) { area in
            HStack {
              Text("\(area.city) \(area.gu) \(area.dong)")
              Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: {
              if locationStore.storedLocate.contains(area.dong) {
                showDuplicatedLocate = true
              } else {
                locationStore.setIndicator(area.dong)
                locationStore.setStoredLocate(area.dong, index)
                locationStore.setSelectedLocation(locationStore.buttonIndicator)
              }
              presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showDuplicatedLocate) {
              Alert(
                //이미 설정된 동네에요.
                title: Text(NSLocalizedString("It's already located", comment: "alreadyLocated"))
              )
            }
          }
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            scrollProxy.scrollTo(nextLocateID)
          }
        }
        .id(UUID())
      }
    }
    .navigationBarHidden(true)
  }
}



struct AreaSearchView_Previews: PreviewProvider {
  static var previews: some View {
    AreaSearchView(index: 0)
      .environmentObject(LocationStore())
  }
}
