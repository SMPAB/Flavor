//
//  StoryIconView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-14.
//

import SwiftUI
import Iconoir

struct StoryIconView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State var showCamera = false
    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing: 16){
                
                if homeVM.currentUserHasStory{
                    ZStack{
                        ImageView(size: .medium, imageUrl: homeVM.user.profileImageUrl, background: true)
                            .onTapGesture {
                                homeVM.selectedStoryUser = homeVM.user.id
                                homeVM.showStory = true
                            }
                       
                            Iconoir.plus.asImage
                                .foregroundStyle(.colorWhite)
                                .frame(width: 24, height: 24)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.colorOrange)
                                )
                                .offset(x: 30, y: 30)
                                .onTapGesture {
                                    showCamera.toggle()
                                }
                                
                    }.padding(.trailing, 8)
                } else {
                    
                        ZStack{
                            ImageView(size: .medium, imageUrl: homeVM.user.profileImageUrl, background: false)
                            
                            Button(action: {
                                
                            }){
                                Iconoir.plus.asImage
                                    .foregroundStyle(.colorWhite)
                                    .frame(width: 24, height: 24)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(.colorOrange)
                                    )
                                
                            }.offset(x: 30, y: 30)
                        }.padding(.trailing, 8)
                        .onTapGesture {
                            showCamera.toggle()
                        }
                        
                    
                }
                ForEach(homeVM.storyUsers.filter({ $0.id != homeVM.user.id})){ user in
                    ImageView(size: .medium, imageUrl: user.profileImageUrl, background: user.seenStory == true ? false : true)
                        .opacity(user.seenStory == true ? 0.7 : 1)
                        .onTapGesture {
                            homeVM.selectedStoryUser = user.id
                            homeVM.showStory = true
                        }
                }
            }.frame(height: 100)
                .padding(.leading, 16)
        }
        .fullScreenCover(isPresented: $showCamera){
            LandingCameraView(story: .constant(true))
                .environmentObject(homeVM)
        }
    }
}

#Preview {
    StoryIconView()
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
