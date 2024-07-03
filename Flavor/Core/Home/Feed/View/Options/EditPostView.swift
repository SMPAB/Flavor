//
//  EditPostView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-03.
//

import SwiftUI
import Kingfisher
import Iconoir


struct EditPostView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var post: Post {
        return homeVM.editPost!
    }
    
    var body: some View {
        let width = UIScreen.main.bounds.width
        ScrollView{
            VStack(spacing: 16){
                
                HStack{
                    Button(action: {
                        dismiss()
                        homeVM.showEditPost = false
                    }){
                        Text("Cancel")
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    
                    Text("Edit flavor")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        Task{
                            try await profileVM.editPost(post, newTitle: homeVM.newTitle, newDescription: homeVM.newDescription, newUrls: homeVM.newUrls, homeVM: homeVM)
                            
                            dismiss()
                            homeVM.showEditPost = false
                            
                            homeVM.newTitle = ""
                            homeVM.newDescription = ""
                            homeVM.newUrls = []
                            
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                homeVM.editPost = nil
                            }
                        }
                        
                    }){
                        Text("Save")
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.black)
                    }
                }.padding(.horizontal, 16)
                /*HeaderMain(action: {
                    Task {
                        try await profileVM.editPost(post, newTitle: homeVM.newTitle, newDescription: homeVM.newDescription, newUrls: homeVM.newUrls)
                        
                        dismiss()
                        homeVM.showEditPost = false
                        
                        homeVM.newTitle = ""
                        homeVM.newDescription = ""
                        homeVM.newUrls = []
                        
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            homeVM.editPost = nil
                        }
                    }
                }, cancelText: "Cancel", title: "Edit flavor", actionText: "Save")
                .padding(.horizontal, 16)*/
                
                Divider()
                
                TabView{
                    ForEach(post.imageUrls!, id: \.self){ url in
                        
                        ZStack(alignment: .topTrailing){
                            KFImage(URL(string: url))
                                .resizable()
                                .scaledToFill()
                                .frame(width: width, height: width * 5/4)
                                .clipShape(Rectangle())
                                .contentShape(Rectangle())
                            
                            Button(action: {
                               if let index = post.imageUrls?.firstIndex(where: {$0 == url}){
                                   homeVM.editPost?.imageUrls?.remove(at: index)
                                }
                            }){
                                Iconoir.trashSolid.asImage
                                    .foregroundStyle(.colorWhite)
                            }.padding(8)
                        }
                        
                    }
                }.frame(height: width * 5/4)
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                VStack(spacing: 0){
                    TextField("Title here...", text: $homeVM.newTitle)
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                        
                    
                    
                    TextField("Caption here...", text: $homeVM.newDescription, axis: .vertical)
                        .font(.primaryFont(.P1))
                        
                }.padding(.horizontal, 16)
                 
                
            }
        }.onFirstAppear {
            homeVM.newUrls = post.imageUrls ?? []
            homeVM.newTitle = post.title ?? ""
            homeVM.newDescription = post.caption ?? ""
        }
        .onTapGesture{
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    EditPostView()
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}
