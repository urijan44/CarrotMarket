//
//  SearchFieldView.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/08/14.
//

import SwiftUI

struct SearchFieldView: View {
  @EnvironmentObject var locationIndicatorManager: LocationIndicatorManager
  @Environment(\.presentationMode) var presentationMode
  @State var showEmptyLocation: Bool = false
  @State var searchQuery: String = ""
  
  var body: some View {
    
    HStack {
      Button {
        if locationIndicatorManager.selectedLocation.isEmpty {
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
  }
}

struct SearchFieldView_Previews: PreviewProvider {
  static var previews: some View {
    SearchFieldView()
  }
}
