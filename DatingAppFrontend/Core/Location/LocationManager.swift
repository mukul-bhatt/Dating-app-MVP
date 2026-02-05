//
//  LocationManager.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 03/02/26.
//

import Foundation
import CoreLocation
import Combine
import MapKit

import Foundation
import CoreLocation
import Combine
import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var cityName: String?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.authorizationStatus = manager.authorizationStatus
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
    
    // MARK: - Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.location = location
            print("📍 Location Updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            self.reverseGeocode(location: location)
        }
    }
    
    private func reverseGeocode(location: CLLocation) {
        guard let request = MKReverseGeocodingRequest(location: location) else { return }
        
        Task {
            do {
                let mapItems = try await request.mapItems
                if let mapItem = mapItems.first {
                    let city = mapItem.addressRepresentations?.cityName ?? "Unknown"
                    await MainActor.run {
                        self.cityName = city
                        print("📍 Reverse Geocoded City (MapKit Addressing): \(city)")
                    }
                }
            } catch {
                print("❌ MapKit Reverse Geocoding Error: \(error.localizedDescription)")
                await MainActor.run {
                    self.cityName = "Unknown"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location Manager Error: \(error.localizedDescription)")
    }
}
