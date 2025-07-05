//
//  IdentifiableAnnotation.swift
//  YachtNZ
//
//  Created by Олег Дмитриев on 05.07.2025.
//

import MapKit

struct IdentifiableAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let isActive: Bool
    
    // Для совместимости с MKPointAnnotation
    init(annotation: MKPointAnnotation) {
        self.coordinate = annotation.coordinate
        self.title = annotation.title
        self.isActive = false
    }
    
    // Новый инициализатор для моков
    init(coordinate: CLLocationCoordinate2D, title: String?, isActive: Bool) {
        self.coordinate = coordinate
        self.title = title
        self.isActive = isActive
    }
}
