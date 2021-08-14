//
//  NearLocationLabelView.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/08/14.
//

import SwiftUI

struct NearLocationLabelView: View {
  @EnvironmentObject var addressStore: AddressStore
  @Binding var magnitude: Double
  var count: Int {
    nearLocation.count
  }
  var limit: Double {
    switch Int(round(magnitude)) {
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
    addressStore.sortedAddresses.forEach {
      if $0.distance <= self.limit {
        returning.append($0.dong)
      }
    }
    return returning
  }
  var body: some View {
    HStack {
      NavigationLink(destination: NearLocationView(nearLocation: nearLocation)) {
        Text(NSLocalizedString("Near Location \(nearLocation.count)", comment: "neighborhood"))
          .fontWeight(.bold)
          .underline()
          .foregroundColor(.black)
      }
    }
  }
}

struct NearLocationLabelView_Previews: PreviewProvider {
  static var previews: some View {
    NearLocationLabelView(magnitude: .constant(2))
      .previewLayout(.sizeThatFits)
      .environmentObject(try! AddressStore())
  }
}
