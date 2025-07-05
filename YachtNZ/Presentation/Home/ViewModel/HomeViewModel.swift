//
//  HomeViewModel.swift
//  YachtNZ
//
//  Created by Олег Дмитриев on 05.07.2025.
//

import Foundation
import Combine
import MapKit

final class HomeViewModel: NSObject, ObservableObject {
    private let locationManager = LocationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var heading: Double = 0
    
    @Published var annotations: [IdentifiableAnnotation] = []
    @Published var anchorAnnotations: [IdentifiableAnnotation] = []
    
    func startTracking() {
        locationManager.startTracking()
        
        locationManager.$currentCoordinate
            .sink { [weak self] coordinate in
                self?.currentLocation = coordinate
            }
            .store(in: &cancellables)
        
        locationManager.$heading
            .sink { [weak self] heading in
                self?.heading = heading
            }
            .store(in: &cancellables)
    }
    
    func loadAnchors() {
        let mockAnchors = [
            (coordinate: CLLocationCoordinate2D(latitude: -44.654579, longitude: 167.9112),
             title: "Anchor #1 (Safe Bay)", isActive: true),
            (coordinate: CLLocationCoordinate2D(latitude: -44.644579, longitude: 167.9117),
             title: "Anchor #2 (Reef Point)", isActive: false),
            (coordinate: CLLocationCoordinate2D(latitude: -44.634579, longitude: 167.9120),
             title: "Anchor #3 (Storm Shelter)", isActive: true),
            (coordinate: CLLocationCoordinate2D(latitude: -44.624579, longitude: 167.9125),
             title: "Anchor #4 (Deep Water)", isActive: false)
        ]
        
        anchorAnnotations = mockAnchors.map { item in
            let annotation = MKPointAnnotation()
            annotation.coordinate = item.coordinate
            annotation.title = item.title
            return IdentifiableAnnotation(
                coordinate: item.coordinate,
                title: item.title,
                isActive: item.isActive
            )
        }
    }
}
