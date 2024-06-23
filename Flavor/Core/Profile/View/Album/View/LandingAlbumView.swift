//
//  LandingAlbumView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-15.
//

import SwiftUI
import Firebase
import Iconoir
import Kingfisher

struct LandingAlbumView: View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    private let gridItems: [GridItem] = [
    
        .init(.flexible(), spacing: 8),
        .init(.flexible(), spacing: 8),
    ]
    
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        VStack{
            if viewModel.user.id == Auth.auth().currentUser?.uid {
                
                Button(action: {
                    viewModel.showCreateAlbum.toggle()
                }){
                    HStack{
                        Text("Create Album")
                            .font(.primaryFont(.P1))
                        
                        Iconoir.plus.asImage
                    }.foregroundStyle(Color(.systemGray))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundStyle(Color(.systemGray))
                        )
                }.padding(.horizontal, 16)
                
            }
            
            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.albums.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})) { album in
                    
                    NavigationLink(destination: {
                        MainAlbumView(album: album, profileVM: viewModel)
                            .environmentObject(homeVM)
                           
                    }){
                        ZStack(alignment: .topLeading){
                            if let imageurl = album.imageUrl{
                                KFImage(URL(string: imageurl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (width - 40)/2, height: (width - 40)/2)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .contentShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear.opacity(0.5)]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    )
                                    
                            }  else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray6))
                                    .frame(width: (width - 40)/2, height: (width - 40)/2)
                            }
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text(album.title)
                                    .font(.primaryFont(.P1))
                                    .foregroundStyle(.colorWhite)
                                    .fontWeight(.semibold)
                                
                                Text("\(album.uploadIds.count) flavors")
                                    .font(.primaryFont(.P2))
                                    .foregroundStyle(.colorWhite)
                            }
                            
                                .padding(8)
                        }
                        
                    }
                   
                    
                    
                    
                }
                
                if viewModel.loadingAlbums {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: (width - 40)/2, height: (width - 40)/2)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: (width - 40)/2, height: (width - 40)/2)
                }
            }.padding(.horizontal, 16)
            
            if !viewModel.user.isCurrentUser && viewModel.albums.isEmpty && !viewModel.loadingAlbums && viewModel.hasLoadedAlbum{
                VStack {
                    Image(.noAlbum)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width - 32, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    .contentShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("Oh no, looks like this profile have not created any albums yet...")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(Color(.systemGray))
                        .multilineTextAlignment(.center)
                }
            }
        }.onFirstAppear {
            Task{
                try await viewModel.fetchAlbums()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showCreateAlbum){
            CreateAlbumView(user: viewModel.user, profileVM: viewModel)
        }
    }
}

#Preview {
    LandingAlbumView()
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}
