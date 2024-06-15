//
//  FontSize.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-11.
//

import SwiftUI

extension CGFloat {
    static let H1: CGFloat = 32
    static let H2: CGFloat = 28
    static let H3: CGFloat = 24
    static let H4: CGFloat = 20
    static let P1: CGFloat = 16
    static let P2: CGFloat = 12
}

enum CustomFontSize {
    case P1
    case P2
    case H4
    case H3
    case H2
    case H1
}

extension CustomFontSize {
    var size: CGFloat {
        switch self {
        case .P1:
            return 16 // Example size, adjust as needed
        case .P2:
            return 12 // Example size, adjust as needed
        case .H4:
            return 20
        case .H3:
            return 24
        case .H2:
            return 28
        case .H1:
            return 32
        }
    }
}

extension Font {
    static func primaryFont(_ size: CustomFontSize) -> Font {
        return .custom("Hanken Grotesk", size: size.size)
    }
}
