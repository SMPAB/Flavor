//
//  CreateCrewView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import SwiftUI
import Iconoir
import Kingfisher

struct CreateCrewView: View {
    
    @StateObject var viewModel: CreateCrewVM
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State var creatingCrew = false
    @Environment(\.dismiss) var dismiss
    
    
    
    init(currentUser: User, landingVM: LandingCrewViewModel){
        self._viewModel = StateObject(wrappedValue: CreateCrewVM(currentUser: currentUser, landingVM: landingVM))
    }
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView{
                    VStack(spacing: 32){
                        HeaderMain(action: {
                            if !creatingCrew{
                                Task {
                                    creatingCrew = true
                                    try await viewModel.uploadCrewToCollection()
                                    dismiss()
                                    creatingCrew = false
                                
                                }
                            }
                        }, cancelText: "Cancel", title: "Create crew", actionText: "Create")
                        .padding(.horizontal, 16)
                        
                        
                        VStack(alignment: .leading, spacing: 16){
                            VStack(alignment: .leading, spacing: 4){
                                Text("Lets get your friends together!")
                                    .font(.primaryFont(.H4))
                                    .fontWeight(.semibold)
                                
                                Text("create a crew with you closest friends and comptete in exiting challenges")
                                    .font(.primaryFont(.P2))
                                    .foregroundStyle(Color(.systemGray))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 16)
                            
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("Choose crew-image")
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                                    
                                
                                if let image = viewModel.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .contentShape(RoundedRectangle(cornerRadius: 8))
                                        .onTapGesture {
                                            viewModel.showImagePicker.toggle()
                                        }
                                    
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray6))
                                        .frame(width: 100, height: 100)
                                        .onTapGesture {
                                            viewModel.showImagePicker.toggle()
                                        }
            
                                }
                            }.padding(.horizontal, 16)
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("Crew-name")
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                
                                CustomTextField(text: $viewModel.crewName, textInfo: "Name here...", secureField: false, multiRow: false)
                                    .padding(.horizontal, 16)
                            }
                            
                            Rectangle()
                                .fill(Color(.systemGray))
                                .frame(height: 1)
                                .padding(.horizontal, 16)
                            
                            LazyVStack(alignment: .leading){
                                Text("Add crew-mates")
                                    .font(.primaryFont(.H4))
                                    .fontWeight(.semibold)
                                
                                NavigationLink(destination: 
                                               CreateCrewUserList()
                                    .environmentObject(viewModel)
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
                                
                                
                                HStack{
                                    ImageView(size: .small, imageUrl: homeVM.user.profileImageUrl, background: true)
                                    
                                    Text("@\(homeVM.user.userName)")
                                        .font(.primaryFont(.P1))
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                    
                                    Text("admin")
                                        .font(.primaryFont(.P2))
                                        .frame(width: 84, height: 32)
                                        .foregroundStyle(Color(.systemGray))
                                }
                                
                                ForEach(viewModel.selectedUsers){ user in
                                    HStack{
                                        ImageView(size: .small, imageUrl: user.profileImageUrl, background: true)
                                        
                                        Text("@\(user.userName)")
                                            .font(.primaryFont(.P1))
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            viewModel.selectedUsers.removeAll(where: {$0.id == user.id})
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
                            }.padding(.horizontal, 16)
                            
                        }
                    }
         
                }
                
                if viewModel.showImagePicker{
                    ImagePickerOptions(image: $viewModel.image, uiimage: $viewModel.uiImage, showView: $viewModel.showImagePicker, imageType: .groupImage)
                }
                
            }.onFirstAppear {
                Task{
                    try await viewModel.fetchAllUsernames()
                }
            }
        }
    }
}

#Preview {
    CreateCrewView(currentUser: User.mockUsers[0], landingVM: LandingCrewViewModel())
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
