//
//  LandingPublicChallenges.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-05.
//

import SwiftUI
import Iconoir

struct LandingPublicChallenges: View {
    
    @StateObject var viewModel = LandingPublicChallengesViewModel()
    
    var body: some View {
        VStack(spacing: 16){
            //MARK: Search
            
            CustomTextField(text: $viewModel.searchText, textInfo: "Search...", secureField: false, multiRow: false, search: true)
                .padding(.horizontal, 16)
            
            if !viewModel.userChallenges.isEmpty {
                VStack(alignment: .leading){
                    Text("Your Active Challenges")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    ForEach(viewModel.userChallenges) { challenge in
                        LandingChallengeCellview(challenge: challenge)
                    }
                }.padding(.top, 16)
            }
            
        }
    }
}

#Preview {
    LandingPublicChallenges()
}
