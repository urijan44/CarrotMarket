//
//  LocationQuery.swift
//  LocationQuery
//
//  Created by hoseung Lee on 2021/07/25.
//

import Foundation
import MapKit
import Combine

final class LocationQuery: ObservableObject {
  @Published var searchQuery = ""
}
