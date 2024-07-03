//
//  Tabview.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

import SwiftUI
import Iconoir
import Kingfisher

struct Tabview: View {
    
    let user: User
    
    //@StateObject var controllVM: ControllViewModel
   // @StateObject var storyVM: StoryViewModel
    @StateObject var homeViewModel: HomeViewModel
    
    @EnvironmentObject var contentViewmodel: ContentViewModel
    
    
    @State var offsetFocusPost: CGFloat = 0
    
    @State var offsetStory: CGFloat = 0
    
    @Environment(\.namespace) var namespace
    
    //@Namespace private var namespace
    //OFFSETS
    
    
    //@State var offsetvariableFeed
    
    init(user: User, authService: AuthService){
        self.user = user
        
        //_controllVM = StateObject(wrappedValue: ControllViewModel(currentUser: user, authService: authService))
       // _storyVM = StateObject(wrappedValue: StoryViewModel(user: user))
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(user: user))
    
    }
    
    
    

    
    var body: some View {
        
        let tabBarHeightSize = UITabBarController().height
        let safeBottomAreaSize = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        ZStack{
            
            
            //MARK: TABBAR
            
            
            ZStack (alignment: .bottom){
                NavigationStack{
                    ZStack(alignment: .bottom){
                        TabView{
                            
                            MainHomeView()
                            
                                .environmentObject(homeViewModel)
                                .tabItem {
                                    Iconoir.homeSimpleDoor.asImage
                                }
                            
                            LandingCommunityView()
                                .environmentObject(homeViewModel)
                                .tabItem {
                                    
                                    Iconoir.community.asImage
                                    
                                }
                            
                            Spacer()
                                .onAppear{
                                    homeViewModel.showCamera.toggle()
                                }
                            
                            Text("MAP")
                                .tabItem {
                                    Iconoir.map.asImage
                                }
                            
                            /*ProfilView(user: user)
                             .environmentObject(contentViewmodel)
                             .environmentObject(homeViewModel)*/
                            currentProfilveView(user: user)
                                .environmentObject(homeViewModel)
                                .environmentObject(contentViewmodel)
                                .tabItem {
                                    Iconoir.user.asImage
                                    
                                }
                        }
                        .accentColor(.black)
                        .onAppear(){
                            UITabBar.appearance().backgroundColor = UIColor(.colorWhite)
                        }
                        
                        //Upload
                        Button(action: {
                            homeViewModel.showCamera.toggle()
                        }){
                            Iconoir.plus.asImage
                                .foregroundColor(.black)
                                .frame(width: 52, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.colorOrange)
                                        .frame(width: 52, height: 40)
                                    
                                )
                        }.frame(width: 52, height: 40)
                            .padding(.bottom, (safeBottomAreaSize ?? 0) + tabBarHeightSize-40)
                        
                    }.ignoresSafeArea(.all)
                        .navigationDestination(isPresented: $homeViewModel.showVariableView){
                            VariableView()
                                .environmentObject(homeViewModel)
                        }
                        .navigationDestination(isPresented: $homeViewModel.navigateToUser){
                            if let user = homeViewModel.navigationUser{
                                ProfileView(user: user)
                                    .environmentObject(homeViewModel)
                            }
                            
                        }
                        
                }
                
                
                if homeViewModel.showStory {
                    StoryOverlayView()
                        .environmentObject(homeViewModel)
                }
                
                if homeViewModel.showVariableView{
                    // VariableFeed()
                    //   .environmentObject(homeViewModel)
                    //  .background(.white)
                    
                }
                
                if homeViewModel.showFocusPost{
                    
                    
                    FocusPostView()
                        .environmentObject(homeViewModel)
                    //MARK: ANIMATION REMOVE MAYBE CAUSING BUG?
                        .scaleEffect(1 - ((abs(offsetFocusPost) / UIScreen.main.bounds.width))/10)
                        .offset(y: offsetFocusPost)
                    
                        .gesture(
                            DragGesture()
                                .onChanged({ NewValue in
                                    if NewValue.translation.height > 0{
                                        offsetFocusPost = NewValue.translation.height/1.3
                                    }
                                    
                                })
                                .onEnded({ endValue in
                                    if endValue.translation.height > 200 {
                                        homeViewModel.showFocusPost.toggle()
                                        homeViewModel.focusPost = nil
                                        homeViewModel.focusPostIndex = nil
                                        offsetFocusPost = 0
                                    } else {
                                        withAnimation{
                                            offsetFocusPost = 0
                                        }
                                    }
                                })
                            
                        )
                    
                    
                    /*if let post = homeViewModel.focusPost{
                     PostFocusView(post: post, currentUser: homeViewModel.user)
                     .environmentObject(homeViewModel)
                     }*/
                    
                }
                
                
                if let story = homeViewModel.selectedStory {
                    ZStack{
                        
                        Color.black.ignoresSafeArea()
                        
                        if let image = story.imageUrl {
                            KFImage(URL(string: image))
                                .resizable()
                                .scaledToFit()
                                .matchedGeometryEffect(id: story.id, in: namespace)
                                .onTapGesture {
                                    withAnimation{
                                        homeViewModel.showSelectedStory.toggle()
                                        homeViewModel.selectedStory = nil
                                    }
                                }
                                .offset(y: offsetStory)
                                .gesture(
                                DragGesture()
                                    .onChanged{ newValue in
                                        offsetStory = newValue.translation.height/1.4
                                    }
                                    .onEnded{ value in
                                        if value.translation.height > 200 {
                                            withAnimation{
                                                homeViewModel.showSelectedStory.toggle()
                                                homeViewModel.selectedStory = nil
                                                offsetStory = 0
                                            }
                                        } else {
                                            withAnimation{
                                                offsetStory = 0
                                            }
                                        }
                                    }
                                
                                )
                                
                            
                        }
                    }
                    
                    
                }
                
                
                if homeViewModel.showQRCode {
                    QRCode(name: homeViewModel.QRuserName, whatWasSaved: homeViewModel.whatWasSaved, showView: $homeViewModel.showQRCode, LINK: homeViewModel.QRCODELINK)
                }
                
            }.customAlert(isPresented: $homeViewModel.showDeletePostAlert, title: nil, message: "Are you sure you want to delete your post", boldMessage: nil, afterBold: nil, confirmAction: {
                
                Task {
                    try await homeViewModel.deletePost()
                    homeViewModel.showDeletePostAlert = false
                    homeViewModel.deletePost = nil
                }
                
            }, cancelAction: {
                withAnimation(.spring(duration: 0.2, bounce: 0.4)){
                    homeViewModel.showDeletePostAlert = false
                    homeViewModel.deletePost = nil
                }
                
            }, imageUrl: homeViewModel.deletePost?.imageUrls?[0], dismissText: "Cancel", acceptText: "Delete")
                
                .onFirstAppear {
                    
                    homeViewModel.chechIfCurrentUserSeenStory()
                    
                    Task{
                        homeViewModel.fetchingPosts = true
                        try await homeViewModel.fetchFollowingUsernames()
                        try await homeViewModel.fetchFeedPosts()
                        try await homeViewModel.fetchStoryUsers()
                    }
                    
                    Task{
                        try await homeViewModel.fetchFriendRequests()
                        try await homeViewModel.checkIfUserHasANotification()
                    }
                    
                }
            
        }
        .fullScreenCover(isPresented: $homeViewModel.showCamera){
               // MainCameraView(currentUser: user)
                LandingCameraView(story: .constant(false) )
                    .environmentObject(homeViewModel)
            }
        
        
        
    }
}

extension UITabBarController {
    var height: CGFloat {
        return self.tabBar.frame.size.height
    }
    
    var width: CGFloat {
        return self.tabBar.frame.size.width
    }
}


extension UIApplication {
    var keyyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
    
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}


private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}


extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
#Preview {
    Tabview(user: User.mockUsers[0], authService: AuthService())
        .environmentObject(ContentViewModel(service: AuthService()))
}
