//
//  NearLocationLabelView.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/08/14.
//

import SwiftUI

struct NearLocationLabelView: View {
  @EnvironmentObject var listStore: ListStore
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
    listStore.storedLists[index].forEach {
      if $0.distance <= self.limit {
        returning.append($0.dong)
      }
    }
    return returning
  }
  var index: Int
  var body: some View {
    HStack {
      NavigationLink(destination: NearLocationView(nearLocation: nearLocation)) {
        Text(String(format: NSLocalizedString("Near Location %d", comment: "neighborhoodPlusCount"), nearLocation.count))
          .fontWeight(.bold)
          .underline()
          .foregroundColor(.black)
      }
    }
  }
}

struct NearLocationLabelView_Previews: PreviewProvider {
  static var previews: some View {
    NearLocationLabelView(magnitude: .constant(2), index: 0)
      .previewLayout(.sizeThatFits)
  }
}
