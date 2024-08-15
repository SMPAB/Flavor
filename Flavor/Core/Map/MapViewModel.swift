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
                print("DEBUG APP RESULTS: \(item.placemark.title)")
            })
        
        
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
