//
//  LandingChallengeCellview.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-05.
//

import SwiftUI
import Iconoir

struct LandingChallengeCellview: View {
    
    @StateObject var viewModel: LandingChallengeCellVM
    @EnvironmentObject var homeVM: HomeViewModel
    
    init(challenge: PublicChallenge) {
        self._viewModel = StateObject(wrappedValue: LandingChallengeCellVM(challenge: challenge))
    }
    
    var challenge: PublicChallenge {
        return viewModel.challenge
    }
    
    var hasVoted: Bool {
        return challenge.userDoneVoting ?? false
    }
    
    var hasPublished: Bool {
        return challenge.userHasPublished ?? false
    }
    var body: some View {
        ZStack(alignment: .topTrailing){
            HStack(alignment: .top, spacing: 8){
                ImageView(size: .small, imageUrl: challenge.imageUrl, background: true)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                    
                    HStack{
                        Text("Status:")
                            .font(.primaryFont(.P2))
                        
                        if !hasVoted {
                            HStack(spacing: 4){
                                Text("Not voted")
                                    .font(.primaryFont(.P2))
                                
                               Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    
                                
                            }.foregroundStyle(Color(.systemRed))
                        } else {
                            
                            HStack(spacing: 4){
                                Text("voted")
                                    .font(.primaryFont(.P2))
                                
                               Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    
                                
                            }.foregroundStyle(Color(.systemGreen))
                            
                        }
                        
                        
                        if !hasPublished {
                            HStack(spacing: 4){
                                Text("Not Posted")
                                    .font(.primaryFont(.P2))
                                
                               Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    
                                
                            }.foregroundStyle(Color(.systemRed))
                        } else {
                            
                            HStack(spacing: 4){
                                Text("Posted")
                                    .font(.primaryFont(.P2))
                                
                               Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    
                                
                            }.foregroundStyle(Color(.systemGreen))
                            
                        }
                        
                    }.frame(height: 10)
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding(16)
            
            Text("Ending: \(challenge.endDate.dateValue().formattedChallengeCell())")
                .font(.primaryFont(.P2))
                .padding(4)
            
        }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.colorWhite)
                    .stroke(.colorOrange)
            )
            .onFirstAppear {
                Task {
                    try await viewModel.checkIfUseHasVoted()
                    try await viewModel.checkIfUserHasPublished()
                }
            }
        
            .onChange(of: homeVM.newUploadPublicChallenge) {
                viewModel.challenge.userHasPublished = true
            }
            .onChange(of: homeVM.newDeletePublicChallenge) {
                viewModel.challenge.userHasPublished = false
            }
            .onChange(of: homeVM.newVotePublicChallenge) {
                viewModel.challenge.userDoneVoting = true
            }
            .onChange(of: homeVM.newunVotePublicChallenge) {
                viewModel.challenge.userDoneVoting = false
            }
            
    }
}

#Preview {
    LandingChallengeCellview(challenge: PublicChallenge.mockChallenges[0])
}
