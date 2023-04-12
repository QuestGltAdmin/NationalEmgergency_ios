//
//  LocationManager.swift
//  Task
//
//  Created by Nidhi on 21/02/18.
//  Copyright © 2018 Nidhi. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol LocationManagerDelegate {
    @objc optional func locationManager(didFailWithError error: Error)
    @objc optional func locationManager(didChangeAuthorization status: CLAuthorizationStatus)
    @objc optional func locationManager(didUpdateLocations location: CLLocation)
}


class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    
    fileprivate var locationManager: CLLocationManager!
    fileprivate var currentLocation: CLLocation!
    static var sharedLocationManager: CLLocationManager {
        get {
            if shared.locationManager == nil {
                shared.locationManager = CLLocationManager()
                shared.locationManager.delegate = shared
                shared.locationManager.requestAlwaysAuthorization()
            }
            return shared.locationManager
        }
    }
    
    var delegate: LocationManagerDelegate?

    static func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func startMonitoringLocation() {
        if LocationManager.isLocationServicesEnabled() {
            LocationManager.sharedLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.sharedLocationManager.distanceFilter = kCLDistanceFilterNone
            LocationManager.sharedLocationManager.startUpdatingLocation()
        }
    }
    
    static func getCurrentLoaction() -> CLLocation {
        if let location = shared.currentLocation {
            return location
        } else if let location = sharedLocationManager.location {
            return location
        }
        return CLLocation(latitude: 0.0, longitude: 0.0)
    }
    
    static func getCurrentLoactionCoordinate() -> CLLocationCoordinate2D {
        if let location = shared.currentLocation {
            return location.coordinate
        } else if let location = sharedLocationManager.location {
            return location.coordinate
        }
        return kCLLocationCoordinate2DInvalid
    }
    
    
    //MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let delegate = delegate {
            delegate.locationManager?(didFailWithError: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted, .denied:
            break
        default:
            self.startMonitoringLocation()
            break
        }
        if let delegate = delegate {
            delegate.locationManager?(didChangeAuthorization: status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            if let delegate = delegate {
                delegate.locationManager?(didUpdateLocations: location)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
}
