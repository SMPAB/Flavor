//
//  HeaderRegisration.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct HeaderRegisration: View {
    @Environment(\.dismiss) var dissmiss
    var body: some View {
        HStack{
            Button(action: {
                dissmiss()
            }){
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.black)
            }
            
            Spacer()
            
            Image("Logo_Full_Black")
                .resizable()
                .scaledToFill()
                .frame(width: 89, height: 24)
            
            Spacer()
            
            Image(systemName: "chevron.left").opacity(0)
        }
    }
}

#Preview {
    HeaderRegisration()
}
