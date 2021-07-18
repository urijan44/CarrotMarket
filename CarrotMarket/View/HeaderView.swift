//
//  HeaderView.swift
//  HeaderView
//
//  Created by hoseung Lee on 2021/07/16.
//

import SwiftUI

struct HeaderView: View {
  var title: String
  var body: some View {
    VStack {
      Text("\(title)")
        .fontWeight(.bold)
    }
  }
}

struct HeaderView_Previews: PreviewProvider {
  static var previews: some View {
    HeaderView(title: "내 동네 설정하기")
      .previewLayout(.sizeThatFits)
  }
}
