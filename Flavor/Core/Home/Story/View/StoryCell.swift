//
//  StoryCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-14.
//

import SwiftUI
import Kingfisher

struct StoryCell: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    let story: Story
    let oddStory: Bool
    
    var body: some View {
        if !oddStory {
            ZStack(alignment: .topTrailing){
                HStack(spacing: 16){
                    if let imageUrl = story.imageUrl {
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
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
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .contentShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                   
                }
                
                if story.postID != nil {
                    Text("⭐️")
                        .padding(8)
                }
                
                
            }
        }
    }
}

#Preview {
    StoryCell(story: Story.mockStorys[0], oddStory: false)
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
