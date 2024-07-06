//
//  TextField.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI
import Iconoir

struct CustomTextField: View {
    @Binding var text: String
    let textInfo: String
    let secureField: Bool
    let multiRow: Bool
    
    let search: Bool
    
    var body: some View {
        if search  != true {
            ZStack {
                if !multiRow{
                    ZStack{
                        if secureField{
                            SecureField(textInfo, text: $text)
                                .font(.primaryFont(.P1))
                                .padding(8)
                                .frame(height: 48)
                                .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.colorWhite)
                                    .stroke(Color(.systemGray))
                                )
                        } else {
                            TextField(textInfo, text: $text)
                                .font(.primaryFont(.P1))
                                .padding(8)
                                .frame(height: 48)
                                .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.colorWhite)
                                    .stroke(Color(.systemGray))
                                )
                        }
                        

                    }
                } else {
                    ZStack{
                        if secureField{
                            SecureField(textInfo, text: $text)
                                .font(.primaryFont(.P1))
                                .padding(8)
                                .frame(height: 48)
                                .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.colorWhite)
                                    .stroke(Color(.systemGray))
                                )
                        } else {
                            TextField(textInfo, text: $text, axis: .vertical)
                                .font(.primaryFont(.P1))
                                .padding(8)
                                .frame(height: 95, alignment: .topLeading)
                                .multilineTextAlignment(.leading)
                                .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.colorWhite)
                                    .stroke(Color(.systemGray))
                                )
                        }
                        

                    }
                }
                
            }
        } else {
            HStack{
                Iconoir.search.asImage
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.colorOrange)
                
                TextField(textInfo, text: $text)
                    
                    .font(.primaryFont(.P2))
            }.padding(8)
            
                .frame(maxWidth: .infinity)
                .frame(height: 37)
                .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.colorWhite)
                    .stroke(Color(.systemGray4))
                )
                
        }
    }
}

#Preview {
    CustomTextField(text: .constant("hello there"), textInfo: "please enter", secureField: true, multiRow: false, search: true)
}
