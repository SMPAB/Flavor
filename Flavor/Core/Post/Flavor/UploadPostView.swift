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
                
                CustomTextField(text: $viewMdeol.title, textInfo: "Write here...", secureField: false, multiRow: false)
                
                Text("Caption")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                CustomTextField(text: $viewMdeol.caption, textInfo: "Write here...", secureField: false, multiRow: true)
                
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
                            )
                            
                    }
                } else {
                    
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
                    try await viewMdeol.uploadFlavorPostViewModel(images: images, user: homeVM.user)
                    homeVM.showCamera.toggle()
                }
            }).padding(.horizontal, 16)
        }.navigationBarBackButtonHidden(true)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}
/*
#Preview {
    UploadPostView()
}*/
