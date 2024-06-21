//
//  MainChallengeView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-21.
//

import SwiftUI
import Iconoir

struct MainChallengeView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ChallengeViewModel
    
    init(challenge: Challenge){
        self._viewModel = StateObject(wrappedValue: ChallengeViewModel(challenge: challenge))
    }
    
    var challenge: Challenge{
        return viewModel.challenge
    }
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        Iconoir.settings.asImage
                            .foregroundStyle(.black)
                    }
                    
                }.padding(.horizontal, 16)
                
                
                VStack(spacing: 8){
                    HStack(spacing: 8){
                        ImageView(size: .medium, imageUrl: challenge.imageUrl, background: true)
                        
                        VStack(alignment: .leading){
                            Text(challenge.title)
                                .font(.primaryFont(.H4))
                                .fontWeight(.semibold)
                            
                            Text(challenge.description)
                                .font(.primaryFont(.P1))
                                
                            
                            Text("Deadline: \(challenge.endDate.dateValue().formattedChallengeCell())")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            
                        }.frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    
                    HStack{
                        Iconoir.check.asImage
                        
                        Text("\(challenge.completedUsers.count) members done")
                            .font(.primaryFont(.P2))
                        
                        Rectangle()
                            .fill(Color(.systemGray))
                            .frame(width: 1, height: 24)
                        
                        
                        Iconoir.hourglass.asImage
                        
                        Text("\(challenge.users.count - challenge.completedUsers.count) members left")
                            .font(.primaryFont(.P2))
                        
                        Spacer()
                    }
                    
                }.padding(.horizontal, 16)
                
                LazyVStack{
                    ForEach(viewModel.challengePosts){ post in
                        Text(post.id)
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
        
        .onFirstAppear {
            Task{
                try await viewModel.fetchPosts()
            }
        }
    }
}
/*
#Preview {
    MainChallengeView()
}*/
