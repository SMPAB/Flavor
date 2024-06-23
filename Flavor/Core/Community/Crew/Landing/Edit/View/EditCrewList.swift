//
//  EditCrewList.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-23.
//

import SwiftUI

struct EditCrewList: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var crewVM: MainCrewViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Add users")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .opacity(0)
                }.padding(.horizontal, 16)
                
                
                LazyVStack{
                    ForEach(crewVM.allUsernames.filter({$0 != homeVM.user.userName}), id: \.self){ username in
                        EditCrewUserCell(username: username)
                            .padding(.horizontal, 16)
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EditCrewList()
}
