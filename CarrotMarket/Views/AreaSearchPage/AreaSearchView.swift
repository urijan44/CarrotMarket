//
//  AreaSearchView.swift
//  AreaSearchView
//
//  Created by hoseung Lee on 2021/07/16.
//

import SwiftUI
import UIKit
import CoreLocation

struct AreaSearchView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var locationIndicatorManager: LocationIndicatorManager
  @EnvironmentObject var addressStore: AddressStore
  @EnvironmentObject var listStore: ListStore
  @State private var showDuplicatedLocate: Bool = false
  @State private var showEmptyLocation: Bool = false
  @State private var currentLocation: CLLocation?
  @State private var searchQuery = ""
  var index: Int

  var body: some View {
    VStack {
      //MARK: - Search View
      SearchFieldView(searchQuery: $searchQuery)
      //MARK: current location get button
      CurrentLocationButton(currentLocation: $currentLocation)
        .padding([.leading, .trailing, .bottom])
      //MARK: Description
      NearLocationLabel()
      //MARK: LIST
      LocationListView(searchQuery: $searchQuery, index: index)
    }
    .navigationBarHidden(true)
  }
}

struct NearLocationLabel: View {
  var body: some View {
    HStack {
      Text(NSLocalizedString("Near Location", comment: "neighborhood"))
        .font(.body)
        .padding(.leading)
      Spacer()
    }
  }
}

struct LocationListView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var addressStore: AddressStore
  @EnvironmentObject var LocationIndicatorManager: LocationIndicatorManager
  @EnvironmentObject var listStore: ListStore
  @State var showDuplicatedLocate: Bool = false
  @Binding var searchQuery: String
  var index: Int
  
  var matchingAddresses: [AddressModel] {
    var matchingAddresses = addressStore.sortedAddresses
    if !searchQuery.isEmpty {
      matchingAddresses = matchingAddresses.filter {
        $0.city.contains(searchQuery) || $0.dong.contains(searchQuery) || $0.gu.contains(searchQuery)
      }
    }
    return matchingAddresses
  }
  
  var body: some View {
    List {
      ForEach(matchingAddresses, id: \.self) { area in
        HStack {
          Text("\(area.city) \(area.gu) \(area.dong)")
          Spacer()
        }
        .contentShape(Rectangle())
        // MARK: - Tap Gesture
        .onTapGesture {
          
          do {
            try addressStore.updateData(location: area.location)
          } catch {
            print(error)
          }
          
          if LocationIndicatorManager.storedLocate.contains(area.dong) {
            showDuplicatedLocate = true
          } else {
            LocationIndicatorManager.setIndicator(area.dong)
            
            if index == 0 {
              LocationIndicatorManager.setStoredLocate(area.dong, 0)
              if listStore.storedLists.count > 0 {
                listStore.storedLists[0] = addressStore.sortedAddresses
              } else {
                listStore.storedLists.append(addressStore.sortedAddresses)
              }
              // index == 1
            } else {
              LocationIndicatorManager.setStoredLocate(area.dong, 1)
              if listStore.storedLists.count > 1 {
                listStore.storedLists[1] = addressStore.sortedAddresses
              } else {
                listStore.storedLists.append(addressStore.sortedAddresses)
              }
            }
            LocationIndicatorManager.setSelectedLocation(LocationIndicatorManager.buttonIndicator)
          }
          do {
            try listStore.save()
          } catch {
            print(error)
          }
          
          presentationMode.wrappedValue.dismiss()
        }
//        .alert(isPresented: $showDuplicatedLocate) {
//          Alert(
//            //?????? ????????? ????????????.
//            title: Text(NSLocalizedString("It's already located", comment: "alreadyLocated"))
//          )
//        }
      }
    }
    .id(UUID())
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
    AreaSearchView(index: 0)
      .environmentObject(LocationIndicatorManager())
      .environmentObject(try! AddressStore())
  }
}
