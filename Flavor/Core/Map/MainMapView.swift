//
//  MainMapView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-17.
//

import SwiftUI
import MapKit
import Iconoir

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct MainMapView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    
    
    @StateObject var viewModel = MapViewModel()
    @State var showdetail = false
    
    @State var searchText = ""
    
    @EnvironmentObject var sceneController: SceneController

    var body: some View {
        ZStack{
            ZStack{
                MapReader { reader in
                    Map(position: $cameraPosition, selection: $viewModel.MKselectedLocation) {
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
                        
                        if let selectedLocationCoordingate = viewModel.selectedLocationCoordingate {
                            Annotation("", coordinate: selectedLocationCoordingate){
                                Circle()
                                    .foregroundStyle(.colorOrange)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        
                        ForEach(viewModel.MKresults, id: \.self) { item in
                            let placeMark = item.placemark
                            
                            var identifier: LocationIdentifiers {
                                switch item.pointOfInterestCategory {
                                case .airport:
                                    return LocationIdentifiers(image: "airplane", color: .mint)
                                case .restaurant:
                                    return LocationIdentifiers(image: "fork.knife", color: .colorOrange)
                                case .store, .foodMarket:
                                    return LocationIdentifiers(image: "cart", color: .colorYellow)
                                default:
                                    return LocationIdentifiers(image: "mappin", color: .colorOrange)
                                }
                            }
                           
                            
                            /*Marker(placeMark.name ?? "", coordinate: placeMark.coordinate)
                                .foregroundStyle(.colorOrange)
                                .tint(Color(.colorWhite))*/
                            
                            Marker(placeMark.name ?? "", systemImage: identifier.image, coordinate: placeMark.coordinate)
                                .tint(identifier.color)
                            
                           
                            
                           // MapMarker(coordinate: placeMark.coordinate, tint: .colorOrange)
                            
                        /*   Annotation(placeMark.name ?? "", coordinate: placeMark.coordinate) {
                                ZStack{
                                    Circle()
                                        .fill(Color(.colorWhite))
                                        .frame(width: 24, height: 24)
                                        .shadow(radius: 5)
                                    
                                    
                                    
                                    Image(systemName: locationImageString)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(Color(.systemGray4))
                                        .frame(width: 16, height: 16)
                                        
                                }.scaleEffect(item == viewModel.MKselectedLocation ? 2 : 1)
                                    .padding(.bottom, 10)
                                    .onAppear{
                                        if item.pointOfInterestCategory == .restaurant {
                                            locationImageString = "fork.knife"
                                        } else if item.pointOfInterestCategory == .store {
                                            locationImageString = "cart"
                                        }
                                    }
                                
                            }*/
                                
                            
                                
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
                    .onChange(of: viewModel.selectedLocationCoordingate){
                        if let selectedLocationCoordingate = viewModel.selectedLocationCoordingate {
                            cameraPosition = .region(MKCoordinateRegion(center: selectedLocationCoordingate, latitudinalMeters: 10000, longitudinalMeters: 10000))
                        }
                    }
                    .onChange(of: viewModel.MKselectedLocation){
                        
                        withAnimation{
                            if let selectedLocation = viewModel.MKselectedLocation {
                                
                                print("DEBUG APP SELECTED LOCATION NAME: \(selectedLocation.name)")
                                cameraPosition = .region(MKCoordinateRegion(center: selectedLocation.placemark.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000))
                                
                                showdetail.toggle()
                            }
                        }
                    
                }
                }
               
                
                VStack{
                    
                   /* HStack{
                        
                        Button(action: {
                            viewModel.showSearch.toggle()
                        }) {
                            ZStack{
                                Circle()
                                    .fill(.colorWhite)
                                    .frame(width: 32, height: 32)
                                
                                Iconoir.search.asImage
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.colorOrange)
                            }
                        }
                        Spacer()
                    }.padding(.horizontal, 16)*/
                    
                    
                    Button(action: {
                        viewModel.showSearch.toggle()
                    }){
                        HStack{
                            Iconoir.search.asImage
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.colorOrange)
                            
                            if viewModel.queryFragment == "" {
                                Text("Search...")
                                    .font(.primaryFont(.P1))
                                    .foregroundStyle(Color(.systemGray))
                            } else {
                                Text(viewModel.queryFragment)
                                    .font(.primaryFont(.P1))
                                    .foregroundStyle(.black)
                            }
                            
                            Spacer()
                        }.frame(height: 37)
                            .padding(.horizontal, 8)
                            .background(RoundedRectangle(cornerRadius: 8).fill(.colorWhite).stroke(Color(.systemGray4)))
                            .padding(.horizontal, 16)
                    }
                    Spacer()
                }
            }.fullScreenCover(isPresented: $viewModel.showSearch, content: {
                MapSearchView()
                    .environmentObject(viewModel)
            })
            .sheet(isPresented: $showdetail) {
                
                let height = UIScreen.main.bounds.height
                
                if let selectededLocation = viewModel.MKselectedLocation {
                    LocationDetailView(MKMapItem: selectededLocation, mapVM: viewModel)
                        //.presentationDetents([.height(440)])
                       // .presentationBackgroundInteraction(.enabled(upThrough: .height(440)))
                        .ignoresSafeArea()
                        .presentationDetents([.height(viewModel.maxHeightSheet ? height : 440)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(viewModel.maxHeightSheet ? height : 440)))
                        .presentationCornerRadius(12)
                        .presentationDragIndicator(.visible)
                        .environmentObject(sceneController)
                        
                }
                
            }
            
        }
    }
    
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        
        let results = try? await MKLocalSearch(request: request).start()
        
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

struct LocationIdentifiers{
    let image: String
    let color: Color
}
