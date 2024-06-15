//
//  HeaderMain.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct HeaderMain: View {
    @Environment(\.dismiss) var dismiss
    
    var action: () -> Void
    
    var cancelText: String
    var title: String
    var actionText: String
    
    var body: some View {
        HStack{
            Button(action: {
                dismiss()
            }){
                Text(cancelText)
                    .font(.primaryFont(.P1))
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            Text(title)
                .font(.primaryFont(.H4))
                .foregroundStyle(.black)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: {
                action()
            }){
                Text(actionText)
                    .font(.primaryFont(.P1))
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    HeaderMain(action: {}, cancelText: "Cancel", title: "Edit profle", actionText: "Save")
}
