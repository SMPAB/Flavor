//
//  SelectChallengeViewStory.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-30.
//

import SwiftUI
import Firebase

struct SelectChallengeViewStory: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: UploadStoryVM
    
    var body: some View {
        ScrollView {
            LazyVStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Select challenge")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .opacity(0)
                    
                }.padding(.horizontal, 16)
                
                ForEach(viewModel.allChallenges.filter({!$0.completedUsers.contains(Auth.auth().currentUser?.uid ?? "")})){ challenge in
                    Button(action: {
                        viewModel.challenge = challenge
                        dismiss()
                    }) {
                        HStack{
                            ImageView(size: .small, imageUrl: challenge.imageUrl, background: true)

                            VStack(alignment: .leading){
                                Text(challenge.title)
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                                
                                Text(challenge.crew?.crewName ?? "")
                                    .font(.primaryFont(.P2))
                                    .foregroundStyle(Color(.systemGray))
                            }
                            
                            Spacer()
                        }.padding(.horizontal, 16)
                            .foregroundStyle(.black)
                    }
                }
            }
        }.onFirstAppear {
            Task{
                try await viewModel.fetchAllChallenges()
            }
        }
    }
}

#Preview {
    SelectChallengeViewStory()
}
