//
//  MapViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-23.
//

import Foundation
import MapKit

class MapViewModel: NSObject, ObservableObject {
    
    @Published var showSearch = false
    
    @Published var results = [MKLocalSearchCompletion]()
    private let searchCompleter = MKLocalSearchCompleter()
    @Published var selectedLocationCoordingate: CLLocationCoordinate2D?
    
    @Published var MKselectedLocation: MKMapItem? 
    @Published var MKresults: [MKMapItem] = []
    
    
    @Published var maxHeightSheet = false
    
    
    @Published var showDetail = false
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    
    func selectLocationByText(text: String, coordinates: CLLocationCoordinate2D){
        locationSearchText(coordinates: coordinates, text: text, completion: { respons, error in
            if let error = error {
                return
            }
            
            guard let item = respons?.mapItems.first else { return }
            self.MKselectedLocation = nil
            self.MKresults = respons?.mapItems ?? []
            self.MKselectedLocation = respons?.mapItems.first
        })
    }
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
            locationSearch(forLocalSearchCompletion: localSearch, completion: { respons, error in
                
                if let error = error {
                    return
                }
               /* guard let item = respons?.mapItems.first else { return }
                let coordinate = item.placemark.coordinate
                self.selectedLocationCoordingate = coordinate
                print("DEBUG APP COORDINATES: \(coordinate)")*/
                print("DEBUG APP RESPONS: \(respons?.description)")
                guard let item = respons?.mapItems.first else { return }
                self.MKresults = respons?.mapItems ?? []
                self.MKselectedLocation = respons?.mapItems.first
                
                if self.MKselectedLocation != nil {
                    self.showDetail = true
                }
                
                print("DEBUG APP RESULTS: \(item.placemark.title)")
            })
    }
    
    func selectLocationFromCoordinate(_ coordinate: CLLocationCoordinate2D){
       locationSearchCoordinate(forLocalSearchCompletion: coordinate, completion: { respons, error in
           if let error = error {
               print("DEBUG APP ERROR: \(error.localizedDescription)")
           }
           
           guard let mapItems = respons?.mapItems else {
               print("DEBUG APP NO RESULTS FOUND")
               return
           }
           
           let sortedMapItems = mapItems.sorted {
               let distance1 = $0.placemark.location?.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) ?? CLLocationDistance.infinity
               let distance2 = $1.placemark.location?.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) ?? CLLocationDistance.infinity
               return distance1 < distance2
           }
           
           // Set the closest location as the selected location
           if let closestLocation = sortedMapItems.first {
               self.MKresults = [closestLocation]
               self.MKselectedLocation = closestLocation
           }
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
           if self.MKselectedLocation != nil {
               
                   self.showDetail = true
                   print("DEBUG APP ITS TROLLING \(self.MKselectedLocation)")
               }
           }
           
           // Update the MKresults with all the found locations
           //self?.MKresults = sortedMapItems
           
           // Optionally print all results
           for item in sortedMapItems {
               print("DEBUG APP RESULT ITEM: \(item.placemark.title ?? "No Title") at \(item.placemark.coordinate)")
           }
       })
    }
    
    func selectLocationFromText() async throws {
        
    }
    func locationSearchFromCoordinate(coordinate: CLLocationCoordinate2D) {
            let searchRequest = MKLocalSearch.Request()
            
            // Set the region around the coordinate with a reasonable span
            let regionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            searchRequest.region = MKCoordinateRegion(center: coordinate, span: regionSpan)
            
            let search = MKLocalSearch(request: searchRequest)
            searchRequest.resultTypes = .pointOfInterest
            search.start { [weak self] response, error in
                if let error = error {
                    print("DEBUG APP LOCATION SEARCH ERROR: \(error.localizedDescription)")
                    return
                }
                
                guard let mapItems = response?.mapItems else {
                    print("DEBUG APP NO RESULTS FOUND")
                    return
                }
                
                // Sort results by distance from the given coordinate
                let sortedMapItems = mapItems.sorted {
                    let distance1 = $0.placemark.location?.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) ?? CLLocationDistance.infinity
                    let distance2 = $1.placemark.location?.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) ?? CLLocationDistance.infinity
                    return distance1 < distance2
                }
                
                // Set the closest location as the selected location
                if let closestLocation = sortedMapItems.first {
                    self?.MKselectedLocation = closestLocation
                    self?.selectedLocationCoordingate = closestLocation.placemark.coordinate
                    self?.showDetail = true
                    print("DEBUG APP SELECTED LOCATION: \(closestLocation.placemark.title ?? "No Title")")
                }
                
                // Update the MKresults with all the found locations
                //self?.MKresults = sortedMapItems
                
                // Optionally print all results
                for item in sortedMapItems {
                    print("DEBUG APP RESULT ITEM: \(item.placemark.title ?? "No Title") at \(item.placemark.coordinate)")
                }
            }
        }
    
    private func containsNumber(_ input: String) -> Bool {
        let range = NSRange(location: 0, length: input.utf16.count)
        let regex = try! NSRegularExpression(pattern: #"\d"#)
        return regex.firstMatch(in: input, options: [], range: range) != nil
    }
    
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        var searchRequest = MKLocalSearch.Request()
        
        if containsNumber(localSearch.subtitle) {
           
            //searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
            searchRequest.naturalLanguageQuery = "\(localSearch.title) \(localSearch.subtitle)"
            print("DEBUG APP CONTRAINSNUMBER, subtitle: \(localSearch.subtitle)")
        } else {
            searchRequest.naturalLanguageQuery = localSearch.title
        }
        
        
        
        print("DEBUG APP SEARCH REQUEST: \(localSearch.title.appending(localSearch.subtitle))")
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func locationSearchCoordinate(forLocalSearchCompletion localSearch: CLLocationCoordinate2D, completion: @escaping MKLocalSearch.CompletionHandler) {
        var request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "eat"
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        request.region = MKCoordinateRegion(center: localSearch, span: regionSpan)
        //request.resultTypes = .pointOfInterest
        
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: completion)
        
    }
    
    func locationSearchText(coordinates: CLLocationCoordinate2D, text: String, completion: @escaping MKLocalSearch.CompletionHandler){
        var request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: coordinates, span: regionSpan)
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: completion)
    }
    
    /*func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "\(localSearch.title) \(localSearch.subtitle)"//localSearch.title.appending(localSearch.subtitle)
        print("DEBUG APP LOCAL SEARCH: \(localSearch.title.appending(localSearch.subtitle))")
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }*/
}

//MARK: - MKLocalSearchCompleterDelegate

extension MapViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
