//
//  MainSearchView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import SwiftUI
import Firebase

struct MainSearchView: View {
    
    @StateObject var viewModel = MainSearchViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        ScrollView{
            VStack(spacing: 32){
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Image(.logoFullBlack)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 88, height: 24)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .opacity(0)
                    
                }.padding(.horizontal, 16)
                
                CustomTextField(text: $viewModel.searchText, textInfo: "Search...", secureField: false, multiRow: false)
                .padding(.horizontal, 16)
                
                if !viewModel.searchText.isEmpty{
                    LazyVStack{
                        ForEach(filteredUsernames.filter({$0 != homeVM.user.userName}), id: \.self){ username in
                            SearchCell(username: username)
                                .environmentObject(homeVM)
                        }
                    }.padding(.horizontal)
                } else {
                    EmptySearchView()
                        .environmentObject(viewModel)
                        .onFirstAppear {
                            Task{
                               try await  viewModel.fetchRecomendedPosts()
                            }
                            
                            Task{
                               try await viewModel.fetchTrendingPosts()
                            }
                        }
                }
                
            }
        }.onFirstAppear {
            Task{
                try await viewModel.fetchUsersnames()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var filteredUsernames: [String] {
            let searchText = viewModel.searchText.lowercased()
            let currentUserName = homeVM.user.userName
            
            // Filter usernames based on search text and remove current user's username
            var filtered = viewModel.usernames.filter {
                $0.lowercased().contains(searchText) && $0 != currentUserName
            }
            
            // Add the current user's username at the beginning if it matches the search text
            if currentUserName.lowercased().contains(searchText) {
                filtered.insert(currentUserName, at: 0)
            }
            
            return filtered
        }
}

#Preview {
    MainSearchView()
}
