//
//  LegalDong.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/18.
//

import Foundation

//행정코드, 시, 구, 동(읍면)

class Legal {
  var id = UUID()
  var hcode: String = ""
  var city: String = ""
  var gu: String = ""
  var dong: String = ""
  var xPoint: Double?
  var yPoint: Double?

  init(raw: [String]) {
    hcode = raw[0]
    city = raw[1]
    gu = raw[2]
    dong = raw[3]
  }
}

extension Legal: Equatable {
  static func == (lhs: Legal, rhs: Legal) -> Bool {
    lhs === rhs
  }
}

extension Legal: Hashable, Identifiable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
