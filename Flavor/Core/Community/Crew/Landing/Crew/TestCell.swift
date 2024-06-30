//
//  TestCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-25.
//

import SwiftUI

struct TestCell: View {
    var body: some View {
        HStack{
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
                .frame(width: 48, height: 48)
            
            
            Text("Öland2024")
                .foregroundStyle(.black)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: {
                
            }){
                Image(systemName: "chevron.right")
                    .foregroundStyle(.black)
                    
            }
        }
    }
}

#Preview {
    TestCell()
}
