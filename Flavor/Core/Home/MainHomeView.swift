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
    
    @State var showSearch = false
    @State var showNotifications = false
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
                   showNotifications = true
                }){
                    
                    if viewModel.userHasNotification || viewModel.friendRequestUsernames.count != 0{
                        Iconoir.bellNotification.asImage
                            .foregroundStyle(.black)
                    } else {
                        Iconoir.bell.asImage
                            .foregroundStyle(.black)
                    }
                    
                }
                
                NavigationLink(destination: 
                                MainSearchView()
                    .environmentObject(viewModel)
                ){
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
        }.fullScreenCover(isPresented: $showNotifications){
            LandingNotificationView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    MainHomeView()
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
