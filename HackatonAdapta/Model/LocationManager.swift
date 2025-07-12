//
//  LocationManager.swift
//  HackatonAdapta
//
//  Created by Hannah Goldstein on 12/07/25.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func getLocation() async -> CLLocationCoordinate2D? {
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            requestLocation()
        }
    }

    private var continuation: CheckedContinuation<CLLocationCoordinate2D?, Never>?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastKnownLocation = location.coordinate
        continuation?.resume(returning: location.coordinate)
        continuation = nil
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter localização: \(error.localizedDescription)")
    }
}

