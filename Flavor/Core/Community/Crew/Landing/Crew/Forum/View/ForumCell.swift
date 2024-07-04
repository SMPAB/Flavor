//
//  ForumCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-03.
//

import SwiftUI
import Firebase
import Iconoir

struct ForumCell: View {
    
    
    @StateObject var viewModel: ForumCellViewModel
    @EnvironmentObject var crewVM: MainCrewViewModel
    
    init(forum: Forum) {
        self._viewModel = StateObject(wrappedValue: ForumCellViewModel(forum: forum))
    }
    
    var forum: Forum {
        return viewModel.forum
    }
    var isLiked: Bool {
        return forum.isLiked ?? false
    }
    
    var isDisliked: Bool {
        return forum.isDisliked ?? false
    }
    var body: some View {
        
        if forum.type == .newChallenge {
            ZStack(alignment: .topTrailing){
                if let challenge = forum.challenge {
                    
                    HStack(spacing: 16){
                        ImageView(size: .small, imageUrl: challenge.imageUrl, background: true)
                        
                        VStack(alignment: .leading){
                            Text("New Challenge:")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            
                            Text(challenge.title)
                                .font(.primaryFont(.P1))
                                
                        }
                        
                        Spacer()
                    }
                    
                }
                
                Text(forum.timestamp.dateValue().formattedChallengeCell())
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
            }.padding(.horizontal)
            .frame(height: 80)
            .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.colorWhite)
                .stroke(.colorOrange)
                .shadow(color: .colorOrange, radius: 4).opacity(0.3)
            )
            .frame(height: 100)
        }
        
        if forum.type == .Announcement {
            if let user = forum.user {
                HStack(alignment: .top, spacing: 16){
                    ImageView(size: .small, imageUrl: user.profileImageUrl, background: true)
                    
                    VStack(alignment: .leading, spacing: 2){
                        HStack( spacing: 2){
                            Text("@\(user.userName)")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            Iconoir.megaphone.asImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.colorOrange)
                            
                        }
                        
                        Text(forum.announcementText ?? "")
                            .font(.primaryFont(.P1))
                    }.padding(.top, 0)
                    Spacer()
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                
                    
            }
        }
        
        if forum.type == .voting {
            HStack(spacing: 16){
                /*Iconoir.podcast.asImage
                    .resizable()
                    .frame(width: 48, height: 48)*/
                
                VStack(alignment: .leading){
                    Text("New voting:")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                    
                    Text(forum.announcementText ?? "")
                        .font(.primaryFont(.P1))
                }
                
                Spacer()
                
                HStack{
                    
                    VStack{
                        Button(action: {
                            handleLikedTapped()
                        }){
                            if isLiked{
                                Iconoir.thumbsUp.asImage
                                    .foregroundStyle(.colorWhite)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.systemGreen))
                                            .stroke(Color(.systemGreen))
                                    )
                            } else {
                                Iconoir.thumbsUp.asImage
                                    .foregroundStyle(Color(.systemGreen))
                                    .frame(width: 36, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.colorWhite)
                                            .stroke(Color(.systemGreen))
                                    )
                            }
                                
                            
                        }
                        
                        Text("\(forum.Upvotes ?? 0)")
                            .font(.primaryFont(.P2))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(.systemGreen))
                    }
                    
                    VStack{
                        Button(action: {
                            handleDislikedTapped()
                        }){
                            if isDisliked{
                                Iconoir.thumbsDown.asImage
                                    .foregroundStyle(.colorWhite)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.systemRed))
                                            .stroke(Color(.systemRed))
                                    )
                            } else {
                                Iconoir.thumbsDown.asImage
                                    .foregroundStyle(Color(.systemRed))
                                    .frame(width: 36, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.colorWhite)
                                            .stroke(Color(.systemRed))
                                    )
                            }
                                
                            
                        }
                        
                        Text("\(forum.DownVotes ?? 0)")
                            .font(.primaryFont(.P2))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(.systemRed))
                    }
                    
                }
            }.frame(maxWidth: .infinity)
                .padding()
                .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.colorWhite)
                    .stroke(.colorOrange)
                    .shadow(color: .colorOrange, radius: 4).opacity(0.3)
                )
                .padding(.vertical, 8)
                .onFirstAppear {
                    Task{
                        try await viewModel.checkIfUserHasLiked(crewId: crewVM.crew.id)
                        try await viewModel.checkIfUserHasDownVote(crewId: crewVM.crew.id)
                    }
                }
                
        }
    }
    
    func handleLikedTapped() {
        if isLiked {
            Task {
                try await viewModel.unlike(crewId: crewVM.crew.id)
            }
            
            
        } else {
            Task {
               try await viewModel.like(crewId: crewVM.crew.id)
            }
            
        }
        
        
    }
    
    func handleDislikedTapped() {
        if isDisliked {
            Task {
               try await viewModel.unDisLike(crewId: crewVM.crew.id)
            }
        } else {
            Task {
               try await viewModel.disLike(crewId: crewVM.crew.id)
            }
        }
    }
}

#Preview {
    ForumCell(forum: Forum(id: "123", type: .voting, timestamp: Timestamp(date: Date()), newUserId: nil, challengeID: "123434", Upvotes: 3, DownVotes: 2, announcementText: "Nu är det dags att alla här inne blir lite mer aktiva, påriktigt asså!!!", challenge: Challenge(id: "123", crewId: "12312", title: "Skagen", description: "Gör din bästa skagen", imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/favoorswiftui.appspot.com/o/profile_images%2F440C3648-5044-4C03-9327-438D8BB5A09B?alt=media&token=4f9d4b25-035a-4d8d-8b15-9281659a0d78", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), votes: 0, finished: false, users: [], completedUsers: []), user: User.mockUsers[0]) )
}
