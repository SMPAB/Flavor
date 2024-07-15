//
//  PublicChallengeFocusView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-08.
//

import SwiftUI
import Kingfisher
import Iconoir

struct PublicChallengeFocusView: View {
    
    @StateObject var viewModel: PublicChallengeFocusVM
    @EnvironmentObject var landingVM: LandingPublicChallengesViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State var navigateToChallenge = false
    
    
    init(challenge: PublicChallenge, homeVM: HomeViewModel, landingVM: LandingPublicChallengesViewModel) {
        self._viewModel = StateObject(wrappedValue: PublicChallengeFocusVM(challenge: challenge, homeVM: homeVM, landingVM: landingVM))
    }
    
    var challenge: PublicChallenge {
        return viewModel.challenge
    }
    
    var joined: Bool {
        return challenge.hasJoined ?? false
    }
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        ScrollView {
            VStack (spacing: 0){
                ZStack (alignment: .topLeading){
                    if let imageUrl = challenge.imageUrl {
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: 176)
                            .clipShape(Rectangle())
                            .contentShape(Rectangle())
                    }
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.colorWhite)
                            .shadow(radius: 4)
                            
                    }).padding(.leading, 24)
                        .padding(.top, 40)
                }
                
                VStack(spacing: 16){
                    ImageView(size: .medium, imageUrl: challenge.ownerImageUrl, background: false)
                    
                    VStack(spacing: 8){
                        Text(challenge.title)
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        Text(challenge.description)
                            .font(.primaryFont(.P1))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }.padding(.horizontal, 16)
                    }
                   
                    .offset(y: -36)
                
                if joined {
                    
                    
                    CustomButton(text: "Go to challenge", textColor: .black, backgroundColor: .colorWhite, strokeColor: Color(.systemGray), action: {
                        handleJoinedTapped()
                    }) .padding(.horizontal, 16)
                } else {
                    CustomButton(text: "Join", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: Color(.colorOrange), action: {
                        handleJoinedTapped()
                    }) .padding(.horizontal, 16)
                }
                
               
                
                Rectangle()
                    .fill(Color(.systemGray))
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 32)
                
                
                VStack(spacing: 16){
                    
                    
                    HStack{
                        Iconoir.trophy.asImage
                        
                        Text(challenge.prizeDescription)
                            .font(.primaryFont(.P1))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                    
                    
                    HStack{
                        Iconoir.calendar.asImage
                        
                        Text("\(challenge.startDate.dateValue().formattedChallengeCell()) to \(challenge.endDate.dateValue().formattedChallengeCell())")
                            .font(.primaryFont(.P1))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                }.padding(.horizontal, 16)
                
                
                Rectangle()
                    .fill(Color(.systemGray))
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 32)
                
                
                HStack(alignment: .top){
                    ImageView(size: .medium, imageUrl: challenge.ownerImageUrl, background: false)
                    
                    VStack(alignment: .leading){
                        Text("organized")
                            .font(.primaryFont(.P2))
                        
                        Text(challenge.ownerName)
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        HStack{
                            if let instagram = challenge.ownerInstagram {
                                Link(destination: URL(string: instagram)!, label: {
                                    Iconoir.instagram.asImage
                                        .resizable()
                                        .foregroundStyle(.black)
                                        .frame(width: 16, height: 16)
                                })
                            }
                            
                            if let facebook = challenge.ownerFacebook {
                                Link(destination: URL(string: facebook)!, label: {
                                    Iconoir.facebook.asImage
                                        .resizable()
                                        .foregroundStyle(.black)
                                        .frame(width: 16, height: 16)
                                })
                            }
                            
                            if let tiktok = challenge.ownerTiktok {
                                Link(destination: URL(string: tiktok)!, label: {
                                    Iconoir.tiktok.asImage
                                        .resizable()
                                        .foregroundStyle(.black)
                                        .frame(width: 16, height: 16)
                                })
                            }
                        }
                    }
                    
                    Spacer()
                }.padding(.horizontal, 16)
            }
        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all)
            .customAlert(isPresented: $viewModel.showLeveChallengeAlert, title: nil, message: "Are you sure you want to leave the challenge, if you have published any posts they will be removed!", boldMessage: nil, afterBold: nil, confirmAction: {
                Task {
                    try await viewModel.leaveChallenge()
                    viewModel.showLeveChallengeAlert = false
                }
            }, cancelAction: {
                viewModel.showLeveChallengeAlert = false
            }, imageUrl: nil, dismissText: "Cancel", acceptText: "Leave")
        
            .navigationDestination(isPresented: $navigateToChallenge){
                MainPublicChallengeView(challenge: challenge, landingVM: landingVM)
                    .environmentObject(homeVM)
            }
    }
    
    func handleJoinedTapped() {
        if joined {
            //viewModel.showLeveChallengeAlert.toggle()
            navigateToChallenge.toggle()
        } else {
            Task {
               try await viewModel.joinChallenge()
            }
        }
    }
}
/*
#Preview {
    PublicChallengeFocusView(challenge: PublicChallenge.mockChallenges[0], homeVM: HomeViewModel(user: User.mockUsers[0]), landingVM: <#LandingPublicChallengesViewModel#>)
}*/
