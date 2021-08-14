//
//  NearLocationView.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/08/12.
//

import SwiftUI

struct NearLocationView: View {
  var nearLocation: [String]

  var body: some View {
    ScrollView {
      ForEach(nearLocation, id: \.self) { legal in
        DongView(dong: legal)
          .padding(4)
      }
    }
    .padding(.top, 5)
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
