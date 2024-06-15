//
//  CustomButton.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct CustomButton: View {
    
    var text: String
    var textColor: Color
    
    var backgroundColor: Color
    var strokeColor: Color
    
    var action: () -> Void
    
    var body: some View {
        
        Button(action:{
            action()
        }
        ){
            Text(text)
                .font(.primaryFont(.P1))
                .foregroundStyle(textColor)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .stroke(strokeColor)
                )
        }
        
    }
}

#Preview {
    CustomButton(text: "Go to post", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: .colorOrange, action: {})
}
