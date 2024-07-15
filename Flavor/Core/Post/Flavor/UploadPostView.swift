//
//  UploadPostView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI
import Iconoir

struct UploadPostView: View {
    
    @Binding var images: [UIImage]
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeVM: HomeViewModel
    @StateObject var viewMdeol = UploadFlavorPostViewModel()
    @State var removeRecipeAlert = false
    
    
    @Binding var showOption: Bool
    
    var body: some View {
        ScrollView{
            HStack{
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                Text("Upload post")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.left").opacity(0)
            }.padding(.horizontal, 16)
            
            VStack(alignment: .leading){
                Text("Add your cover-image:")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                Text("This image will be portrayed larger as the cover of this post")
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
                
                if let firstImage = images.first {
                    Image(uiImage: firstImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 128, height: 128)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Text("Add other images:")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                Text("Images will be shown in smaller format than cover-image")
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
                
               
                
            }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
                .padding(.top, 16)
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(images.dropFirst().indices, id: \.self){ index in
                        let image = images[index]
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button(action: {
                        dismiss()
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.clear)
                                
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .frame(width: 80, height: 80)
                                .foregroundStyle(Color(.systemGray))
                            Iconoir.plus.asImage
                                .foregroundStyle(.black)
                                .foregroundStyle(Color(.systemGray))
                            
                        }
                    }
                    
                }.padding(.horizontal, 16)
            }
            
            
            VStack(alignment: .leading){
                Text("Title:")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                CustomTextField(text: $viewMdeol.title, textInfo: "Write here...", secureField: false, multiRow: false, search: false)
                
                Text("Caption")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                CustomTextField(text: $viewMdeol.caption, textInfo: "Write here...", secureField: false, multiRow: true, search: false)
                
                Text("Recipe")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                if !viewMdeol.recipe{
                    NavigationLink(destination:
                                    CreateRecipeView()
                        .environmentObject(viewMdeol)
                        .navigationBarBackButtonHidden(true)
                    ){
                        Text("Add recipe+")
                            .frame(maxWidth: .infinity)
                            .frame(height: 37)
                            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.clear)
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundStyle(.black)
                            )
                            .foregroundStyle(.black)
                            
                    }
                } else {
                    NavigationLink(destination:
                                    CreateRecipeView()
                        .environmentObject(viewMdeol)
                        .navigationBarBackButtonHidden(true)
                    ){
                        
                        HStack{
                            
                            Button(action: {
                                removeRecipeAlert.toggle()
                            }){
                                Iconoir.trash.asImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(Color(.systemRed))
                            }
                            Spacer()
                            
                            Text("Edit Recipe")
                                .frame(maxWidth: .infinity)
                                .frame(height: 37)
                                .foregroundStyle(.colorOrange)
                                
                            
                            Spacer()
                            
                            Iconoir.trash.asImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(Color(.colorOrange))
                                .opacity(0)
                        }.padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.clear)
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundStyle(.colorOrange)
                            )
                        
                            
                    }
                }
                
                
                Text("Connect challenge")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                if let challenge = viewMdeol.challenge {
                    HStack{
                        ImageView(size: .xsmall, imageUrl: challenge.imageUrl, background: true)
                        
                        Text(challenge.title)
                            .font(.primaryFont(.P2))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {
                            viewMdeol.challenge = nil
                            viewMdeol.publicChallenge = nil
                        }){
                            Iconoir.trash.asImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.colorOrange)
                        }
                    }.padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                            .stroke(Color(.systemGray))
                        )
                } else if let challenge = viewMdeol.publicChallenge {
                    HStack{
                        ImageView(size: .xsmall, imageUrl: challenge.imageUrl, background: true)
                        
                        Text(challenge.title)
                            .font(.primaryFont(.P2))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {
                            viewMdeol.challenge = nil
                            viewMdeol.publicChallenge = nil
                        }){
                            Iconoir.trash.asImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.colorOrange)
                        }
                    }.padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                            .stroke(Color(.systemGray))
                        )
                } else {
                    
                    NavigationLink(destination: 
                                   SelectChallengeView()
                        .environmentObject(viewMdeol)
                        .environmentObject(homeVM)
                        .navigationBarBackButtonHidden(true)
                    ){
                        HStack{
                            Text("Add challenge")
                                .font(.primaryFont(.P2))
                                .foregroundStyle(Color(.systemGray))
                            
                            Spacer()
                            
                            Iconoir.search.asImage
                                .foregroundStyle(Color(.systemGray))
                        }.padding(.horizontal, 8)
                        .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.clear)
                                .stroke(Color(.systemGray))
                            )
                    }
                    
                }
            }
            .padding(.horizontal, 16)
            
            
            Rectangle()
                .fill(Color(.systemGray))
                .frame(height: 1)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            CustomButton(text: "Publish", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: .colorOrange, action: {
                Task{
                    viewMdeol.showUploadAnimation = true
                    try await viewMdeol.uploadFlavorPostViewModel(images: images, user: homeVM.user, homeVM: homeVM)
                    viewMdeol.finishedUploading = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
                        viewMdeol.showUploadAnimation = false
                        homeVM.showCamera.toggle()
                    }
                }
            }).padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .customAlert(isPresented: $removeRecipeAlert, message: "Are you sure you want to delete your recipe?", confirmAction: {
                viewMdeol.recipe = false
                viewMdeol.recipeTime = nil
                viewMdeol.recipeDiff = nil
                viewMdeol.recipeServings = nil
                viewMdeol.recipeSteps = []
                viewMdeol.recipeIng = []
                viewMdeol.recipeUtt = []
            }, cancelAction: {
                removeRecipeAlert.toggle()
            }, dismissText: "Cancel", acceptText: "Remove")
            .uploadAnimation(isPresented: $viewMdeol.showUploadAnimation, finished: $viewMdeol.finishedUploading, image: nil, finishedAction: {
                
            })
    }
}
/*
#Preview {
    UploadPostView()
}*/
