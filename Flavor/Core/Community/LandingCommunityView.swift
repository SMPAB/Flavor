//
//  LandingCommunityView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-19.
//

import SwiftUI

struct LandingCommunityView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State var crew = true
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        VStack{
            VStack(spacing: 10){
                HStack{
                    Text("Crews")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                        .frame(width: 153)
                        .foregroundStyle(crew ? .black : Color(.systemGray))
                        .onTapGesture {
                            withAnimation{
                                crew = true
                            }
                        }
                    
                    Spacer()
                    
                    Text("Challenges")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                        .frame(width: 153)
                        .foregroundStyle(!crew ? .black : Color(.systemGray))
                        .onTapGesture {
                            withAnimation{
                                crew = false
                            }
                        }
                }.padding(.horizontal, 16)
                
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 153, height: 2)
                    .offset(x: crew ? -(width/2 - 92.5) :  (width/2 - 92.5))
            }
            
            
            ZStack{
                LandingCrewView()
                    .environmentObject(homeVM)
                    .offset(x: crew ? 0 : -width)
                
                LandingPublicChallenges()
                    .environmentObject(homeVM)
                    .offset(x: crew ? width : 0)
                    
            }
            
            
            
            Spacer()
            
        }
    }
}

#Preview {
    LandingCommunityView()
}
