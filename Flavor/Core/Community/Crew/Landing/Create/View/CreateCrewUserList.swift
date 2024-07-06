//
//  CreateCrewUserList.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import SwiftUI

struct CreateCrewUserList: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: CreateCrewVM
    
    
    @State var searchText = ""
    
    private var filteredUserNames: [String] {
            let lowercasedSearchText = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            return viewModel.allUserNames
                .filter { $0 != viewModel.currentUser.userName }
                .filter { lowercasedSearchText.isEmpty || $0.lowercased().contains(lowercasedSearchText) }
        }
    
    var body: some View {
        ScrollView{
            LazyVStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Add crew-mates")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .opacity(0)
                }.padding(.horizontal, 16)
                
                
                CustomTextField(text: $searchText, textInfo: "Search...", secureField: false, multiRow: false, search: false)
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color(.systemGray))
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                LazyVStack{
                    ForEach(filteredUserNames, id: \.self){ userName in
                       CreateCrewCell(userName: userName)
                            .environmentObject(viewModel)
                            .padding(.horizontal, 16)
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CreateCrewUserList()
        .environmentObject(CreateCrewVM(currentUser: User.mockUsers[0], landingVM: LandingCrewViewModel()))
}
