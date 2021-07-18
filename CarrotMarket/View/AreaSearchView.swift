//
//  AreaSearchView.swift
//  AreaSearchView
//
//  Created by hoseung Lee on 2021/07/16.
//

import SwiftUI

struct AreaSearchView: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var locateName: String?
  @Binding var selectedLocate: String?
  @Binding var locateNames: [String?]
  @State var showDuplicatedLocate: Bool = false

  let legal = LegalDongLibrary()
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
      Text("근처 동네")
      List {
        ForEach(legal.legal) { area in
          HStack {
            Text("\(area.city) \(area.gu) \(area.dong)")
            Spacer()
          }
          .contentShape(Rectangle())
          .onTapGesture(perform: {
            if locateNames.contains(area.dong) {
              showDuplicatedLocate = true
            } else {
              locateName = area.dong
              selectedLocate = locateName
            }
            presentationMode.wrappedValue.dismiss()
          })
          .alert(isPresented: $showDuplicatedLocate) {
            Alert(
              title: Text("이미 설정된 동네에요.")
            )
          }
        }
      }
    }
    .navigationBarHidden(true)
  }
}



struct AreaSearchView_Previews: PreviewProvider {
  static var previews: some View {
    AreaSearchView(locateName: .constant(nil), selectedLocate: .constant(nil), locateNames: .constant([nil]))
  }
}
