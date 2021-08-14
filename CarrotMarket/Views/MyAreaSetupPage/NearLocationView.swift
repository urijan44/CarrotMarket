////
////  NearLocationView.swift
////  CarrotMarket
////
////  Created by hoseung Lee on 2021/08/12.
////
//
//import SwiftUI
//
//struct NearLocationView: View {
//  @EnvironmentObject var addressStore: AddressStore
//
//  var body: some View {
//    ScrollView {
//      ForEach(nearLocation, id: \.self) {
//        DongView(dong: $0)
//          .padding(4)
//      }
//    }
//    .padding(.top, 5)
//  }
//}
//
//private struct DongView: View {
//  var dong: String
//  var body: some View {
//    HStack {
//      Text(dong)
//        .font(.footnote)
//      Spacer()
//    }
//  }
//}
//
//struct NearLocationView_Previews: PreviewProvider {
//  static var previews: some View {
//    NearLocationView()
//      .environmentObject(try! AddressStore())
//  }
//}
