//
//  AreaSearchView.swift
//  AreaSearchView
//
//  Created by hoseung Lee on 2021/07/16.
//

import SwiftUI
import CoreLocation

struct AreaSearchView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var locationStore: LocationStore
  @State var showDuplicatedLocate: Bool = false
  @State var showEmptyLocation: Bool = false
  @EnvironmentObject var legal: LegalDongLibrary
  @State var maxRange: Int = 100
  @Binding var setToIndexZero: Bool
  @State var searchQuery: String = ""
  @State var currentLocation: CLLocation?
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
        HStack {
          Image(systemName: "magnifyingglass")
          TextField("Search", text: $searchQuery)
        }
        .underlineTextField()
      }
      .padding([.leading, .trailing], 10)
      Button {
        print("find address")
      } label: {
        CurrentLocationButton(currentLocation: $currentLocation)
          .padding()
      }
      HStack {
        Text(NSLocalizedString("Near Location", comment: "neighborhood"))
        #if DEBUG
//        Text("target index: \(index)")
        Text("coordinate: \(currentLocation?.coordinate.latitude ?? CLLocation().coordinate.latitude)")
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

extension View {
  func underlineTextField() -> some View {
    self
      .padding(.vertical, 10)
      .overlay(Rectangle().frame(height: 2).padding(.top, 35))
      .foregroundColor(.secondary)
      .padding(10)
  }
}


struct AreaSearchView_Previews: PreviewProvider {
  static var previews: some View {
    AreaSearchView(setToIndexZero: .constant(true), index: 0)
      .environmentObject(LocationStore())
      .environmentObject(LegalDongLibrary())
  }
}
