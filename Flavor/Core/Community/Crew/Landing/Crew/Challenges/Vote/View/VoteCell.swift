//
//  VoteCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-28.
//

import SwiftUI
import Kingfisher
import Firebase
import Iconoir

struct VoteCell: View {
    
    let challengePost: ChallengeUpload
    @EnvironmentObject var challengeVM: ChallengeViewModel
    
    var body: some View {
        
        
        let width = UIScreen.main.bounds.width
        VStack{
            HStack{
                Text("Viewing:")
                    .font(.primaryFont(.H4))
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("@\(challengePost.user?.userName ?? "")")
                    .font(.primaryFont(.H4))
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
            }
            
            if let imageUrl = challengePost.imageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: width - 48, height: width - 48)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .contentShape(RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(width: width - 48, height: width - 48)
            }
            
            
            
            VStack(alignment: .leading){
                
                
                Text(challengePost.title)
                    .font(.primaryFont(.H4))
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                
                
                Text("votes: \(challengeVM.challengePosts.first(where: {$0.id == challengePost.id})?.votes ?? 0)")
                    .font(.primaryFont(.P1))
                    .foregroundStyle(Color(.systemGray))
                    //.fontWeight(.semibold)
                
                if challengePost.ownerUid == Auth.auth().currentUser?.uid {
                    
                    Button(action: {
                        withAnimation{
                            challengeVM.deletePost = challengePost
                            challengeVM.showDeletePost = true
                        }
                    }){
                        HStack{
                            Iconoir.trash.asImage
                                .foregroundStyle(Color(.systemRed))
                            
                            Text("Remove Post")
                                .font(.primaryFont(.P1))
                        }
                        
                            
                        .foregroundStyle(Color(.systemRed))
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.colorWhite)
                                .stroke(Color(.systemRed))
                            )
                    }
                    
                } else {
                    if challengeVM.challenge.votes - challengeVM.votes.count  > 0{
                        HStack(spacing: 8){
                            Button(action: {
                                withAnimation(.spring(duration: 0.2, bounce: 0.4)){
                                    challengeVM.votePost = challengePost
                                    challengeVM.showVote = true
                                }
                                
                            }){
                                Text("Vote")
                                    .font(.primaryFont(.H4))
                                    .foregroundStyle(.colorWhite)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 58)
                                    .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.colorOrange)
                                        .stroke(.colorOrange)
                                    )
                            }
                            
                            Spacer()
                            Button(action: {
                                
                            }){
                                Text("Next")
                                    .font(.primaryFont(.H4))
                                    .foregroundStyle(.colorOrange)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 58)
                                    .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.colorWhite)
                                        .stroke(.colorOrange)
                                    )
                            }
                        }
                    } else {
                        VStack{
                            Text("You have voted for @\(challengeVM.voteUploads.first?.user?.userName ?? "")")
                                .font(.primaryFont(.P1))
                                .foregroundStyle(.colorOrange)
                                .frame(maxWidth: .infinity)
                                .frame(height: 42)
                                .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.clear)
                                    .stroke(.colorOrange)
                                )
                            
                            
                            Button(action: {
                                withAnimation(.spring(duration: 0.2, bounce: 0.4)){
                                    challengeVM.unVotePost = challengeVM.voteUploads.first
                                    challengeVM.showUnvote = true
                                }
                            }){
                                Text("unvote for @\(challengeVM.voteUploads.first?.user?.userName ?? "")")
                                    .font(.primaryFont(.P1))
                                    .foregroundStyle(Color(.systemGray))
                                    .underline()
                            }
                        }
                    }
                }
                
                
               
            }
        }.padding(16)
        .background(
        
            RoundedRectangle(cornerRadius: 16)
                .fill(.colorWhite)
                .shadow(color: .colorOrange, radius: 8).opacity(0.2)
        )
    }
}
/*
#Preview {
    VoteCell()
}*/
