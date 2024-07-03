//
//  ProfileView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import SwiftUI
import Iconoir

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    @Environment(\.dismiss) var dismiss
    
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
        
        ZStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    VStack(spacing: 16){
                        HStack{
                            Button(action: {
                                dismiss()
                            }){
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.black)
                            }
                            Spacer()
                            
                            Text("@\(user.userName)")
                                .font(.primaryFont(.H3))
                                .fontWeight(.semibold)
                            
                            Spacer()
                          /*  NavigationLink(destination: {
                                Text("Setting")
                            })*/
                            Button(action: {
                                viewModel.showOptions.toggle()
                            }){
                                Iconoir.moreVert.asImage
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
                        
                        if user.isFollowed == true {
                            CustomButton(text: "Unfollow", textColor: .black, backgroundColor: .colorWhite, strokeColor: Color(.systemGray), action: {
                                handleFollowTapped()
                            })
                        } else if user.hasFriendRequests == true {
                            CustomButton(text: "Request Sent", textColor: .black, backgroundColor: .colorWhite, strokeColor: Color(.systemGray), action: {
                                handleFollowTapped()
                            })
                        } else {
                            CustomButton(text: "Follow", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: Color(.colorOrange), action: {
                                handleFollowTapped()
                            })
                        }
                        
                        
                        HStack{
                            Button(action: {
                               // withAnimation{
                                    viewModel.grid = true
                                    viewModel.album = false
                                    viewModel.calender = false
                                    viewModel.saved = false
                                //}
                                withAnimation{
                                    offsetRectangle = -(width/3 + 16 - 24)
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
                                //}
                                withAnimation{
                                    offsetRectangle =  0
                                }
                            }){
                                Iconoir.folder.asImage
                                    .foregroundStyle(.black)
                            }.frame(maxWidth: .infinity)
                            
                            Button(action: {
                                
                                withAnimation{
                                    offsetRectangle = (width/3 + 16 - 24)
                                }
                               // withAnimation{
                                    viewModel.grid = false
                                    viewModel.album = false
                                    viewModel.calender = true
                                    viewModel.saved = false
                                //}
                            }){
                                Iconoir.calendar.asImage
                                    .foregroundStyle(.black)
                            }.frame(maxWidth: .infinity)
                            
                           
                        }.padding(.top, 16)
                        
                        RoundedRectangle(cornerRadius: 1)
                            .fill(.black)
                            .frame(width: 70, height: 1)
                            .offset(x: offsetRectangle)
                            
                        
                        
                        
                    }.padding(.horizontal, 16)
                    //MARK: SUBVIEWS
                    
                    if user.isFollowed == true || user.publicAccount {
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
                        LazyVStack {
                            if viewModel.grid {
                                TestGrid(posts: viewModel.postIds, variableTitle: "Flavors", variableSubtitle: "\(user.userName)")
                                    .environmentObject(viewModel)
                                    .environmentObject(homeVM)
                            }
                        }
                    } else {
                        VStack(spacing: 8){
                           
                          
                            
                            ZStack{
                                Image(systemName: "circle")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .fontWeight(.ultraLight)
                                
                                Image(systemName: "lock")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 35, height: 35)
                                    .fontWeight(.light)
                            }
                            
                            Text("This account is private")
                                .font(.primaryFont(.H4))
                                .fontWeight(.semibold)
                            
                            Text("Follow this account to se their flavors, albums, and take a look into their calender!")
                            
                                .font(.primaryFont(.P1))
                                .foregroundStyle(Color(.systemGray))
                                .multilineTextAlignment(.center)
                            
                           
                        }.padding(.top, 65)
                            .padding(.horizontal)
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
            }.navigationBarBackButtonHidden(true)
            
            .onFirstAppear {
                offsetRectangle = -(width/3 + 16 - 24)
            }
            .onFirstAppear {
                
                Task{
                    try await viewModel.checkIfUserIsFollowing(id: user.id)
                    try await viewModel.checkIfUserHasfriendRequest(id: user.id)
                    try await viewModel.fetchUserFollowingFollowersStats()
                    try await viewModel.fetchCalenderStoryDays()
                }
                
               
            }
            .fullScreenCover(isPresented: $viewModel.showEditProfile){
                EditProfileView()
                    .environmentObject(viewModel)
        }
            
            
            //MARK: OPTIONS
            
            if viewModel.showOptions {
                ProfileOptionsSheet()
                    .environmentObject(viewModel)
            }
        }.sheet(isPresented: $viewModel.showBlock){
            BlockView()
                .environmentObject(viewModel)
                .environmentObject(homeVM)
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $viewModel.showReport){
            ReportView()
                .environmentObject(viewModel)
        }
    }
    
    private func handleFollowTapped() {
        
       
           
           if user.isFollowed == true {
               Task {
                   try await viewModel.unfollow(userToUnfollow: user, userUnfollowing: homeVM.user)
               }
           } else if user.isFollowed == false && user.hasFriendRequests != true{
               if user.publicAccount {
                   //Follow
                   Task{
                       try await viewModel.follow(userToFollow: user, userFollowing: homeVM.user)
                   }
               } else {
                   Task{
                       try await viewModel.sendFriendRequest(sendRequestTo: user, userSending: homeVM.user)
                   }
               }
           } else if user.hasFriendRequests == true {
               //Remove friend request
               Task{
                   try await viewModel.unsendFriendRequest(userToUnFriendRequest: user, userUnfriendrequesting: homeVM.user)
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
    ProfileView(user: User.mockUsers[0])
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
