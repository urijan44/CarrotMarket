//
//  LegalDong.swift
//  CarrotMarket
//
//  Created by hoseung Lee on 2021/07/18.
//

import Foundation
import CoreLocation

//행정코드, 시, 구, 동(읍면)

class AddressModel: Codable {
  var id = UUID()
  var hcode: String = ""
  var city: String = ""
  var gu: String = ""
  var dong: String = ""
  var longitude: Double = 0.0
  var latitude: Double = 0.0
  var distance: Double = 0.0
  
  enum CodingKeys: CodingKey {
    case id, hcode, city, gu, dong, longitude, latitude, distance
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(hcode, forKey: .hcode)
    try container.encode(city, forKey: .city)
    try container.encode(gu, forKey: .gu)
    try container.encode(longitude, forKey: .longitude)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(distance, forKey: .distance)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    hcode = try container.decode(String.self, forKey: .hcode)
    city = try container.decode(String.self, forKey: .city)
    gu = try container.decode(String.self, forKey: .gu)
    dong = try container.decode(String.self, forKey: .dong)
    longitude = try container.decode(Double.self, forKey: .longitude)
    latitude = try container.decode(Double.self, forKey: .latitude)
    distance = try container.decode(Double.self, forKey: .distance)
  }
}

extension AddressModel: Equatable {
  static func == (lhs: AddressModel, rhs: AddressModel) -> Bool {
    lhs === rhs
  }
}

extension AddressModel: Hashable, Identifiable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension AddressModel {
  var location: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }
}


