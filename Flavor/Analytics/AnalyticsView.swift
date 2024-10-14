//
//  AnalyticsView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-19.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseAnalyticsSwift


final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() { }
    
    
    func logEvent(name: String, params: [String:Any]? = nil){
        Analytics.logEvent(name, parameters: params)
    }
    
    func setUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func setUserPropertys(value: String?, property: String){
        Analytics.setUserProperty(value, forName: property)
    }
}

struct AnalyticsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AnalyticsView()
}
