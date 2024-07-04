//
//  StoryCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-14.
//

import SwiftUI
import Kingfisher
import Firebase

struct StoryCell: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    let story: Story
    let oddStory: Bool
    
    @State var showReport = false
    
    @Environment(\.namespace) var namespace
    
    var body: some View {
        
        ZStack{
            if !oddStory {
                ZStack(alignment: .topTrailing){
                    HStack(spacing: 16){
                        if let imageUrl = story.imageUrl {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .matchedGeometryEffect(id: story.id, in: namespace)
                                .onTapGesture {
                                   
                                    
                                    print("DEBUG APP ID: \(homeVM.selectedStory?.id)")
                                    withAnimation(.spring(duration: 0.3, bounce: 0.2)){
                                        homeVM.selectedStory = story
                                        homeVM.showSelectedStory.toggle()
                                    }
                                }
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .contentShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        VStack(alignment: .leading, spacing: 10){
                            if story.title != "" {
                                Text("🍽️ \(story.title)")
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                            }
                            
                            Text("⏰ \(story.timestamp.timestampHourlyString())")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                        }
                        
                        
                        
                        Spacer()
                    }
                    
                    if story.postID != nil {
                        Text("⭐️")
                            .padding(8)
                    }
                    
                    
                }.background(.white)
                .contextMenu{
                    
                    if story.ownerUid == Auth.auth().currentUser?.uid {
                        Button(role: .destructive){
                            homeVM.deleteStory = story
                            
                            withAnimation{
                                homeVM.showDeleteStoryAlert = true
                            }
                        } label: {
                            Label("Delete Story", systemImage: "trash")
                                .font(.primaryFont(.P1))
                        }
                    } else {
                        Button(role: .destructive){
                            showReport.toggle()
                        } label: {
                            Label("Report Story", systemImage: "exclamationmark.triangle")
                                .font(.primaryFont(.P1))
                        }
                    }
                    
                    
                    Button(action: {
                        
                    }){
                        Text("Cancel")
                            .font(.primaryFont(.P1))
                    }
                }
            } else {
                ZStack(alignment: .topLeading){
                    HStack(spacing: 16){
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 10){
                            if story.title != "" {
                                Text("🍽️ \(story.title)")
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                            }
                            
                            Text("⏰ \(story.timestamp.timestampHourlyString())")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                        }
                        
                        if let imageUrl = story.imageUrl {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .matchedGeometryEffect(id: story.id, in: namespace)
                                .onTapGesture {
                                    
                                    withAnimation(.spring(duration: 0.3, bounce: 0.2)){
                                        homeVM.selectedStory = story
                                        homeVM.showSelectedStory.toggle()
                                    }
                                }
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .contentShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                       
                    }
                    
                    if story.postID != nil {
                        Text("⭐️")
                            .padding(8)
                    }
                    
                    
                }.background(.white)
                .contextMenu{
                    
                    if story.ownerUid == Auth.auth().currentUser?.uid {
                        Button(role: .destructive){
                            homeVM.deleteStory = story
                            
                            withAnimation{
                                homeVM.showDeleteStoryAlert = true
                            }
                            
                        } label: {
                            Label("Delete Story", systemImage: "trash")
                                .font(.primaryFont(.P1))
                        }
                    } else {
                        Button(role: .destructive){
                            showReport.toggle()
                        } label: {
                            Label("Report Story", systemImage: "exclamationmark.triangle")
                                .font(.primaryFont(.P1))
                        }
                    }
                    
                    
                    Button(action: {
                        
                    }){
                        Text("Cancel")
                            .font(.primaryFont(.P1))
                    }
                }

            }
        }.fullScreenCover(isPresented: $showReport, content: {
            ReportStory(story: story)
                .environmentObject(homeVM)
        })
       
    }
}

#Preview {
    StoryCell(story: Story.mockStorys[0], oddStory: false)
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
