//
//  SavedView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI
import Kingfisher

struct SavedView: View {
    
    private let gridItems: [GridItem] = [
    
        .init(.flexible(), spacing: 8),
        .init(.flexible(), spacing: 8),
        .init(.flexible(), spacing: 8),
    ]
    
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        LazyVStack{
            
            Text("Posts")
                .font(.primaryFont(.P1))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            
            LazyVGrid(columns: gridItems, spacing: 8){
                ForEach(viewModel.savedPosts){ post in
                    
                    ZStack{
                        if let imageUrl = post.imageUrls{
                            KFImage(URL(string: imageUrl[0]))
                                .resizable()
                                .scaledToFill()
                                .frame(width: (width - 48)/3, height: (width - 48)/3 )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .contentShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(height: (width - 48)/3 )
                        }
                    }.onFirstAppear {
                        if post.id == viewModel.savedPosts.last?.id{
                            Task{
                                try await viewModel.fetchSavedPosts()
                            }
                        }
                    }
                    .onTapGesture{
                        homeVM.selectedVariableUploadId = post.id
                        homeVM.variableUplaods = viewModel.savedPosts
                        homeVM.variablesTitle = "Saved Posts"
                        homeVM.showVariableView = true
                    }
                    
                    
                }
                
                if viewModel.fetchingSavedPosts{
                    Loading()
                }
            }.padding(.horizontal, 16)
            
            Rectangle()
                .foregroundStyle(Color(.systemGray))
                .frame(height: 1)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            
            Text("Recipes")
                .font(.primaryFont(.P1))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            
            
            LazyVGrid(columns: gridItems, spacing: 8){
                ForEach(viewModel.savedRecipes){ recipe in
                    NavigationLink(destination: 
                                    MainRecipeView(recipeId: recipe.id)
                        .navigationBarBackButtonHidden(true)
                    ){
                        ZStack{
                            if let imageUrl = recipe.imageUrl{
                                KFImage(URL(string: imageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (width - 48)/3, height: (width - 48)/3 )
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .contentShape(RoundedRectangle(cornerRadius: 16))
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(height: (width - 48)/3 )
                            }
                        }.onFirstAppear {
                            if recipe.id == viewModel.savedRecipes.last?.id{
                                Task{
                                    try await viewModel.fetchSavedRecipes()
                                }
                            }
                        }
                    }
                    
                    
                    
                }
                
                if viewModel.fetchingSavedRecipes{
                    Loading()
                }
            }.padding(.horizontal, 16)
        }.onFirstAppear {
            Task{
                try await viewModel.fetchSavedPosts()
                
            }
            
            Task{
                try await viewModel.fetchSavedRecipes()
            }
        }
    }
}

#Preview {
    SavedView()
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
