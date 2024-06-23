//
//  EditCrewView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-23.
//

import SwiftUI
import Firebase
import Iconoir

struct EditCrewView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var crewVM: MainCrewViewModel
    @Environment(\.dismiss) var dismiss
    @State var showImagePickerOptions = false
    @State var updating = false
    
    var crew: Crew {
        return crewVM.crew
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView{
                    VStack(spacing: 32){
                        HeaderMain(action: {
                            Task{
                                if !updating{
                                    updating = true
                                    try await crewVM.saveEditCrew()
                                    dismiss()
                                    updating = false
                                }
                            }
                        }, cancelText: "Cancel", title: "Edit crew", actionText: "Save")
                        .padding(.horizontal, 16)
                        
                        
                        VStack(spacing: 16){
                            
                            VStack(alignment: .leading, spacing: 8){
                                
                                Text("Crew image")
                                    .font(.primaryFont(.P1))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fontWeight(.semibold)
                                //IMAGE
                                if let uiImage = crewVM.uiImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 96, height: 96)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .contentShape(RoundedRectangle(cornerRadius: 8))
                                        .onTapGesture {
                                            showImagePickerOptions.toggle()
                                        }
                                } else {
                                    ImageView(size: .large, imageUrl: crew.imageUrl, background: false)
                                        .onTapGesture {
                                            showImagePickerOptions.toggle()
                                        }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("Crew-name")
                                    .font(.primaryFont(.P1))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fontWeight(.semibold)
                                
                                CustomTextField(text: $crewVM.name, textInfo: "your name", secureField: false, multiRow: false)
                            }
                            
                            Rectangle()
                                .fill(Color(.systemGray))
                                .frame(height: 1)
                            
                            
                            LazyVStack(alignment: .leading){
                                Text("Crew-mates")
                                    .font(.primaryFont(.P1))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fontWeight(.semibold)
                                
                                NavigationLink(destination:
                                               EditCrewList()
                                    .environmentObject(crewVM)
                                    .environmentObject(homeVM)
                                ) {
                                    HStack{
                                        Iconoir.plus.asImage
                                            .foregroundStyle(Color(.systemGray))
                                            .frame(width: 48, height: 48)
                                            .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.clear)
                                                .stroke(Color(.systemGray))
                                            )
                                        
                                        Text("Add crew mates")
                                            .font(.primaryFont(.P1))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                        
                                        Spacer()
                                    }
                                }
                                
                                if let user = crewVM.selectedUser.first(where: {$0.id == Auth.auth().currentUser?.uid}){
                                    HStack{
                                        ImageView(size: .small, imageUrl: user.profileImageUrl, background: true)
                                        
                                        Text("@\(user.userName)")
                                            .font(.primaryFont(.P1))
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                      
                                            Text("admin")
                                                .font(.primaryFont(.P2))
                                                .foregroundStyle(Color(.systemGray))
                                                .frame(width: 84, height: 32)
                                                
                                        
                                       
                                    }
                                }
                                ForEach(crewVM.selectedUser.filter({$0.id != Auth.auth().currentUser?.uid})){ user in
                                    HStack{
                                        ImageView(size: .small, imageUrl: user.profileImageUrl, background: true)
                                        
                                        Text("@\(user.userName)")
                                            .font(.primaryFont(.P1))
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            crewVM.selectedUser.removeAll(where: {$0.id == user.id})
                                        }){
                                            Text("remove")
                                                .font(.primaryFont(.P2))
                                                .foregroundStyle(Color(.colorWhite))
                                                .frame(width: 84, height: 32)
                                                .background(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color(.systemRed))
                                                )
                                        }
                                       
                                    }
                                }
                            }
                            
                            //CREW NAME
                        }.padding(.horizontal, 16)
                    }
                }
                
                if showImagePickerOptions{
                    ImagePickerOptions(image: $crewVM.image, uiimage: $crewVM.uiImage, showView: $showImagePickerOptions, imageType: .groupImage)
                }
               
            }.onFirstAppear {
                Task{
                    try await crewVM.fetchUsersInCrew()
                }
                
                Task{
                    try await crewVM.fetchAllUsers()
                }
        }
        }
    }
}

#Preview {
    EditCrewView()
        .environmentObject(MainCrewViewModel(crew: Crew(id: "", admin: "", crewName: "Helo", creationDate: Timestamp(date: Date()), publicCrew: false, uids: [])))
}
