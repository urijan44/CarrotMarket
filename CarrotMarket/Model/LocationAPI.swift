//
//  LocationAPI.swift
//  LocationAPI
//
//  Created by hoseung Lee on 2021/08/03.
//

import Foundation
import CoreLocation

struct LocationAPI {

  let baseURLString = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?"

  func fetchAddress(location: CLLocation) {
    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    var components = URLComponents(string: baseURLString)
    let coordinate = URLQueryItem(name: "coords", value: "\(longitude.description),\(latitude.description)" )
    let orders = URLQueryItem(name: "orders", value: "admcode")
    let output = URLQueryItem(name: "output", value: "json")
    components?.queryItems = [coordinate, orders, output]
    let urlString = components?.url
    print(urlString?.description ?? "")
    var request = URLRequest(url: urlString!)
    request.httpMethod = "GET"
    guard let apiKeyId = Bundle.main.infoDictionary?["NCMapKeyID"] as? String else {
      return
    }
    guard let apiKey = Bundle.main.infoDictionary?["NCMapKey"] as? String else {
      return
    }
    request.setValue(apiKeyId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
    request.setValue(apiKey, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data, let response = response {
        #if DEBUG
        print(String(data: data, encoding: .utf8) ?? "error", response)
        #endif
        
      }
      if let error = error {
        #if DEBUG
        print(error.localizedDescription)
        #endif
      }
    }
    .resume()
  }
}

struct AreaCoords {
  var location: CLLocation

  enum CodingKeys: CodingKey {
//    case 
  }

}
