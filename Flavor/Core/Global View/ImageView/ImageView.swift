//
//  ImageView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI
import Kingfisher

enum ImageSize: CGFloat {
    case xxsmall = 24
    case xsmall = 32
    case small = 48
    case medium = 72
    case large = 96
    case xlarge = 128
}
struct ImageView: View {
    
    var size: ImageSize
    let imageUrl: String?
    var background: Bool
    var body: some View {
        if background{
            if let imageUrl = imageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.rawValue, height: size.rawValue)
                    .clipShape(RoundedRectangle(cornerRadius: size.rawValue/8))
                    .contentShape(RoundedRectangle(cornerRadius: size.rawValue/8))
                    .background(
                        RoundedRectangle(cornerRadius: size.rawValue/8)
                            .fill(Color(.systemGray5))
                            .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [.colorYellow, .colorOrange]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: size.rawValue/20 // Adjust the width of the border as needed
                                                )
                    )
            } else {
                RoundedRectangle(cornerRadius: size.rawValue/8)
                    .fill(Color(.systemGray5))
                    
                    .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.colorYellow, .colorOrange]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: size.rawValue/35 // Adjust the width of the border as needed
                                        )
                    .frame(width: size.rawValue, height: size.rawValue)
            }
        } else {
            if let imageUrl = imageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.rawValue, height: size.rawValue)
                    .clipShape(RoundedRectangle(cornerRadius: size.rawValue/8))
                    .contentShape(RoundedRectangle(cornerRadius: size.rawValue/8))
                    .background(
                        RoundedRectangle(cornerRadius: size.rawValue/8)
                            .fill(Color(.systemGray5))
                    )
            } else {
                RoundedRectangle(cornerRadius: size.rawValue/8)
                    .fill(Color(.systemGray5))
                    .frame(width: size.rawValue, height: size.rawValue)
            }
        }
    }
}

#Preview {
    ImageView(size: .medium, imageUrl: "2", background: true)
}
