//
//  CustomAlertView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct CustomAlertView: View {
    var title: String?
    var message: String
    var boldMessage: String?
    var afterBold: String?
    var confirmAction: () -> Void
    var cancelAction: () -> Void
    var imageUrl: String?
    var dismissText: String
    var acceptText: String
    
    var body: some View {
        VStack {
            VStack{
                Text(title ?? "")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                Text(message)
                    .font(.primaryFont(.P1))
                    //.foregroundStyle(Color(.systemGray))
                
                +
                
                Text(boldMessage ?? "")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                +
                
                Text(afterBold ?? "")
                    .font(.primaryFont(.P1))
                    
                if let imageUrl = imageUrl{
                    ImageView(size: .xsmall, imageUrl: imageUrl, background: true)
                }
            }.padding(.horizontal, 16)
                .padding(.top, 16)
            
            VStack(spacing: 0){
                Rectangle()
                    .fill(Color(.systemGray))
                    .frame(height: 1)
                
                HStack{
                    
                    Button(action: {
                        cancelAction()
                    }){
                        Text(dismissText)
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.colorOrange)
                            .frame(height: 37)
                            .frame(maxWidth: .infinity)
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1, height: 37)
                    
                    Spacer()
                    
                    Button(action: {
                        confirmAction()
                    }){
                        Text(acceptText)
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.colorOrange)
                            .frame(height: 37)
                            .frame(maxWidth: .infinity)
                    }
                    
                }
            }
            
                
            
        }.multilineTextAlignment(.center)
        .frame(width: 240)
        
        
        
        .background(
        RoundedRectangle(cornerRadius: 16)
            .fill(.colorWhite)
            .shadow(radius: 5)
        )
       
    }
}


#Preview {
    CustomAlertView(message: "Are you sure you want to vote for", boldMessage: "@DouglasTamm", confirmAction: {}, cancelAction: {}, imageUrl: "", dismissText: "Cancel", acceptText: "Yes")
}
