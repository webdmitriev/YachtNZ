//
//  HomeViewModel.swift
//  YachtNZ
//
//  Created by Олег Дмитриев on 05.07.2025.
//

import Foundation
import Combine
import MapKit

final class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var anchorAnnotations: [Anchor] = []
    @Published var searchText: String = ""
    
    private let locationManager = CLLocationManager()
    
    func startTracking() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func loadAnchors() {
        anchorAnnotations = [
            Anchor(id: "1", coordinate: CLLocationCoordinate2D(latitude: -44.654579, longitude: 167.9112), title: "Safe Bay", isActive: true),
            Anchor(id: "2", coordinate: CLLocationCoordinate2D(latitude: -44.644579, longitude: 167.9117), title: "Reef Point", isActive: false)
        ]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
        }
    }
}
