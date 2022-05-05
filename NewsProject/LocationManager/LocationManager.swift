//
//  LocationManager.swift
//  NewsProject
//
//  Created by Chris Kim on 5/4/22.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    
    var authorized: Bool = false
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    
    func requestAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            let status = locationManager.authorizationStatus
            
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                // TODO: 설정창으로 이동하여 변경할 것
                break
            case .authorizedAlways, .authorizedWhenInUse:
                updateLocation()
            default:
                break
            }
        }
    }
}




extension LocationManager: CLLocationManagerDelegate {
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authorized = true
        default:
            // TODO: Alert!!! -> Goto Setting and turn on
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}
