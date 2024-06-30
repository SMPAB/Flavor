//
//  StatsView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-29.
//

import SwiftUI
import Firebase

struct StatsView: View {
    
    @EnvironmentObject var crewVM: MainCrewViewModel
    @Environment(\.dismiss) var dismiss
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
                    
                    Text("Leaderboard")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left").opacity(0)
                }.padding(.horizontal, 16)
                
                
                VStack(alignment: .leading){
                    VStack(spacing: 2){
                        Text("Top 3")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                            .foregroundStyle(.colorWhite)
                        
                        Text("out of \(crewVM.challenges.count) challenges")
                            .font(.primaryFont(.P2))
                            .foregroundStyle(.colorWhite)
                    }
                    .padding(.horizontal, 16)
                    
                    
                    HStack(alignment: .bottom, spacing: 0){
                        ZStack{
                            
                            Rectangle()
                                .fill(Color(red: 241/255, green: 162/255, blue: 74/255))
                                .frame(maxWidth: .infinity)
                                .frame(height: 74)
                                .roundedCorner(8, corners: [.bottomLeft])
                                .roundedCorner(24, corners: [.topLeft])
                                
                           
                            VStack{
                                if crewVM.ratingUsers.count > 1 {
                                    ImageView(size: .small, imageUrl: crewVM.ratingUsers[1].user?.profileImageUrl, background: false)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(Color.clear)
                                                .stroke(.gray, lineWidth: 3)
                                        )
                                    
                                    Text("@\(crewVM.ratingUsers[1].user?.userName ?? "")")
                                        .font(.primaryFont(.P2))
                                        .foregroundStyle(.colorWhite)
                                        .fontWeight(.semibold)
                                }
                            }.offset(y: -40)
                            
                           
                        }
                        
                        ZStack{
                            
                            Rectangle()
                                .fill(Color(red: 244/255, green: 184/255, blue: 115/255))
                                .frame(maxWidth: .infinity)
                                .frame(height: 104)
                                .roundedCorner(24, corners: [.topRight])
                                .roundedCorner(24, corners: [.topLeft])
                                
                            
                            VStack{
                                if crewVM.ratingUsers.count > 0 {
                                    ImageView(size: .medium, imageUrl: crewVM.ratingUsers[0].user?.profileImageUrl, background: false)
                                        .background(
                                            RoundedRectangle(cornerRadius: 9)
                                                .fill(Color.clear)
                                                .stroke(.yellow, lineWidth: 3)
                                        )
                                    
                                    Text("@\(crewVM.ratingUsers[0].user?.userName ?? "")")
                                        .font(.primaryFont(.P2))
                                        .foregroundStyle(.colorWhite)
                                        .fontWeight(.semibold)
                                }
                            }.offset(y: -65)
                            
                            Image(.emojiCrown)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .offset(y: -125)
                        }
                        
                        
                        ZStack{
                            
                            Rectangle()
                                .fill(Color(red: 241/255, green: 162/255, blue: 74/255))
                                .frame(maxWidth: .infinity)
                                .frame(height: 74)
                                .roundedCorner(8, corners: [.bottomRight])
                                .roundedCorner(24, corners: [.topRight])
                                
                            
                            VStack{
                                if crewVM.ratingUsers.count > 2 {
                                    ImageView(size: .small, imageUrl: crewVM.ratingUsers[2].user?.profileImageUrl, background: false)
                                        .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.clear)
                                            .stroke(.brown, lineWidth: 3)
                                        )
                                    
                                    Text("@\(crewVM.ratingUsers[2].user?.userName ?? "")")
                                        .font(.primaryFont(.P2))
                                        .foregroundStyle(.colorWhite)
                                        .fontWeight(.semibold)
                                }
                                
                            }.offset(y: -40)
                            
                           
                        }
                        
                        
                        
                    }
                    .frame(height: 185, alignment: .bottom)
                       
                }.padding(.top, 16)
                    
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.colorOrange)
                )
            }.padding(.bottom, 8)
            
            if crewVM.ratingUsers.count > 3 {
                ForEach(3..<crewVM.ratingUsers.count, id: \.self) { index in
                                           if let user = crewVM.ratingUsers[index].user {
                                               HStack {
                                                   ImageView(size: .small, imageUrl: user.profileImageUrl, background: false)
                                                   
                                                   Text("@\(user.userName)")
                                                       .font(.primaryFont(.P1))
                                                       .fontWeight(.semibold)
                                                   
                                                   Spacer()
                                                   
                                                   Text("#\(index + 1)")
                                                       .font(.primaryFont(.P1))
                                                       .foregroundStyle(Color.gray)
                                               }
                                               .padding(.horizontal, 16)
                                           }
                                       }
            }
            
        }.onFirstAppear {
            Task{
                try await crewVM.fetchRatingUsers()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    StatsView()
        .environmentObject(MainCrewViewModel(crew: Crew(id: "", admin: "", crewName: "", creationDate: Timestamp(date: Date()), publicCrew: true, uids: [])))
}
