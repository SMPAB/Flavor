//
//  MainVoteView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-28.
//

import SwiftUI
import Firebase
import Iconoir
struct MainVoteView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var viewModel: ChallengeViewModel
    @State private var currentPostId: Int = 0
    var body: some View {
        let width = UIScreen.main.bounds.width
        ZStack {
            VStack(spacing: 16) {
                
                HStack{
                    Button(action: {
                        viewModel.showVoteView.toggle()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Voting: \(viewModel.challenge.title)")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    Image(systemName: "chevron.left").opacity(0)
                    
                }.padding(.horizontal, 16)
                
                
                HStack{
                    Text("Votes left")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("(\(viewModel.challenge.votes - viewModel.votes.count)/\(viewModel.challenge.votes))")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                    
                    
                }.padding(.horizontal, 16)
                TabView(selection: $currentPostId) {
                    ForEach(viewModel.challengePosts.indices, id: \.self) { index in
                        VoteCell(challengePost: viewModel.challengePosts[index])
                            .padding(.horizontal, 16)
                            .tag(index)
                    }
                }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                   .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: width + 170)
                
                HStack{
                    Button(action: {
                        withAnimation{
                            if currentPostId != 0 {
                                currentPostId -= 1
                                viewModel.selectedPostId -= 1
                            }
                        }
                        
                        
                    }){
                        Iconoir.navArrowLeft.asImage
                            .foregroundStyle(.colorWhite)
                            .frame(width: 32, height: 32)
                            .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.colorOrange)
                            )
                    }
                    
                    Text("\(viewModel.selectedPostId + 1)/\(viewModel.challengePosts.count) contribution")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(.colorOrange)
                        .padding(.horizontal, 8)
                    
                    Button(action: {
                        withAnimation{
                            if currentPostId != viewModel.challengePosts.count-1 {
                                currentPostId += 1
                                viewModel.selectedPostId += 1
                            }
                        }
                        
                    }){
                        Iconoir.navArrowRight.asImage
                            .foregroundStyle(.colorWhite)
                            .frame(width: 32, height: 32)
                            .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.colorOrange)
                            )
                    }
                }
                Spacer()
            }
            
            
        }.customAlert(isPresented: $viewModel.showVote, title: nil, message: "Are you sure you want to vote on ", boldMessage: "\(viewModel.votePost?.user?.userName ?? "")", afterBold: nil,
                      confirmAction: {
            Task{
                try await viewModel.vote(currentUser: homeVM.user)
            }
        },
                      cancelAction: {
            viewModel.showVote.toggle()
            viewModel.votePost = nil
        }, imageUrl: viewModel.votePost?.user?.profileImageUrl, dismissText: "Cancel", acceptText: "Vote")
        .onAppear {
            if let selectedPostId = viewModel.selectedPost,
                           let index = viewModel.challengePosts.firstIndex(where: { $0.id == selectedPostId }) {
                            currentPostId = index
                viewModel.selectedPostId = index
                        } else {
                            currentPostId = 0
                        }
        }
        .onChange(of: viewModel.selectedPost){
            if let selectedPostId = viewModel.selectedPost,
                           let index = viewModel.challengePosts.firstIndex(where: { $0.id == selectedPostId }) {
                            currentPostId = index
                        viewModel.selectedPostId = index
                        }
        }
        
    }
}

#Preview {
    MainVoteView()
        .environmentObject(ChallengeViewModel(challenge: Challenge(id: "", crewId: "", title: "TacoFriday", description: "", startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), votes: 1, users: [], completedUsers: [])))
}
