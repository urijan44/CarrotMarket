//
//  NearLocationView.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/08/12.
//

import SwiftUI

struct NearLocationView: View {
  @EnvironmentObject var legal: AddressStore
  var magnitude: Double
  var count: Int {
    nearLocation.count
  }
  var limit: Double {
    switch magnitude {
    case 0:
      return 1000
    case 1:
      return 3000
    case 2:
      return 5000
    case 3:
      return 10000
    default:
      return 10000
    }
  }
  
  var nearLocation: [String] {
    var returning: [String] = []
    legal.sortedAddresses.forEach {
      if $0.distance <= self.limit {
        returning.append($0.dong)
      }
    }
    return returning
  }
  var body: some View {
    ScrollView {
      ForEach(nearLocation, id: \.self) {
        DongView(dong: $0)
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
    NearLocationView(magnitude: 0)
      .environmentObject(AddressStore())
  }
}
