//
//  LocationManager.swift
//  LocationManager
//
//  Created by hoseung Lee on 2021/07/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func startLocationServices() {
    if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }
}

extension LocationManager: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let latest = locations.first else { return }
    if currentLocation == nil {
      currentLocation = latest
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    guard let clError = error as? CLError else { return }
    switch clError {
    case CLError.denied:
      print("Access denied")
    default:
      print("Catch all errors")
    }
  }
}
