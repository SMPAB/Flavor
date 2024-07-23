//
//  MainMapView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-17.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct MainMapView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)

    var body: some View {
        Map(position: $cameraPosition) {
            if let userLocation = locationManager.userLocation {
                Annotation("My location", coordinate: userLocation) {
                    ZStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color(.systemBlue).opacity(0.25))
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                        
                        Circle()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(Color(.systemBlue))
                    }
                }
            }
        }
        .onAppear {
            if let userLocation = locationManager.userLocation {
                cameraPosition = .region(MKCoordinateRegion(center: userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000))
            }
        }
        .onChange(of: locationManager.userLocation) { newLocation in
            if let newLocation = newLocation {
                cameraPosition = .region(MKCoordinateRegion(center: newLocation, latitudinalMeters: 10000, longitudinalMeters: 10000))
            }
        }
    }
}

extension CLLocationCoordinate2D {
    static var defaultUserLocation: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 25.7602, longitude: -80.1959)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return MKCoordinateRegion(center: .defaultUserLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}

#Preview {
    MainMapView()
}


/*
import SwiftUI
import MapKit

struct MainMapView: View {
    
    @State private var cameraPostition: MapCameraPosition = .region(.userRegion)
    var body: some View {
        Map(position: $cameraPostition) {
            Annotation("My location", coordinate: .userLocation){
                ZStack{
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color(.systemBlue).opacity(0.25))
                    
                    Circle().frame(width: 20, height: 20).foregroundStyle(.colorWhite)
                    
                    Circle().frame(width: 12, height: 12).foregroundStyle(Color(.systemBlue))
                }
            }
        }
    }
}


extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 25.7602, longitude: -80.1959)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}

#Preview {
    MainMapView()
}*/
