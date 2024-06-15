//
//  MainHomeView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI
import Iconoir

struct MainHomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        ScrollView(showsIndicators: false){
            HStack{
                
                Iconoir.bell.asImage
                    .opacity(0)
                
                Iconoir.search.asImage
                    .opacity(0)
            
                Spacer()
                
                Image("Logo_Full_Black")
                    .resizable()
                    .frame(width: 94, height: 24)
                
                Spacer()
                
                Button(action: {
                    
                }){
                    Iconoir.bell.asImage
                        .foregroundStyle(.black)
                }
                
                Button(action: {
                    
                }){
                    Iconoir.search.asImage
                        .foregroundStyle(.black)
                }
            }.padding(.horizontal, 16)
            
            
            //MARK: STORY
            
            StoryIconView()
                .environmentObject(viewModel)
            
            //MARK: FEED
            FeedView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    MainHomeView()
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
