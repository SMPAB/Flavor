//
//  SkeletonPost.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI

struct SkeletonPost: View {
    var body: some View {
        VStack(){
            HStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: 120, height: 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: 40, height: 8)
                }
                
                Spacer()
            }.padding(.horizontal, 24)
            
            /*
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(width: 120, height: 8)
                
               
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: 220, height: 8)*/
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .frame(width: UIScreen.main.bounds.width - 32 - 16, height: 250)
            
            HStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(width: 200, height: 10)
                
                Spacer()
            }.padding(.horizontal, 24)
            
        }
    }
}

#Preview {
    SkeletonPost()
}
