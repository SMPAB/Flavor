//
//  LandingNotificationView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI

struct LandingNotificationView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false){
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Notifications")
                        .font(.primaryFont(.H4))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image("chevron.left")
                        .opacity(0)
                }.padding(.horizontal, 16)
                
                VStack{
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(height: 1)
                    
                    NavigationLink(destination: 
                                    MainFriendRequestView()
                        .environmentObject(homeVM)
                        .navigationBarBackButtonHidden(true)
                    ){
                            HStack{
                                Text("Friend Requests")
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                
                                + Text("(\(homeVM.friendRequestUsernames.count))")
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.black)
                            }
                        }
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(height: 1)
                }.padding(.horizontal, 16)
                
                
                LazyVStack{
                  /*  Text("Notifications")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)*/
                    
                    NotificationView()
                        .environmentObject(homeVM)
                }
                
            }
        }
    }
}

#Preview {
    LandingNotificationView()
}
