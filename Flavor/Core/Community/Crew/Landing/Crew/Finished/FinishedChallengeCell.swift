//
//  FinishedChallengeCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-06.
//

import SwiftUI
import Lottie
import Firebase
import Iconoir

struct FinishedChallengeCell: View {
    
    @StateObject var viewModel: FinishedChallengeCellVM
    
    @EnvironmentObject var crewVM: MainCrewViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    init(challenge: Challenge) {
        self._viewModel = StateObject(wrappedValue: FinishedChallengeCellVM(challenge: challenge))
    }
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        ZStack (alignment: .topLeading){
            VStack(spacing: 0){
                
                //ANIMATION
                ZStack{
                    
                    
                    HStack(spacing: 0){
                        LottieView(animation: .named("confetti"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .frame(width: 150, height: 220)
                            
                        
                        LottieView(animation: .named("confetti"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .frame(width: 150, height: 220)
                            
                    }
                    
                    
                    
                    //DOG
                    ZStack {
                        
                        
                        Circle()
                            .fill(.colorOrange)
                            .frame(width: 160)
                            .opacity(0.4)
                        
                        Circle()
                            .fill(.colorOrange)
                            .frame(width: 140)
                            .opacity(0.7)
                        
                        Circle()
                            .fill(.colorOrange)
                            .frame(width: 120)
                        LottieView(animation: .named("dog2"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
                VStack(spacing: 2){
                    Text("\(crewVM.crew.crewName ?? "Flavor")")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(Color(.systemGray))
                    
                    HStack(spacing: 4){
                        Text("\(viewModel.challenge.title)")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.colorOrange)
                    }
                    
                    if let index = viewModel.winningPosts.firstIndex(where: {$0.id == Auth.auth().currentUser?.uid}) {
                        Text("You placed #\(index + 1)")
                            .font(.primaryFont(.P1))
                    }
                   
                }
                
                
                Divider()
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                VStack(spacing: 8){
                    
                    if viewModel.winningPosts.count > 0 {
                        HStack{
                            
                            Text("🥇")
                            
                            
                            Text("@\(viewModel.winningPosts[0].user?.userName ?? "")")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            Spacer()
                            
                            Text("\(viewModel.winningPosts[0].votes) votes")
                                .font(.primaryFont(.P2))
                                .foregroundStyle(Color(.systemGray))
                        }.padding(.horizontal, 8)
                    }
                    
                    if viewModel.winningPosts.count > 1 {
                        HStack{
                            
                            Text("🥈")
                            
                            Text("@\(viewModel.winningPosts[1].user?.userName ?? "")")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            Spacer()
                            
                            Text("\(viewModel.winningPosts[1].votes) votes")
                                .font(.primaryFont(.P2))
                                .foregroundStyle(Color(.systemGray))
                        }.padding(.horizontal, 8)
                    }
                    
                    if viewModel.winningPosts.count > 2 {
                        HStack{
                            
                            Text("🥉")
                            
                            Text("@\(viewModel.winningPosts[2].user?.userName ?? "")")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            Spacer()
                            
                            Text("\(viewModel.winningPosts[2].votes) votes")
                                .font(.primaryFont(.P2))
                                .foregroundStyle(Color(.systemGray))
                        }.padding(.horizontal, 8)
                    }
                    
                }.padding(.vertical, 8)
                
                
                
                
                NavigationLink(destination: 
                                MainChallengeView(challenge: viewModel.challenge, crewVM: crewVM)
                    .environmentObject(homeVM)
                    .environmentObject(crewVM)
                    .onFirstAppear {
                        Task {
                            try await crewVM.registeredUserSeenResults()
                        }
                    }
                ){
                    Text("Go to challenge")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                        .foregroundStyle(.colorWhite)
                        .padding(8)
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.colorOrange)
                        )
                       
                } .padding(.vertical, 16)
                
                
                
                
            }
            
            Button(action: {
                Task {
                    try await crewVM.registeredUserSeenResults()
                }
            }){
                Iconoir.xmark.asImage
                    .foregroundStyle(.black)
                    
            }.padding(8)
        }.frame(width: width - 64)
        
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.colorWhite)
                    .stroke(Color(.systemGray))
            
            )
            .onFirstAppear {
                Task {
                    try await viewModel.fetchWinningPosts()
                }
        }
            
    }
}

#Preview {
    FinishedChallengeCell(challenge: Challenge.mockChallenges[0])
}
