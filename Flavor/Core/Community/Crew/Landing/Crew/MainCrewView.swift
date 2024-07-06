//
//  MainCrewView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import SwiftUI
import Iconoir
import Kingfisher
import Firebase

struct MainCrewView: View {
    
    @StateObject var viewModel: MainCrewViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var showEdit = false
    @State var showCreateChallenge = false
    
    init(crew: Crew, landingVM: LandingCrewViewModel){
        self._viewModel = StateObject(wrappedValue: MainCrewViewModel(crew: crew, landingVM: landingVM))
    }
    var body: some View {
        ZStack {
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
                        
                        if viewModel.crew.admin == Auth.auth().currentUser?.uid{
                            Button(action: {
                                showEdit.toggle()
                            }){
                                Iconoir.settings.asImage
                                    .foregroundStyle(.black)
                            }
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
                            showCreateChallenge.toggle()
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
                        
                        NavigationLink(destination:
                        StatsView()
                            .environmentObject(viewModel)
                        ){
                            Iconoir.statsReport.asImage
                                .foregroundStyle(.colorOrange)
                                .frame(width: 40, height: 40)
                                .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.colorWhite)
                                    .stroke(.colorOrange)
                                )
                        }
                        
                        
                        NavigationLink(destination: 
                                        Text("Chat")
                        ){
                            Iconoir.chatBubbleEmpty.asImage
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
                            
                            HStack{
                                
                                Text("Active Challenges")
                                    .font(.primaryFont(.H4))
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                NavigationLink(destination: 
                                                AllChallengesView()
                                    .environmentObject(homeVM)
                                    .environmentObject(viewModel)
                                ){
                                    Text("show past")
                                        .font(.primaryFont(.P2))
                                        .foregroundStyle(.black)
                                }
                            }
                            
                            
                            ForEach(activeChallenges){ challenge in
                                NavigationLink(destination: 
                                                MainChallengeView(challenge: challenge, crewVM: viewModel)
                                    .environmentObject(homeVM)
                                ){
                                    ChallengeCell(challenge: challenge)
                                        .foregroundStyle(.black)
                                        
                                }
                                
                            }
                        }.padding(.horizontal, 16)
                    }
                    
                    if !upCommingChallenges.isEmpty {
                        VStack(alignment: .leading){
                            
                            HStack{
                                Text("Upcomming Challenges")
                                    .font(.primaryFont(.H4))
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                NavigationLink(destination: 
                                                AllChallengesView()
                                    .environmentObject(homeVM)
                                    .environmentObject(viewModel)
                                ){
                                    Text("show past")
                                        .font(.primaryFont(.P2))
                                        .foregroundStyle(.black)
                                }
                            }
                            
                            
                            ForEach(upCommingChallenges){ challenge in
                                ChallengeCell(challenge: challenge)
                            }
                        }.padding(.horizontal, 16)
                    }
                    
                //MARK: FORUM
                    HStack{
                        Text("Forum")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.linear(duration: 0.1)){
                                viewModel.showNewAnnouncement.toggle()
                            }
                        }){
                            Iconoir.plus.asImage
                                .foregroundStyle(.black)
                        }
                        
                        
                    }.padding(.horizontal, 16)
                    
                    
                    ScrollView {
                        ForEach(viewModel.forumPosts) { forum in
                            ForumCell(forum: forum)
                                .padding(.horizontal, 16)
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
            
            if viewModel.showNewAnnouncement {
                NewAnnouncementView()
                    .environmentObject(viewModel)
                    .environmentObject(homeVM)
            }
            
            
             var newFinishedChallenges = viewModel.challenges.filter({($0.showFinishToUserIds ?? []).contains(Auth.auth().currentUser?.uid ?? "")})
            
            if !newFinishedChallenges.isEmpty && !viewModel.dontShowResults {
                FinishedChallengeView(challenges: .constant(newFinishedChallenges))
                    .environmentObject(homeVM)
                    .environmentObject(viewModel)
            }
            
        }.navigationBarBackButtonHidden(true)
            .onFirstAppear {
                Task{
                    try await viewModel.fetchChallenges()
                    try await viewModel.fetchForums()
                }
            }
            .fullScreenCover(isPresented: $showEdit){
                EditCrewView()
                    .environmentObject(viewModel)
                    .environmentObject(homeVM)
            }
        
            .fullScreenCover(isPresented: $showCreateChallenge){
                CreateChallengeView()
                    .environmentObject(viewModel)
        }
    }
    
}

#Preview {
    MainCrewView(crew: Crew(id: "", admin: "", crewName: "SMP", creationDate: Timestamp(date: Date()), publicCrew: false, uids: []), landingVM: LandingCrewViewModel())
}
