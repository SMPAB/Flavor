//
//  UploadStoryView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-18.
//

import SwiftUI
import Iconoir

struct UploadStoryView: View {
    @StateObject var viewModel: UploadStoryVM
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeVM: HomeViewModel
    
    @Namespace var namespace
    @State var showImage = false
    
    @State var allowSwitch = true
    
    @State var showUploadAnimation = false
    @State var finishedUploading = false
    
    @State var uploading = false
    @State var offser: CGFloat = 0.0
    init(image: FilteredImage?){
        self._viewModel = StateObject(wrappedValue: UploadStoryVM(image: image))
    }
    var body: some View {
        ZStack {
            VStack(spacing: 32){
                
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Post Story")
                        .font(.primaryFont(.H4))
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left").opacity(0)
                    
                }.padding(.horizontal, 16)
                
                
                VStack(spacing: 16){
                    if let uiImage = viewModel.image?.image{
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .matchedGeometryEffect(id: "Image", in: namespace)
                            .frame(width: 190, height: 190)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .contentShape(RoundedRectangle(cornerRadius: 32))
                            .background(
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(Color(.systemGray5))
                                    .stroke(
                                                            LinearGradient(
                                                                gradient: Gradient(colors: [.colorYellow, .colorOrange]),
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            ),
                                                            lineWidth: 7 // Adjust the width of the border as needed
                                                        )
                            )
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.5, bounce: 0.2)){
                                    if allowSwitch {
                                        showImage.toggle()
                                    }
                                   
                                }
                                
                            }
                    }
                    
                    VStack(alignment: .leading){
                        Text("Title")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        CustomTextField(text: $viewModel.title, textInfo: "Write...", secureField: false, multiRow: false, search: false)
                        
                        
                        Text("Connect challenge")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        if let challenge = viewModel.challenge {
                            HStack{
                                ImageView(size: .xsmall, imageUrl: challenge.imageUrl, background: true)
                                
                                Text(challenge.title)
                                    .font(.primaryFont(.P2))
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.challenge = nil
                                    viewModel.publicChallenge = nil
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
                        } else if let challenge = viewModel.publicChallenge {
                            HStack{
                                ImageView(size: .xsmall, imageUrl: challenge.imageUrl, background: true)
                                
                                Text(challenge.title)
                                    .font(.primaryFont(.P2))
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.challenge = nil
                                    viewModel.publicChallenge = nil
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
                                           SelectChallengeViewStory()
                                .environmentObject(viewModel)
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
                        
                        
                        Text("Add location")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        if let selectedItem = viewModel.selectedMapItem {
                            HStack{
                                
                                Text(viewModel.selectedMapItemTitle ?? "")
                                    .font(.primaryFont(.P2))
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.selectedMapItem = nil
                                    viewModel.selectedMapItemTitle = nil
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
                        }  else {
                            
                            NavigationLink(destination:
                                            SelectLocationView(selectedLocation: $viewModel.selectedMapItem, selectedLocationTitle: $viewModel.selectedMapItemTitle)
                            ){
                                HStack{
                                    Text("Add Location")
                                        .font(.primaryFont(.P2))
                                        .foregroundStyle(Color(.systemGray))
                                    
                                    Spacer()
                                    
                                    Iconoir.globe.asImage
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
                    
                    
                    
                    
                    
                    
                    
                    
                    CustomButton(text: "Publicera", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: .colorOrange, action: {
                        if !uploading{
                            Task{
                                uploading = true
                                showUploadAnimation = true
                                try await viewModel.uploadStory(user: homeVM.user, homeVM: homeVM)
                                finishedUploading = true
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
                                    showUploadAnimation = false
                                    homeVM.showCamera.toggle()
                                    uploading = false
                                }
                                
                            }
                        }
                        
                    })
                }.padding(.horizontal, 16)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                Spacer()
            }.navigationBarBackButtonHidden(true)
            
            if showImage {
                ZStack{
                    Color.black.ignoresSafeArea()
                    if let uiImage = viewModel.image?.image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: "Image", in: namespace)
                            .onTapGesture {
                                allowSwitch = false
                                withAnimation(.spring(duration: 0.5, bounce: 0.2)){
                                    showImage.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    allowSwitch = true
                                }
                            }
                            .offset(y: offser)
                            .gesture(
                                DragGesture()
                                    .onChanged { newValue in
                                        offser = newValue.translation.height/1.4
                                    }
                                    .onEnded{ value in
                                        if value.translation.height > 200 {
                                            allowSwitch = false
                                            withAnimation(.spring(duration: 0.5, bounce: 0.2)){
                                                showImage.toggle()
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                allowSwitch = true
                                            }
                                            offser = 0
                                        } else {
                                            withAnimation{
                                                offser = 0
                                            }
                                        }
                                    }
                            )
                    }
                }
                
            }
        }.uploadAnimation(isPresented: $showUploadAnimation, finished: $finishedUploading, image: nil, finishedAction: {
            
        })
    }
}

#Preview {
    UploadStoryView(image: nil)
}
