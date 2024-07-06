//
//  FinishedChallengeView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-06.
//

import SwiftUI
import Iconoir

struct FinishedChallengeView: View {
    
    @Binding var challenges: [Challenge]
    
    @EnvironmentObject var crewVM: MainCrewViewModel
    @EnvironmentObject var homevVM: HomeViewModel
    
    @State var selection = 0
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        ZStack{
            Rectangle()
                .fill(.black)
                .opacity(0.3)
                .scaleEffect(1.6)
                .ignoresSafeArea(.all)
                .onTapGesture {
                Task {
                   try await crewVM.registeredUserSeenResults()
                }
            }
            
            
            HStack(spacing: 8){
                
                
                /*if selection != 0 {
                    if challenges.count > 1 {
                        Button(action: {
                            withAnimation{
                                selection -= 1
                            }
                        }){
                           Image(systemName: "chevron.left")
                                .foregroundStyle(.colorWhite)
                        }
                    }
                }else {
                    Image(systemName: "chevron.right").opacity(0)
                }*/
                
                
                TabView(selection: $selection){
                    ForEach(challenges) { challenge in
                        FinishedChallengeCell(challenge: challenge)
                            .environmentObject(homevVM)
                            .environmentObject(crewVM)
                            
                    }
                }.frame(width: width - 64)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 440)
                
                
                /*if selection != challenges.count {
                    if challenges.count > 1 {
                        Button(action: {
                            withAnimation{
                                selection += 1
                            }
                            
                        }){
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.colorWhite)
                        }
                    }
                } else {
                    Image(systemName: "chevron.right").opacity(0)
                }*/
                
            }
            
        }
    }
}

#Preview {
    FinishedChallengeView(challenges: .constant([Challenge.mockChallenges[0], Challenge.mockChallenges[0]]))
        
}
