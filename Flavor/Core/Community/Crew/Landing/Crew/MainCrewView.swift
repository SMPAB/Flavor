//
//  MainCrewView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import SwiftUI
import Iconoir
import Kingfisher

struct MainCrewView: View {
    
    @StateObject var viewModel: MainCrewViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    init(crew: Crew){
        self._viewModel = StateObject(wrappedValue: MainCrewViewModel(crew: crew))
    }
    var body: some View {
        ScrollView{
            VStack(spacing: 16){
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
                
                
                ImageView(size: .large, imageUrl: viewModel.crew.imageUrl, background: true)
                
                Text(viewModel.crew.crewName)
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                
                HStack(spacing: 0){
                    
                    Spacer()
                    
                    HStack(spacing: 3){
                        Iconoir.community.asImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 16, height: 16)
                        
                        Text("\(viewModel.crew.uids.count) members")
                            .font(.primaryFont(.P2))
                    }
                    
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1, height: 24)
                        .padding(.horizontal, 8)
                    
                    HStack(spacing: 3){
                        Iconoir.trophy.asImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 16, height: 16)
                        
                        Text("\(viewModel.crew.challengeIds?.count ?? 0) challenges")
                            .font(.primaryFont(.P2))
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: 32){
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        Iconoir.plus.asImage
                            .foregroundStyle(.colorWhite)
                            .frame(width: 40, height: 40)
                            .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.colorOrange)
                                .stroke(.colorOrange)
                            )
                    }
                    
                    Button(action: {
                        
                    }){
                        Iconoir.statsReport.asImage
                            .foregroundStyle(.colorOrange)
                            .frame(width: 40, height: 40)
                            .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.colorWhite)
                                .stroke(.colorOrange)
                            )
                    }
                    
                    
                    Button(action: {
                        
                    }){
                        Iconoir.mail.asImage
                            .foregroundStyle(.colorOrange)
                            .frame(width: 40, height: 40)
                            .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.colorWhite)
                                .stroke(.colorOrange)
                            )
                    }
                    
                    
                    Spacer()
                }
                
                
                var upCommingChallenges = viewModel.challenges.filter({$0.startDate.dateValue() > Date()})
                var activeChallenges = viewModel.challenges.filter({$0.startDate.dateValue() < Date() && $0.endDate.dateValue() > Date()})
                var pastChallenges = viewModel.challenges.filter({$0.endDate.dateValue() < Date()})
                
                if !activeChallenges.isEmpty {
                    VStack(alignment: .leading){
                        Text("Active Challenges")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        ForEach(activeChallenges){ challenge in
                            ChallengeCell(challenge: challenge)
                        }
                    }.padding(.horizontal, 16)
                }
                
                if !upCommingChallenges.isEmpty {
                    VStack(alignment: .leading){
                        Text("Upcomming Challenges")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        ForEach(upCommingChallenges){ challenge in
                            ChallengeCell(challenge: challenge)
                        }
                    }.padding(.horizontal, 16)
                }
            }
        }.navigationBarBackButtonHidden(true)
            .onFirstAppear {
                Task{
                    try await viewModel.fetchChallenges()
                }
            }
    }
}
/*
#Preview {
    MainCrewView()
}*/
