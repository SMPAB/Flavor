//
//  testis.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-25.
//

import SwiftUI
import Iconoir
import Firebase


struct testis: View {
    
    @State var otherView = false
    var body: some View {
        NavigationStack {
            ScrollView{
                HStack{
                    Button(action: {
                        toggler()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                
                    Spacer()
                        Text("Feed")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                    
                    Spacer()
                    
               
                    
                    Iconoir.bag.asImage
                        .onTapGesture {
                            otherView.toggle()
                        }
                }.padding(.horizontal)
                
                
                ForEach(1...40, id: \.self){ cell in
                   // TestCell()
                }
            }.navigationDestination(isPresented: $otherView){
                
            }
        }
    }
    
    func toggler() {
        
    }
}

#Preview {
    testis()
}
