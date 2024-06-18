//
//  UploadStoryView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-18.
//

import SwiftUI

struct UploadStoryView: View {
    @StateObject var viewModel: UploadStoryVM
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State var uploading = false
    init(image: FilteredImage?){
        self._viewModel = StateObject(wrappedValue: UploadStoryVM(image: image))
    }
    var body: some View {
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
                }
                
                VStack(alignment: .leading){
                    Text("Title")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                    
                    CustomTextField(text: $viewModel.title, textInfo: "Write...", secureField: false, multiRow: false)
                }
                
                
                CustomButton(text: "Publicera", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: .colorOrange, action: {
                    if !uploading{
                        Task{
                            uploading = true
                            try await viewModel.uploadStory(user: homeVM.user)
                            homeVM.showCamera.toggle()
                            uploading = false
                        }
                    }
                    
                })
            }.padding(.horizontal, 16)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            Spacer()
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    UploadStoryView(image: nil)
}
