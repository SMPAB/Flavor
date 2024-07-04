//
//  NewAnnouncementView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-03.
//

import SwiftUI
import Firebase
import Iconoir

struct NewAnnouncementView: View {
    
    @EnvironmentObject var crewVM: MainCrewViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @State var text = ""
    @State var uploading = false
    
    @State var announcement = false
    @State var voting = false
    
    @State var showChooseAlert = false
    var body: some View {
        ZStack{
            Color.black.opacity(0.4).ignoresSafeArea(.all)
            
            VStack{
                Text("New Crew Message")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                
                TextField("Write here", text: $text, axis: .vertical)
                    .font(.primaryFont(.P2))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(8)
                    .frame(height: 120, alignment: .top)
                    .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.colorWhite)
                        .stroke(Color(.systemGray4))
                    )
                    
               /* Spacer()
                
                Iconoir.megaphone.asImage
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.colorOrange)
                    .frame(width: 54, height: 54)*/
                
                Spacer()
                
                HStack{
                    Button(action: {
                        if announcement {
                            announcement = false
                            voting = false
                        } else {
                            announcement = true
                            voting = false
                        }
                    }){
                        
                        if announcement {
                            VStack{
                                Iconoir.megaphone.asImage
                                    .frame(width: 32, height: 32)
                                    .foregroundStyle(.colorWhite)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.colorOrange)
                                            .stroke(.colorOrange)
                                        )
                                
                                Text("Announcement")
                                    .font(.primaryFont(.P2))
                                    .fontWeight(.semibold)
                            }.foregroundStyle(.colorOrange)
                                .frame(width: 85)
                        } else {
                            VStack{
                                Iconoir.megaphone.asImage
                                    .frame(width: 32, height: 32)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.colorWhite)
                                            .stroke(.colorOrange)
                                        )
                                
                                Text("Announcement")
                                    .font(.primaryFont(.P2))
                                    .fontWeight(.semibold)
                            }.foregroundStyle(.colorOrange)
                                .frame(width: 85)
                        }
                        
                        
                           
                            
                        
                    }
                    
                    Button(action: {
                        if voting {
                            voting = false
                            announcement = false
                        } else {
                            voting = true
                            announcement = false
                        }
                    }){
                        
                        if voting {
                            VStack{
                                Iconoir.podcast.asImage
                                    .frame(width: 32, height: 32)
                                    .foregroundStyle(.colorWhite)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.colorOrange)
                                            .stroke(.colorOrange)
                                        )
                                
                                Text("crew-voting")
                                    .font(.primaryFont(.P2))
                                    .fontWeight(.semibold)
                            }.foregroundStyle(.colorOrange)
                                .frame(width: 85)
                        } else {
                            VStack{
                                Iconoir.podcast.asImage
                                    .frame(width: 32, height: 32)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.colorWhite)
                                            .stroke(.colorOrange)
                                        )
                                
                                Text("crew-voting")
                                    .font(.primaryFont(.P2))
                                    .fontWeight(.semibold)
                            }.foregroundStyle(.colorOrange)
                                .frame(width: 85)
                        }
                        
                        
                           
                            
                        
                    }
                }
                
                Spacer()
                
                Button(action: {
                    
                    if announcement == false && voting == false {
                        showChooseAlert.toggle()
                    } else {
                        if !uploading && text != ""{
                            Task {
                                uploading = true
                                try await crewVM.newAnnouncement(text: text, currentUser: homeVM.user, voting: voting)
                                crewVM.showNewAnnouncement = false
                                uploading = false
                            }
                            
                            
                        }
                    }
                   
                }) {
                    Text("Send")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(.colorWhite)
                        .fontWeight(.semibold)
                        .frame(width: 120, height: 52)
                        .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(.colorOrange)
                        )
                }
                
                Button(action: {
                    crewVM.showNewAnnouncement = false
                }) {
                    ZStack{
                        
                        Circle()
                            .fill(Color(.systemGray4))
                            .frame(width: 40, height: 40)
                        Iconoir.xmark.asImage
                            .foregroundStyle(.colorWhite)
                    }
                }
              
            }.padding(16)
            .frame(width: 300, height: 400)
            
            .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.colorWhite)
            )
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
        .alert("Please choose if it is an announcement or crew-voting", isPresented: $showChooseAlert, actions: {
            
        })
    }
}

#Preview {
    NewAnnouncementView()
        .environmentObject(MainCrewViewModel(crew: Crew(id: "", admin: "", crewName: "Hello", creationDate: Timestamp(date: Date()), publicCrew: false, uids: []), landingVM: LandingCrewViewModel()))
}
