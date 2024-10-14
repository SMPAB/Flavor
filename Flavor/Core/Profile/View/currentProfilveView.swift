//
//  currentProfilveView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI
import Iconoir

struct currentProfilveView: View {
    
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    @State var showCamera = false
    
    @State var offsetRectangle: CGFloat = 0
    
    @State var mockPostForGrid: [Post] = [Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0], Post.mockPosts[0]]
    
    init(user: User){
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    private var user: User{
        return viewModel.user
    }
    
    @State private var minHeight: CGFloat = 1
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                VStack(spacing: 16){
                    HStack{
                        Iconoir.settings.asImage
                            .opacity(0)
                        Spacer()
                        
                        Text("@\(user.userName)")
                            .font(.primaryFont(.H3))
                            .fontWeight(.semibold)
                            
                        
                        Spacer()
                      /*  NavigationLink(destination: {
                            Text("Setting")
                        })*/
                        NavigationLink(destination:
                        MainSettingsView()
                            .environmentObject(viewModel)
                            .environmentObject(contentViewModel)
                            .navigationBarBackButtonHidden(true)
                        ){
                            Iconoir.settings.asImage
                                .foregroundStyle(.black)
                        }
                        
                    }
                    
                    HStack(spacing: 16){
                        ImageView(size: .large, imageUrl: user.profileImageUrl, background: false)
                        
                        HStack(){
                            NavigationLink(destination:
                                            ListView(followers: .constant(true), following: .constant(false))
                                .environmentObject(homeVM)
                                .environmentObject(viewModel)
                            ) {
                                VStack(spacing: 8){
                                    Text("\(user.stats?.followersCount ?? 0)")
                                        .font(.primaryFont(.P1))
                                        .fontWeight(.semibold)
                                    
                                    Text("Followers")
                                        .font(.primaryFont(.P2))
                                }.frame(maxWidth: .infinity)
                                    .foregroundStyle(.black)
                            }
                            
                            Rectangle()
                                .foregroundStyle(Color(.systemGray4))
                                .frame(width: 1, height: 45)
                            
                            NavigationLink(destination:
                                            ListView(followers: .constant(false), following: .constant(true))
                                .environmentObject(viewModel)
                                .environmentObject(homeVM)
                            ) {
                                VStack(spacing: 8){
                                    Text("\(user.stats?.followingCount ?? 0)")
                                        .font(.primaryFont(.P1))
                                        .fontWeight(.semibold)
                                    
                                    Text("Following")
                                        .font(.primaryFont(.P2))
                                }.frame(maxWidth: .infinity)
                                    .foregroundStyle(.black)
                            }
                            
                            Rectangle()
                                .foregroundStyle(Color(.systemGray4))
                                .frame(width: 1, height: 45)
                            
                            VStack(spacing: 8){
                                Text("\(user.postIds?.count ?? 0)")
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                                
                                Text("Flavors")
                                    .font(.primaryFont(.P2))
                            }.frame(maxWidth: .infinity)
                        }
                        
                    }
                    
                    //CAPTION
                    
                    if let caption = user.biography{
                        Text(caption)
                            .font(.primaryFont(.P1))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                    
                    CustomButton(text: "Edit profile", textColor: .black, backgroundColor: .colorWhite, strokeColor: Color(.systemGray), action: {
                        viewModel.showEditProfile.toggle()
                        AnalyticsManager.shared.logEvent(name: "CurrentProfileView_EditProfileButtonPressed")
                    }
                                 
                    )
                    
                    
                    HStack{
                        Button(action: {
                           // withAnimation{
                                viewModel.grid = true
                                viewModel.album = false
                                viewModel.calender = false
                                viewModel.saved = false
                            AnalyticsManager.shared.logEvent(name: "CurrentProfileView_GridSelected")
                            //}
                            withAnimation{
                                offsetRectangle = -(width/4 + 35 + 6)
                            }
                            
                            
                        }){
                            Iconoir.reportColumns.asImage
                                .foregroundStyle(.black)
                        }.frame(maxWidth: .infinity)
                        
                        Button(action: {
                            //withAnimation{
                                viewModel.grid = false
                                viewModel.album = true
                                viewModel.calender = false
                                viewModel.saved = false
                            AnalyticsManager.shared.logEvent(name: "CurrentProfileView_AlbumsSelected")
                            //}
                            withAnimation{
                                offsetRectangle =  -(35 + 6 + 6)
                            }
                        }){
                            Iconoir.folder.asImage
                                .foregroundStyle(.black)
                        }.frame(maxWidth: .infinity)
                        
                        Button(action: {
                            
                            withAnimation{
                                offsetRectangle =  35 + 6 + 6
                            }
                           // withAnimation{
                                viewModel.grid = false
                                viewModel.album = false
                                viewModel.calender = true
                                viewModel.saved = false
                            AnalyticsManager.shared.logEvent(name: "CurrentProfileView_CalenderSelected")
                            //}
                        }){
                            Iconoir.calendar.asImage
                                .foregroundStyle(.black)
                        }.frame(maxWidth: .infinity)
                        
                        Button(action: {
                            
                            withAnimation{
                                offsetRectangle = width/4 + 35 + 6
                            }
                            
                            //withAnimation{
                                viewModel.grid = false
                                viewModel.album = false
                                viewModel.calender = false
                                viewModel.saved = true
                            //}
                            
                            AnalyticsManager.shared.logEvent(name: "CurrentProfileView_SavedSelected")
                            
                        }){
                            Iconoir.bookmark.asImage
                                .foregroundStyle(.black)
                        }.frame(maxWidth: .infinity)
                    }.padding(.top, 16)
                    
                    RoundedRectangle(cornerRadius: 1)
                        .fill(.black)
                        .frame(width: 70, height: 1)
                        .offset(x: offsetRectangle)
                        
                    
                    
                    
                }.padding(.horizontal, 16)
                //MARK: SUBVIEWS
                if viewModel.calender{
                    CalendarView()
                        .environmentObject(viewModel)
                        .environmentObject(homeVM)
                }
                
                if viewModel.saved{
                    SavedView()
                        .environmentObject(viewModel)
                        .environmentObject(homeVM)
                }
                
                if viewModel.album {
                    LandingAlbumView()
                        .environmentObject(viewModel)
                        .environmentObject(homeVM)
                }
                /*LazyVStack{
                    if viewModel.grid {
                        GridView(posts: $viewModel.posts, variableTitle: "Uploads", variableSubtitle: "\(user.userName)", navigateFromMain: false)
                            .environmentObject(homeVM)
                            
                    }
                    
                    VStack{
                        Text("")
                            .padding(.top, viewModel.grid ? 120 : 0)
                    }.onAppear{
                        print("DEBUG APP LOADER APPEAR")
                        Task{
                            try await viewModel.fetchGridPosts()
                        }
                        
                    }
                }*/
                
                LazyVStack {
                    if viewModel.grid {
                        
                        ZStack{
                            if user.isCurrentUser{
                                TestGrid(posts: viewModel.postIds, variableTitle: "Flavors", variableSubtitle: "\(user.userName)")
                                    .environmentObject(viewModel)
                                    .environmentObject(homeVM)
                            }
                            
                            if viewModel.postIds.isEmpty && homeVM.newPosts.isEmpty {
                                VStack{
                                    
                                    HStack{
                                        
                                        Button(action: {
                                            showCamera.toggle()
                                        }) {
                                            Iconoir.plus.asImage
                                                .foregroundStyle(.colorWhite)
                                                .frame(width: width/3, height: width/3)
                                                .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(.systemGray6))
                                                )
                                        }
                                        Spacer()
                                    }.padding(.leading, 8)
                                    Spacer()
                                }.offset(y: -8)
                            }
                        }
                        
                        
                    }
                }
                
              /*  TabView{
                    
                    
                        GridView(posts: /*$viewModel.posts*/ $mockPostForGrid, variableTitle: "Uploads", variableSubtitle: "\(user.userName)")
                            .environmentObject(homeVM)
                            .background {
                                      GeometryReader { geometry in
                                        Color.clear.preference(
                                          key: TabViewMinHeightPreference.self,
                                          value: geometry.frame(in: .local).height
                                        )
                                      }
                                    }
                    
                    
                    
                    
                        CalendarView()
                        .background {
                                  GeometryReader { geometry in
                                    Color.clear.preference(
                                      key: TabViewMinHeightPreference.self,
                                      value: geometry.frame(in: .local).height
                                    )
                                  }
                                }
                    
                    
                        SavedView()
                            .environmentObject(viewModel)
                            .environmentObject(homeVM)
                            .background {
                                      GeometryReader { geometry in
                                        Color.clear.preference(
                                          key: TabViewMinHeightPreference.self,
                                          value: geometry.frame(in: .local).height
                                        )
                                      }
                                    }
                    
                    
                    
                }.tabViewStyle(.page)
                    .frame(minHeight: minHeight)
                        .onPreferenceChange(TabViewMinHeightPreference.self) { minHeight in
                          self.minHeight = minHeight
                        }*/
                
            }
        }.onFirstAppear {
            offsetRectangle = -(width/4 + 35 + 6)
        }
        .onFirstAppear {
            Task{
               //try await viewModel.fetchUserStats()
                try await viewModel.fetchUserFollowingFollowersStats()
                try await viewModel.fetchCalenderStoryDays()
                try await viewModel.checkCurrentStreak()
            }
        
            
            
        }
        .onChange(of: homeVM.deletedStorys) {
            Task {
                try await viewModel.fetchCalenderStoryDays()
            }
        }
        .onChange(of: homeVM.deletePost){
            Task {
                try await viewModel.fetchCalenderStoryDays()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showEditProfile){
            EditProfileView()
                .environmentObject(viewModel)
        }
        
        .fullScreenCover(isPresented: $homeVM.showEditPost){
            EditPostView()
                .environmentObject(homeVM)
                .environmentObject(viewModel)
        }
        
        .fullScreenCover(isPresented: $showCamera){
            LandingCameraView(story: .constant(false))
                .environmentObject(homeVM)
        }
        .onChange(of: homeVM.newPosts){ newValue in
            for i in 0..<newValue.count{
                let newPost = newValue[i]
                if !viewModel.posts.contains(where: {$0.id == newPost.id}){
                    if homeVM.currentlyPinnedPost != nil && homeVM.currentlyPinnedPost != "" {
                        viewModel.postIds.insert(newPost.id, at: 1)
                    } else {
                        viewModel.postIds.insert(newPost.id, at: 0)
                    }
                    
                }
            }
            //viewModel.posts.insert(contentsOf: newValue, at: 0)
        }
        
        .onChange(of: homeVM.newPinPost){ newValue in
            
            if let newPostId = homeVM.newPinPost{
                
                var postIds = viewModel.user.postIds ?? []
                 postIds.removeAll(where: {$0 == newPostId})
                postIds.insert(newPostId, at: 0)
                viewModel.postIds = postIds
                
                
               if let index = viewModel.posts.firstIndex(where: {$0.id == newPostId}){
                   viewModel.posts[index].pinned = true
                }
                
                for i in 0..<viewModel.posts.count {
                    if viewModel.posts[i].id != newPostId {
                        viewModel.posts[i].pinned = false
                    }
                }
            }
            
            
            
            homeVM.newPinPost = nil
           
        }
        .onChange(of: homeVM.newUnpinPost){ newValue in
            
            if let newPostId = homeVM.newUnpinPost{
                viewModel.postIds = viewModel.user.postIds ?? []
                
                if let index = viewModel.posts.firstIndex(where: {$0.id == newPostId}){
                    viewModel.posts[index].pinned = false
                 }
            }
            
            homeVM.newUnpinPost = nil
           
        }
        
        .onChange(of: homeVM.deletedPost) { newValue in
            if let postId = homeVM.deletedPost {
                viewModel.posts.removeAll(where: {$0.id == postId})
                viewModel.postIds.removeAll(where: {$0 == postId})
                homeVM.variableUplaods.removeAll(where: {$0.id == postId})
                
                if homeVM.newPosts.contains(where: {$0.id == postId}){
                    homeVM.newPosts.removeAll(where: {$0.id == postId})
                }
                
                if homeVM.user.postIds!.contains(where: {$0 == postId}){
                    homeVM.user.postIds?.removeAll(where: {$0 == postId})
                }
                
                
                
            }
        }
        
        
    }
}

private struct TabViewMinHeightPreference: PreferenceKey {
  static var defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    // It took me so long to debug this line
    value = max(value, nextValue())
  }
}

#Preview {
    currentProfilveView(user: User.mockUsers[0])
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
