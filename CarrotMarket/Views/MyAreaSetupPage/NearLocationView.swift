//
//  NearLocationView.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/08/12.
//

import SwiftUI

struct NearLocationView: View {
  @Environment(\.presentationMode) var presentationMode
  var nearLocation: [String]
  
  var body: some View {
    VStack {
      ZStack {
        HStack{
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image(systemName: "arrow.backward")
              .foregroundColor(.black)
          }
          .padding(.leading)
          Spacer()
        }
        Text(NSLocalizedString("Near Location \(nearLocation.count)", comment: "neighborhood"))
      }
      Divider()
      ScrollView {
        ForEach(nearLocation, id: \.self) { legal in
          DongView(dong: legal)
            .padding(4)
        }
        .padding(.leading)
      }
      .padding(.top, 5)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarHidden(true)
    }
  }
}

private struct DongView: View {
  var dong: String
  var body: some View {
    HStack {
      Text(dong)
        .font(.footnote)
      Spacer()
    }
  }
}

struct NearLocationView_Previews: PreviewProvider {
  static var previews: some View {
    NearLocationView(nearLocation: ["구로동","신대방동","가리방동"])
  }
}
