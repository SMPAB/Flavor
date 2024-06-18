//
//  ProfileOptionsSheet.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import SwiftUI

struct ProfileOptionsSheet: View {
    
    @State var offset = UIScreen.main.bounds.height/3
    @EnvironmentObject var profileVM: ProfileViewModel
    var body: some View {
        ZStack(){
            Color.black.opacity(0.4)
                .onTapGesture {
                    withAnimation{
                        offset = UIScreen.main.bounds.height/3
                        profileVM.showOptions.toggle()
                    }
                }
            
            VStack{
                //Options
                
                //Cancle
                
                Spacer()
                
                VStack(spacing: 0){
                    
                    Button(action: {
                        withAnimation{
                            offset = UIScreen.main.bounds.height/3
                            profileVM.showOptions.toggle()
                            profileVM.showBlock.toggle()
                        }
                       
                    }){
                        Text("Block")
                            .font(.primaryFont(.P1))
                            .foregroundStyle(Color(.systemRed))
                            .frame(maxWidth: .infinity)
                            .frame(height: 53)
                    }
                    
                    
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(height: 1)
                    
                    Button(action: {
                        withAnimation{
                            offset = UIScreen.main.bounds.height/3
                            profileVM.showOptions.toggle()
                            profileVM.showReport.toggle()
                        }
                    }){
                        Text("Report")
                            .font(.primaryFont(.P1))
                            .foregroundStyle(Color(.systemRed))
                            .frame(maxWidth: .infinity)
                            .frame(height: 53)
                    }
                }.background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.colorWhite)
                    )
                
               
                
                Button(action: {
                    withAnimation{
                        offset = UIScreen.main.bounds.height/3
                        profileVM.showOptions.toggle()
                        
                    }
                }){
                    Text("Cancel")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(.black)
                        .frame(height: 53)
                        .frame(maxWidth: .infinity)
                        .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.colorWhite)
                        )
                }
            }.padding(.horizontal, 16)
                .padding(.bottom, 40)
                .offset(y: offset)
        }.ignoresSafeArea(.all)
            .onAppear{
                withAnimation{
                    offset = 0
                }
            }
    }
}

#Preview {
    ProfileOptionsSheet()
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}
