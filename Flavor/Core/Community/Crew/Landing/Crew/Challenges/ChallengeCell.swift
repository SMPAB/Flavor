//
//  ChallengeCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import SwiftUI
import Firebase
import Iconoir

struct ChallengeCell: View {
    
    let challenge: Challenge
    
    var body: some View {
        if challenge.startDate.dateValue() > Date() {
            VStack(spacing: 0){
                HStack{
                    Spacer()
                    Iconoir.calendar.asImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.colorWhite)
                    
                    Text("Starting: \(challenge.startDate.dateValue().formattedChallengeCell())")
                        .font(.primaryFont(.P2))
                        .foregroundStyle(.colorWhite)
                }
                
                HStack(spacing: 16){
                    ImageView(size: .small, imageUrl: challenge.imageUrl, background: false)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                            .fill(Color.clear)
                            .stroke(.colorWhite, lineWidth: 2)
                        )
                    
                    
                    VStack(alignment: .leading){
                        Text(challenge.title)
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.colorWhite)
                        
                        Text(challenge.description)
                            .font(.primaryFont(.P2))
                            .foregroundStyle(.colorWhite)
                    }
                    Spacer()
    
                }.padding(.horizontal, 16)
            }.frame(height: 82, alignment: .top)
                .padding(4)
            
            .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray4))
                .stroke(Color(.systemGray4))
            )
        } else if challenge.endDate.dateValue() < Date(){
            VStack(spacing: 0){
                HStack{
                    Spacer()
                    Iconoir.calendar.asImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.colorWhite)
                    
                    Text("Ended: \(challenge.endDate.dateValue().formattedChallengeCell())")
                        .font(.primaryFont(.P2))
                        .foregroundStyle(.black)
                }
                
                HStack(spacing: 16){
                    ImageView(size: .small, imageUrl: challenge.imageUrl, background: false)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                            .fill(Color.clear)
                            .stroke(.colorWhite, lineWidth: 2)
                        )
                    
                    
                    VStack(alignment: .leading){
                        Text(challenge.title)
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.black)
                        
                        Text(challenge.description)
                            .font(.primaryFont(.P2))
                            .foregroundStyle(.black)
                    }
                    Spacer()
    
                }.padding(.horizontal, 16)
            }.frame(height: 82, alignment: .top)
                .padding(4)
            
            .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.colorWhite))
                .stroke(Color(.systemGray4))
            )
        } else {
            VStack(spacing: 0){
                HStack{
                    Spacer()
                    Iconoir.calendar.asImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.colorWhite)
                    
                    Text("Ending: \(challenge.endDate.dateValue().formattedChallengeCell())")
                        .font(.primaryFont(.P2))
                        .foregroundStyle(.colorWhite)
                }
                
                HStack(spacing: 16){
                    
                    ZStack{
                        ImageView(size: .small, imageUrl: challenge.imageUrl, background: false)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                .fill(Color.clear)
                                .stroke(.colorWhite, lineWidth: 2)
                            )
                        
                        if challenge.completedUsers.contains(Auth.auth().currentUser?.uid ?? "") {
                            Iconoir.checkCircleSolid.asImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(Color(.systemGreen))
                                .background(
                                Circle()
                                    .fill(.colorWhite)
                                )
                                .offset(x: 22.5, y: 22.5)
                        } else {
                            Iconoir.xmarkCircleSolid.asImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(Color(.systemRed))
                                .background(
                                Circle()
                                    .fill(.colorWhite)
                                )
                                .offset(x: 22.5, y: 22.5)
                        }
                    }
                    
                    
                    
                    VStack(alignment: .leading){
                        Text(challenge.title)
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.colorWhite)
                        
                        Text(challenge.description)
                            .font(.primaryFont(.P2))
                            .foregroundStyle(.colorWhite)
                    }
                    Spacer()
    
                }.padding(.horizontal, 16)
            }.frame(height: 82, alignment: .top)
                .padding(4)
            
            .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.colorOrange))
                .stroke(Color(.colorOrange))
            )
        }
    }
}

#Preview {
    
    ChallengeCell(challenge: Challenge(id: "", crewId: "", title: "Taco fredag", description: "gör den fetaste tacon ni möjligvis kan göra", startDate: Timestamp(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!), endDate: Timestamp(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!), votes: 3, users: [], completedUsers: []))
}

extension Date {
    func formattedChallengeCell() -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, HH:mm"
        
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "'today,' HH:mm"
        } else if calendar.isDateInYesterday(self) {
            dateFormatter.dateFormat = "'yesterday,' HH:mm"
        } else if calendar.isDateInTomorrow(self) {
            dateFormatter.dateFormat = "'tomorrow,' HH:mm"
        }
        
        return dateFormatter.string(from: self)
    }
}
