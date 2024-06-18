//
//  TextField.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let textInfo: String
    let secureField: Bool
    let multiRow: Bool
    
    var body: some View {
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
    }
}

#Preview {
    CustomTextField(text: .constant("hello there"), textInfo: "please enter", secureField: true, multiRow: false)
}
