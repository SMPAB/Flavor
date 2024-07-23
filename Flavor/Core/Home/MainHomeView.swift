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
            
            if viewModel.fetchedFollowingUsernames == true && viewModel.userFollowingUsernames.isEmpty {
                VStack{
                    VStack{
                        Text("Your feed is now empty because you are not following anyone")
                            .multilineTextAlignment(.center)
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                            .foregroundStyle(.colorOrange)
                        
                        
                        ShareLink(item: URL(string: "https://apps.apple.com/app/flavor/id6499230618")!, preview: SharePreview("Flavor", icon: Image(.appstore))) {
                            HStack {
                                Text("Invite friends")
                                    .font(.primaryFont(.P1))
                                    .foregroundColor(.white)
                                Iconoir.shareIos.asImage
                                    .foregroundColor(.white)
                            }.frame(width: 170, height: 40)
                                .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.colorOrange)
                                )
                        }
                        
                    }
                    .padding(16)
                    .frame(height: 172)
                    .frame(maxWidth: .infinity)
                    .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.colorWhite)
                        .shadow(color: .colorOrange, radius: 5).opacity(0.2)
                    )
                    
                    if !viewModel.recomendedUsers.isEmpty {
                        VStack(alignment: .leading){
                            Text("Lets find some kitchen-mates! ")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            
                            ForEach(viewModel.recomendedUsers) { user in
                                
                                NavigationLink(destination:
                                                ProfileView(user: user)
                                    .environmentObject(viewModel)
                                ){
                                    RecomendedCell(user: user)
                                        .environmentObject(viewModel)
                                }
                                
                            }
                        }.padding(16)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.colorWhite)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                    .foregroundStyle(.colorOrange)
                            )
                            .padding(.top, 16)
                    }
                    
                }.padding(16)
                    .onFirstAppear {
                        Task{
                            try await viewModel.fetchRecomendedUsers()
                        }
                    }
            } else {
                FeedView()
                    .environmentObject(viewModel)
            }
            
        }.fullScreenCover(isPresented: $showNotifications){
            LandingNotificationView()
                .environmentObject(viewModel)
        }
        .refreshable {
            Task {
                try await viewModel.fetchFollowingUsernames()
                try await viewModel.fetchFeedPosts()
                try await viewModel.fetchStoryUsers()
                try await viewModel.fetchFriendRequests()
                try await viewModel.checkIfUserHasANotification()
            }
        }
    }
}

#Preview {
    MainHomeView()
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
