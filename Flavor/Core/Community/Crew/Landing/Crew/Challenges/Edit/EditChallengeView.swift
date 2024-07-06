//
//  EditChallengeView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-30.
//

import SwiftUI

struct EditChallengeView: View {
    @EnvironmentObject var viewModel: ChallengeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var showImagePicker = false
    var body: some View {
        ZStack {
            VStack(spacing: 32){
                HeaderMain(action: {
                    Task{
                        try await viewModel.saveChanges()
                        dismiss()
                        
                    }
                }, cancelText: "Cancel", title: "Edit Challenge", actionText: "Save")
                
                VStack(alignment: .leading, spacing: 16){
                    Text("Challenge Image")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    if let image = viewModel.uiImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 72, height: 72)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        ImageView(size: .medium, imageUrl: viewModel.challenge.imageUrl, background: false)
                    }
                    
                    Text("Name")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    CustomTextField(text: $viewModel.newName, textInfo: "Name here...", secureField: false, multiRow: false, search: false)
                    
                    Text("Description")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    CustomTextField(text: $viewModel.newDescription, textInfo: "Descritpion here...", secureField: false, multiRow: false, search: false)
                    
                    
                    DatePicker(selection: $viewModel.newStart){
                        Text("Date-From")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                    }.onTapGesture(count: 99, perform: {
                        // overrides tap gesture to fix ios 17.1 bug
                    })
                    
                    DatePicker(selection: $viewModel.newEnd){
                        Text("Date-Too")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                    }.onTapGesture(count: 99, perform: {
                        // overrides tap gesture to fix ios 17.1 bug
                    })
                }
              Spacer()
            }.padding(.horizontal, 16)
            
           
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    EditChallengeView()
}
