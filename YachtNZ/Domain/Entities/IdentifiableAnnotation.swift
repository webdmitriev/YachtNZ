//
//  IdentifiableAnnotation.swift
//  YachtNZ
//
//  Created by Олег Дмитриев on 05.07.2025.
//

import MapKit

struct Anchor: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    var title: String?
    var isActive: Bool
}
