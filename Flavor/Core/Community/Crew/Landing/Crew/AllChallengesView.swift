//
//  AllChallengesView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-05.
//

import SwiftUI

struct AllChallengesView: View {
    
    @EnvironmentObject var viewModel: MainCrewViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        
        var upCommingChallenges = viewModel.challenges.filter({$0.startDate.dateValue() > Date()})
        var activeChallenges = viewModel.challenges.filter({$0.startDate.dateValue() < Date() && $0.endDate.dateValue() > Date()})
        var pastChallenges = viewModel.challenges.filter({$0.endDate.dateValue() < Date()})
        
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
                    
                    Text("Past Challenges")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left").opacity(0)
                }.padding(.horizontal, 16)
                
                
                Divider()
                
                //MARK: ACTIVE
                
                
                if !pastChallenges.isEmpty {
                    VStack(alignment: .leading){
                        
                        
                        ForEach(pastChallenges){ challenge in
                            NavigationLink(destination:
                                            MainChallengeView(challenge: challenge, crewVM: viewModel)
                                .environmentObject(homeVM)
                            ){
                                ChallengeCell(challenge: challenge)
                                    .foregroundStyle(.black)
                                    
                            }
                            
                        }
                    }.padding(.horizontal, 16)
                        .padding(.top)
                } else {
                    Text("Your crew has no past challenges")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(Color(.systemGray))
                }
                
                
                
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AllChallengesView()
}
