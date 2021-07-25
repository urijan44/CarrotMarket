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
  @State var showEmptyLocation: Bool = false
  @EnvironmentObject var legal: LegalDongLibrary
  @State var maxRange: Int = 100
  @Binding var setToIndexZero: Bool
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
          if locationStore.selectedLocation.isEmpty {
            showEmptyLocation.toggle()
          } else {
            presentationMode.wrappedValue.dismiss()
          }
        } label: {
          Image(systemName: "arrow.backward")
        }
        .alert(isPresented: $showEmptyLocation, content: {
          Alert(title: Text(NSLocalizedString("You must select at least 1 location.", comment: "emptyLocation")))
        })
        .foregroundColor(.black)
        Spacer()
        Text("검색 필드")
      }
      .padding([.leading, .trailing], 10)
      CurrentLocationButton()
        .padding()
      HStack {
        Text(NSLocalizedString("Near Location", comment: "neighborhood"))
        #if DEBUG
        Text("target index: \(index)")
        #endif
      }
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
                if setToIndexZero {
                  locationStore.setStoredLocate(area.dong, 0)
                  setToIndexZero = false
                } else {
                  locationStore.setStoredLocate(area.dong, 1)
                }
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
          print("page index: \(index)")
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
    AreaSearchView(setToIndexZero: .constant(true), index: 0)
      .environmentObject(LocationStore())
      .environmentObject(LegalDongLibrary())
  }
}
