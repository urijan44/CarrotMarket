//
//  MyAreaSetupView.swift
//  MyAreaSetupView
//
//  Created by hoseung Lee on 2021/07/17.
//

import SwiftUI

struct MyAreaSetupView: View {
  @EnvironmentObject var locationIndicatorManager: LocationIndicatorManager
  @EnvironmentObject var addressStore: AddressStore
  @EnvironmentObject var listStore: ListStore
  @Environment(\.presentationMode) var presentationMode
  @State var areaRange = 0.0
  @State var sliderChanged = false
  @State var showAreaSearch: Bool = false
  @State var lastOne: Bool = false
  @State var showWillApearAreaSearch: Bool = false
  
  
  @ViewBuilder func lrLocationSelectButton(index: Int) -> some View {
    if locationIndicatorManager.storedLocate[index] != nil {
      ZStack {
        HStack {
          Button {
            locationIndicatorManager.setSelectedLocation(locationIndicatorManager.storedLocate[index])
            locationIndicatorManager.setIndicator(locationIndicatorManager.selectedLocation)
          } label: {
            HStack {
              VStack {
                Text("\(locationIndicatorManager.storedLocate[index] ?? "")")
              }
              Spacer()
              RemoveLocateButton(showAreaSearch: $showAreaSearch, lastOne: $lastOne, index: index)
            }
          }
          .buttonStyle(PlaceButtonStyle(index: index))
        }
      }
    }
  }

  var body: some View {
    NavigationView {
      VStack {
        //MARK: - Header Section
        ZStack {
          xButton
            .padding(.leading, 10)
          HeaderView(title: NSLocalizedString("Set My Location", comment: "setMyLocation"))
        }
        .padding(5)
        Divider()

        //MARK: - 동네 선택 Section
        VStack {
          Text(NSLocalizedString("Select Location", comment: "selectLocation"))
            .padding(.bottom, 5)
            Text(NSLocalizedString("A minimum of 1 and a maximum of 2 regions are allowed.", comment: "min1max2"))
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.bottom, 18)
          HStack {
            if locationIndicatorManager.storedLocate[0] == nil {
              NavigationLink(destination: AreaSearchView(index: 0), isActive: $showWillApearAreaSearch) {
                EmptyLocateView()
              }
            } else {
              lrLocationSelectButton(index: 0)
            }
            
            if locationIndicatorManager.storedLocate[1] == nil {
              NavigationLink(destination: AreaSearchView(index: 1)) {
                EmptyLocateView()
              }
            } else {
              lrLocationSelectButton(index: 1)
            }
          }
          Text(locationIndicatorManager.selectedLocation)
          Divider()
            .padding(5)

          //MARK: - 동네 범위 Section, Slider
          HStack {
              Text("\(locationIndicatorManager.selectedLocation)")
              .padding(.trailing, 1)
            if locationIndicatorManager.selectedLocation == locationIndicatorManager.storedLocate[0] {
              if listStore.storedLists.count > 0 {
                NearLocationLabelView(magnitude: $areaRange, index: 0)
              }
            } else if locationIndicatorManager.selectedLocation == locationIndicatorManager.storedLocate[1] {
              if listStore.storedLists.count > 1 {
                NearLocationLabelView(magnitude: $areaRange, index: 1)
              } else {
                EmptyView()
              }
            }
          }
          .padding(.bottom, 5)
          Text(NSLocalizedString("You can see only the selected range of posts.", comment: "readRange"))
            .font(.caption)
            .foregroundColor(.secondary)
          VStack {
            SliderView(sliderValue: $areaRange, sliderChanged: $sliderChanged)
              .animation(.easeOut)
            HStack {
              Text(NSLocalizedString("My Location", comment: "mylocation"))
              Spacer()
              Text(NSLocalizedString("Near Location", comment: "neighborhood"))
            }
            .font(.caption)
            .foregroundColor(.gray)
          }

          //MARK: - 인터랙션 이미지
          Image("map")
            .resizable()
            .scaledToFit()
            .padding()
          Spacer()
        }
        .padding()
      }
      .onAppear{
        if locationIndicatorManager.selectedLocation.isEmpty {
          showWillApearAreaSearch = true
        }
      }
      .navigationBarHidden(true)
    }
  }

  var xButton: some View {
    Button {
      presentationMode.wrappedValue.dismiss()
    } label: {
      HStack {
        Image(systemName: "xmark")
          .foregroundColor(.black)
        Spacer()
      }
    }
  }
}

