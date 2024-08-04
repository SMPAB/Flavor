//
//  SelectLocationVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-30.
//

import Foundation
import MapKit
import SwiftUI

class SelectLocationVM: NSObject, ObservableObject {
    
    private let searchCompleter = MKLocalSearchCompleter()
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedMKItem: MKMapItem?
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
                
                
                self.selectedMKItem = respons?.mapItems.first
                print("DEBUG APP RESULTS: \(respons?.mapItems.first)")
            })
        
        
    }
    
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        
        
        if containsNumber(localSearch.subtitle) {
            searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        } else {
            searchRequest.naturalLanguageQuery = localSearch.title
        }
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
     func containsNumber(_ input: String) -> Bool {
        let range = NSRange(location: 0, length: input.utf16.count)
        let regex = try! NSRegularExpression(pattern: #"\d"#)
        return regex.firstMatch(in: input, options: [], range: range) != nil
    }
}

extension SelectLocationVM: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
