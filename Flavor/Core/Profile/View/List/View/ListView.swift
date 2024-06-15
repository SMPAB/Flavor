//
//  ListView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI
import Iconoir

struct ListView: View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var followers: Bool
    @Binding var following: Bool
    
    @State var localFollowers = true
    @State var localFollowing = false
    
    @State var searchText = ""
    
    var filteredFollowers: [String] {
            if searchText.isEmpty {
                return viewModel.userFollowers
            } else {
                return viewModel.userFollowers.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        }
        
        var filteredFollowing: [String] {
            if searchText.isEmpty {
                return viewModel.userFollowing
            } else {
                return viewModel.userFollowing.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        }
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        ScrollView{
            HStack{
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }.padding(.horizontal, 16)
            
            HStack{
                
                Spacer()
                
                Text("@\(viewModel.user.userName)")
                    .font(.primaryFont(.H3))
                    .fontWeight(.semibold)
                
                Spacer()
                
            }.padding(.horizontal, 16)
            
            
            HStack{
                Text("Followers")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                    .frame(width: 153)
                    .opacity(localFollowers ? 1 : 0.6)
                    .onTapGesture {
                        withAnimation{
                            localFollowing = false
                            localFollowers = true
                        }
                        
                    }
                
                Spacer()
                
                Text("Following")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                    .frame(width: 153)
                    .opacity(localFollowing ? 1 : 0.6)
                    .onTapGesture {
                        withAnimation{
                            localFollowing = true
                            localFollowers = false
                            //width/2 - 153/2 + -16 :  -(width/2 - 153/2 + -16)
                        }
                        
                    }
            }.padding(.horizontal, 16)
                .padding(.top, 16)
            
            RoundedRectangle(cornerRadius: 1)
                .fill(.black)
                .frame(width: 153, height: 2)
                .offset(x: localFollowers ?  -(width/2 - 76.5 + -16) : (width/2 - 76.5 + -16))
                
                
            
            
            HStack{
                
                Iconoir.search.asImage
                    .foregroundStyle(.colorOrange)
                
                TextField("Search for users...", text: $searchText)
                    .font(.primaryFont(.P1))
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 37)
                
            }.padding(.horizontal, 8)
            .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.colorWhite)
                .stroke(Color(.systemGray))
            )
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            Rectangle()
                .fill(Color(.systemGray))
                .frame(height: 1)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
            
            if localFollowers {
                LazyVStack{
                    ForEach(filteredFollowers, id: \.self){ username in
                        ListCell(username: username)
                            .foregroundStyle(.black)
                            .environmentObject(viewModel)
                            .environmentObject(homeVM)
                            .padding(.horizontal, 16)
                    }
                }
            }
            if localFollowing {
                LazyVStack{
                    ForEach(filteredFollowing, id: \.self){ username in
                        ListCell(username: username)
                            .foregroundStyle(.black)
                            .environmentObject(viewModel)
                            .environmentObject(homeVM)
                            .padding(.horizontal, 16)
                    }
                }
            }
        }.onFirstAppear {
            localFollowers = followers
            localFollowing = following
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationBarBackButtonHidden(true)
    }
}
/*
#Preview {
    ListView()
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}*/