private struct PlaceButtonStyle: ButtonStyle {
  @EnvironmentObject var locationStore: LocationIndicatorManager
  let index: Int
  func makeBody(configuration: Configuration) -> some View {
    let isSelected = locationStore.selectedLocation == locationStore.storedLocate[index]
    HStack {
      configuration.label
      Spacer()
    }
    .frame(height: buttonHeight)
    .font(.system(size: 16, weight: .heavy, design: .rounded))
    .foregroundColor(isSelected ? .white : .black)
    .padding([.leading, .trailing])
    .buttonPress(isSelected)
  }
}

// buttonPress 상태에 따라 다른 뷰를 반환합니다. 투명 배경, 오렌지 배경
private extension View {
  func buttonPress(_ isPressed: Bool) -> some View {
    self.background(
      !isPressed ? AnyView(normal()) : AnyView(pressed())
    )
  }

  func normal() -> some View {
    RoundedRectangle(cornerRadius: 5)
      .stroke(Color.gray.opacity(0.5), lineWidth: 2)
      .foregroundColor(.clear)
  }

  func pressed() -> some View {
    RoundedRectangle(cornerRadius: 5)
      .foregroundColor(Color.orange)
  }
}

private struct RemoveLocateButton: View {
  @EnvironmentObject var locationIndicatorManager: LocationIndicatorManager
  @EnvironmentObject var listStore: ListStore
  @State private var showAlert = false
  @Binding var showAreaSearch: Bool
  @Binding var lastOne: Bool
  var index: Int

  var locateIsOne: Bool {
    let nonNil = locationIndicatorManager.storedLocate.filter { $0 != nil }.count
    return nonNil == 1
  }

  var alertTitle: String {
    if locateIsOne {
      //"동네가 1개만 선택된 상태에서는 삭제를 할 수 없어요. 현재 설정된 동네를 변경하시겠어요?"
      return NSLocalizedString("If only one location is selected, it cannot be deleted. Would you like to change the currently set location?", comment: "lastOne")
    } else {
      // "선택한 지역을 삭제하시겠습니까?"
      return NSLocalizedString("Are you sure you want to delete the selected region?", comment: "okQ")
    }
  }

  var secondaryButtonAction: String {
    if locateIsOne {
      //변경
      return NSLocalizedString("Change", comment: "change")
    } else {
//      확인
      return NSLocalizedString("Conform", comment: "conform")
    }
  }

  var okAction: () -> Void {
    if locateIsOne {
      func action() {
        showAreaSearch = true
      }
      return action
    } else {
      func action() {
        if index == 1 {
          if locationIndicatorManager.buttonIndicator == locationIndicatorManager.selectedLocation {
            locationIndicatorManager.setSelectedLocation(locationIndicatorManager.storedLocate[0])
            locationIndicatorManager.buttonIndicator = locationIndicatorManager.selectedLocation
          }
        } else {
          locationIndicatorManager.setIndicator(locationIndicatorManager.storedLocate[1])
          locationIndicatorManager.setSelectedLocation(locationIndicatorManager.buttonIndicator)
          locationIndicatorManager.setStoredLocate(locationIndicatorManager.buttonIndicator, 0)
          listStore.storedLists[0] = listStore.storedLists[1]
        }
        locationIndicatorManager.setStoredLocate(nil, 1)
      }
      return action
    }
  }

  var body: some View {
    NavigationLink(destination: AreaSearchView(index: 0), isActive: $showAreaSearch) {
      EmptyView()
    }
    NavigationLink(destination: EmptyView()) {
        EmptyView()
    }
    Button {
      showAlert.toggle()
    } label: {
      Image(systemName: "xmark.circle")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
    }
    .alert(isPresented: $showAlert) {
      Alert(
        title: Text(alertTitle),
        primaryButton:
            .cancel(Text(NSLocalizedString("Cancel", comment: "cancel"))),
        secondaryButton:
            .default(Text(secondaryButtonAction), action: {
              okAction()
            })
      )
    }
  }
}

//MARK: - EmptyButton
private var buttonHeight: CGFloat = 45

private struct EmptyLocateView: View {
  var body: some View {
    ZStack {
      Image(systemName: "plus")
        .foregroundColor(.gray)
      RoundedRectangle(cornerRadius: 5)
        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
        .foregroundColor(.clear)
    }
    .frame(height: buttonHeight)
  }
}

private struct SliderView: View {
  @Binding var sliderValue: Double
  @Binding var sliderChanged: Bool
  var body: some View {
    Slider(
      value: $sliderValue,
      in: 0...3,
      onEditingChanged: { editing in
        sliderChanged = editing
        sliderValue.round()
      }
    )
      .foregroundColor(.orange)
  }
}

struct MyAreaSetupView_Previews: PreviewProvider {
  static var previews: some View {
    MyAreaSetupView()
      .environmentObject(LocationIndicatorManager())
  }
}
