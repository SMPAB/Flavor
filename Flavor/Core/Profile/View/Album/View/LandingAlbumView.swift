//
//  LandingAlbumView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-15.
//

import SwiftUI
import Firebase
import Iconoir

struct LandingAlbumView: View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack{
            if viewModel.user.id == Auth.auth().currentUser?.uid {
                
                Button(action: {
                    
                }){
                    HStack{
                        Text("Create Album")
                            .font(.primaryFont(.P1))
                        
                        Iconoir.plus.asImage
                    }.foregroundStyle(Color(.systemGray))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                            .foregroundStyle(Color(.systemGray))
                        )
                }.padding(.horizontal, 16)
                
            }
        }
    }
}

#Preview {
    LandingAlbumView()
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}
