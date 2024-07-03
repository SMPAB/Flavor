//
//  MainAlbumView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import SwiftUI
import Firebase
import Iconoir
import Kingfisher

struct MainAlbumView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    private var profileVM: ProfileViewModel
    @StateObject var viewModel: MainAlbumViewModel
    @Environment(\.dismiss) var dismiss
    @State var showEdit = false
    
    init(album: Album, profileVM: ProfileViewModel){
        self._viewModel = StateObject(wrappedValue: MainAlbumViewModel(album: album, profileVM: profileVM))
        self.profileVM = profileVM
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 16){
                
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    if viewModel.album.ownerUid == Auth.auth().currentUser?.uid{
                        Button(action: {
                            showEdit.toggle()
                        }){
                            Iconoir.settings.asImage
                                .foregroundStyle(.black)
                        }
                    }
                   
                }.padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color(.systemGray))
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                
                HStack{
                    
                    Spacer()
                    VStack{
                        Text(viewModel.album.title)
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        
                        Text("\(viewModel.album.uploadIds.count) flavors")
                            .font(.primaryFont(.P1))
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    Spacer()
                    
                    if let imageUrl = viewModel.album.imageUrl {
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                    }
                }.padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color(.systemGray))
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                /*LazyVStack{
                    GridView(posts: $viewModel.posts, variableTitle: viewModel.album.title, variableSubtitle: nil, navigateFromMain: false)
                    
                    VStack{
                        Text("")
                            .padding(.top, 120)
                    }.onAppear{
                        print("DEBUG APP LOADER APPEAR")
                        Task{
                            try await viewModel.fetchAlbumPosts()
                        }
                        
                    }
                }*/
                
                LazyVStack{
                    TestGrid(posts: viewModel.album.uploadIds, variableTitle: viewModel.album.title, variableSubtitle: profileVM.user.userName)
                        .environmentObject(homeVM)
                        .environmentObject(profileVM)
                        .padding(.bottom)
                }
            }.navigationBarBackButtonHidden(true)
            
            .onFirstAppear {
                profileVM.albumPosts = []
                Task{
                   //try await viewModel.fetchAlbumPosts()
                }
        }
            .fullScreenCover(isPresented: $showEdit){
                EditAlbumView(albumVM: viewModel)
            }
            
        }
    }
}

#Preview {
    MainAlbumView(album: Album(id: "", ownerUid: "", timestamp: Timestamp(date: Date()), title: "Hello", uploadIds: ["", ""]), profileVM: ProfileViewModel(user: User.mockUsers[0]))
}

