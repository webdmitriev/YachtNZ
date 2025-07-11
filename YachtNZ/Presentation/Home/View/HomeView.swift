//
//  HomeView.swift
//  YachtNZ
//
//  Created by Олег Дмитриев on 05.07.2025.
//

import SwiftUI
import MapKit
import CoreLocation

//sailboat.circle.fill
//dot.scope
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var userLocation: CLLocationCoordinate2D?
    
    // Настройки масштабирования
    private let defaultZoomSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    private let zoomInFactor: Double = 0.5
    private let zoomOutFactor: Double = 2.0
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                
                // MARK: Yacht
                if let yachtLocation = viewModel.currentLocation {
                    Annotation(
                        "My Yacht",
                        coordinate: yachtLocation,
                        anchor: .bottom
                    ) {
                        Image("yacht-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 52, height: 52)
                    }
                }
                
                // MARK: Ancor
                ForEach(viewModel.anchorAnnotations, id: \.id) { anchor in
                    Annotation(
                        anchor.title ?? "Anchor",
                        coordinate: anchor.coordinate,
                        anchor: .bottom
                    ) {
                        Image(anchor.isActive ? "anchor-green" : "anchor-orange")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .mapStyle(.standard(elevation: .flat))
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .onChange(of: viewModel.currentLocation) { oldLocation, newLocation in
                userLocation = newLocation
            }
            .ignoresSafeArea()
            
            // Интерфейс
            VStack {
                header
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                HStack {
                    Spacer()
                    
                    // Группа кнопок управления картой
                    VStack(spacing: 12) {
                        locationButton
                        zoomButton(systemName: "plus", action: zoomIn)
                        zoomButton(systemName: "minus", action: zoomOut)
                    }
                }
                .padding(.trailing, 16)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.startTracking()
            viewModel.loadAnchors()
        }
        .onReceive(viewModel.$currentLocation) { newLocation in
            guard let newLocation = newLocation else { return }
            userLocation = newLocation
            
            if visibleRegion == nil {
                position = .region(MKCoordinateRegion(
                    center: newLocation,
                    span: defaultZoomSpan
                ))
            }
        }
    }
    
    // MARK: components
    var header: some View {
        HStack(spacing: 16) {
            Button {
                //
            } label: {
                Image(systemName: "plus")
                    .frame(width: 24, height: 24)
            }
            
            TextField("Find your place", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: .infinity)
            
            Button {
                //
            } label: {
                Image(systemName: "magnifyingglass")
                    .frame(width: 24, height: 24)
            }
        }
        .padding(12)
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    // Кнопка масштабирования
    private func zoomButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .bold))
                .frame(width: 40, height: 40)
                .background(.thickMaterial)
                .cornerRadius(8)
                .shadow(radius: 3)
        }
    }
    
    // Кнопка локации
    private var locationButton: some View {
        Button(action: centerOnUserLocation) {
            Image(systemName: "location.fill")
                .font(.system(size: 18, weight: .bold))
                .frame(width: 40, height: 40)
                .background(.thickMaterial)
                .cornerRadius(8)
                .shadow(radius: 3)
                .foregroundColor(viewModel.currentLocation != nil ? .blue : .gray)
        }
        .disabled(viewModel.currentLocation == nil)
    }
    
    
    // MARK: Логика карты
    // Центрирование на яхте пользователя
    private func centerOnUserLocation() {
        guard let yachtLocation = viewModel.currentLocation else {
            print("Location not available")
            return
        }
        
        withAnimation(.easeInOut(duration: 0.5)) {
            position = .region(MKCoordinateRegion(
                center: yachtLocation,
                span: defaultZoomSpan
            ))
        }
    }
    
    // Увеличение
    private func zoomIn() {
        withAnimation {
            if let region = visibleRegion {
                let newSpan = MKCoordinateSpan(
                    latitudeDelta: max(region.span.latitudeDelta * zoomInFactor, 0.001),
                    longitudeDelta: max(region.span.longitudeDelta * zoomInFactor, 0.001)
                )
                position = .region(MKCoordinateRegion(center: region.center, span: newSpan))
            }
        }
    }
    
    // Уменьшение
    private func zoomOut() {
        withAnimation {
            if let region = visibleRegion {
                let newSpan = MKCoordinateSpan(
                    latitudeDelta: min(region.span.latitudeDelta * zoomOutFactor, 180),
                    longitudeDelta: min(region.span.longitudeDelta * zoomOutFactor, 180)
                )
                position = .region(MKCoordinateRegion(center: region.center, span: newSpan))
            }
        }
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
