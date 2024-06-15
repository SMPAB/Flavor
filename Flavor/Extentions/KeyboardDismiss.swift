//
//  KeyboardDismiss.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//


import Foundation
import SwiftUI

extension UIApplication{
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
