//
//  HomeView.swift
//  YachtNZ
//
//  Created by Олег Дмитриев on 05.07.2025.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Map {
                // My Yacht
                if let userLocation = viewModel.currentLocation {
                    Annotation(
                        "My Yacht",
                        coordinate: userLocation,
                        anchor: .bottom
                    ) {
                        Image("yacht-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 52, height: 52)
                    }
                }
                
                // Anchors
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
            .mapStyle(.standard(
                elevation: .flat,
                emphasis: .muted, pointsOfInterest: .excludingAll,
                showsTraffic: false
            ))
            .mapControls {
                MapUserLocationButton()
                //MapCompass()
                //MapScaleView()
            }
        }
        .onAppear {
            viewModel.startTracking()
            viewModel.loadAnchors()
        }
        .overlay(alignment: .topLeading) {
            Button {
//                showMapStylePicker.toggle()
            } label: {
                Image(systemName: "map.fill")
                    .padding(10)
                    .background(.thinMaterial)
                    .clipShape(Circle())
            }
            .padding()
//            .confirmationDialog("Select Map Style",
//                                isPresented: $showMapStylePicker) {
//                Button("Standard") { mapStyle = .standard }
//                Button("Hybrid") { mapStyle = .hybrid }
//                Button("Satellite") { mapStyle = .imagery }
//            }
        }
    }
}
