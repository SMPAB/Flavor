//
//  CreateChallengeView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-28.
//

import SwiftUI
import Firebase

struct CreateChallengeView: View {
    
    @EnvironmentObject var viewModel: MainCrewViewModel
    @Environment(\.dismiss) var dismiss
    @State var showImagepicker = false
    @State var creatingChallenge = false
    
    @State var date = Date()
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 32){
                    HStack{
                        Button(action: {
                            dismiss()
                        }){
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                        }
                        
                        Spacer()
                        
                        Text("Create Challenge")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.left").opacity(0)
                    }.padding(.horizontal, 16)
                    
                    
                    VStack(alignment: .leading, spacing: 16){
                        
                        VStack(alignment: .leading, spacing: 4){
                            Text("Create your challenge")
                                .font(.primaryFont(.H4))
                                .fontWeight(.semibold)
                            
                            
                            Text("Create a memorable competition between you and your friends")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(.systemGray))
                        }
                       
                        
                        
                        Text("Choose challenge-image")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        if let image = viewModel.challengeUiImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 72, height: 72)
                                .contentShape(RoundedRectangle(cornerRadius: 8))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture {
                                    showImagepicker.toggle()
                                }
                        } else {
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                                .frame(width: 72, height: 72)
                                .onTapGesture {
                                showImagepicker.toggle()
                            }
                        }
                        
                        Text("Name")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        CustomTextField(text: $viewModel.challengeTitle, textInfo: "Name here...", secureField: false, multiRow: false)
                        
                        Text("Description")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        CustomTextField(text: $viewModel.challengeDescription, textInfo: "Description here...", secureField: false, multiRow: false)
                        
                        DatePicker(selection: $viewModel.challengeStart){
                            Text("Date-From")
                                .font(.primaryFont(.H4))
                                .fontWeight(.semibold)
                        }.onTapGesture(count: 99, perform: {
                            // overrides tap gesture to fix ios 17.1 bug
                        })
                        
                        DatePicker(selection: $viewModel.challengeEnd){
                            Text("Date-Too")
                                .font(.primaryFont(.H4))
                                .fontWeight(.semibold)
                        }.onTapGesture(count: 99, perform: {
                            // overrides tap gesture to fix ios 17.1 bug
                        })
                        
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color(.systemGray))
                        
                        CustomButton(text: "Create Challenge", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: .colorOrange, action: {
                            if viewModel.challengeStart < viewModel.challengeEnd && !creatingChallenge {
                                Task {
                                    creatingChallenge = true
                                    try await viewModel.createChallenge()
                                    dismiss()
                                    creatingChallenge = false
                                }
                            }
                        })
                    }.padding(.horizontal, 16)
                    
                    
                    
                }
            }
            
            if showImagepicker {
                ImagePickerOptions(image: $viewModel.challengeImage, uiimage: $viewModel.challengeUiImage, showView: $showImagepicker, imageType: .albumImage)
            }
            
            
            
            
            
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
/*
#Preview {
    CreateChallengeView()
        .environmentObject(MainCrewViewModel(crew: Crew(id: "", admin: "", crewName: "", creationDate: Timestamp(date: Date()), publicCrew: true, uids: [])))
}*/
