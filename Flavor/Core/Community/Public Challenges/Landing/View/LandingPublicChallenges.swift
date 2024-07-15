//
//  LandingPublicChallenges.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-05.
//

import SwiftUI
import Iconoir
import Kingfisher

struct LandingPublicChallenges: View {
    
    @StateObject var viewModel = LandingPublicChallengesViewModel()
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        
        let width = UIScreen.main.bounds.width
        ScrollView {
            VStack(spacing: 16){
                //MARK: Search
              /*
                CustomTextField(text: $viewModel.searchText, textInfo: "Search...", secureField: false, multiRow: false, search: true)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)*/
                
                if !viewModel.userChallenges.isEmpty {
                    VStack(alignment: .leading){
                        Text("Your Active Challenges")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal){
                            HStack {
                                ForEach(viewModel.userChallenges) { challenge in
                                    
                                    NavigationLink(destination: MainPublicChallengeView(challenge: challenge, landingVM: viewModel)
                                        .environmentObject(homeVM)
                                    ) {
                                        LandingChallengeCellview(challenge: challenge)
                                            .environmentObject(homeVM)
                                            .foregroundStyle(.black)
                                            .padding(.vertical, 4)
                                    }
                                    
                                }
                            } .padding(.horizontal, 16)
                            
                        }
                        
                    }
                       
                }
                
                if viewModel.otherChallenges.count > 0 {
                    NavigationLink(destination:
                                    PublicChallengeFocusView(challenge: viewModel.otherChallenges[0], homeVM: homeVM, landingVM: viewModel)
                        .environmentObject(viewModel)
                        .environmentObject(homeVM)
                      
                    ) {
                        VStack(spacing: 16){
                            if let imageUrl = viewModel.otherChallenges[0].imageUrl {
                                KFImage(URL(string: imageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width - 32, height: 128)
                                    .clipShape(Rectangle())
                                    .contentShape(Rectangle())
                                    .roundedCorner(16, corners: [.topLeft, .topRight])
                            }
                            
                            
                            VStack(spacing: 16){
                                HStack{
                                    VStack(alignment: .leading){
                                        Text(viewModel.otherChallenges[0].title)
                                            .font(.primaryFont(.P1))
                                            .fontWeight(.semibold)
                                        
                                        Text(viewModel.otherChallenges[0].description)
                                            .font(.primaryFont(.P2))
                                            .foregroundStyle(Color(.systemGray))
                                            .frame(maxWidth: .infinity)
                                    }
                                    
                                    ImageView(size: .small, imageUrl: viewModel.otherChallenges[0].ownerImageUrl, background: false)
                                }
                                
                                Text("View")
                                    .font(.primaryFont(.P1))
                                    .foregroundStyle(.colorWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.colorOrange)
                                    )
                            }.padding(.horizontal, 16)
                                .padding(.bottom, 8)
                            
                        }.frame(width: width - 32)
                            
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.colorWhite)
                                    .shadow(color: .colorOrange, radius: 4)
                                    .opacity(0.2)
                            )
                            .padding(.top, 8)
                        
                        .frame(width: width)
                    }.foregroundStyle(.black)
                }
                
            }
        }.padding(.top, 16)
        .onFirstAppear {
            Task {
                try await viewModel.fetchChallenges(user: homeVM.user)
            }
            
            
    }
        
    }
}

#Preview {
    LandingPublicChallenges()
}
