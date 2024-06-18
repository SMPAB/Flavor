//
//  NotificationCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI


import SwiftUI
import Firebase
import Kingfisher

struct NotificationCell: View {
    
   // let notification: Notification
    
    @StateObject var viewModel: NotificationcellViewModel
    
    init(notification: Notification){
        self._viewModel = StateObject(wrappedValue: NotificationcellViewModel(notification: notification))
    }
    
    var notification: Notification{
        return viewModel.notification
    }
    var body: some View {
        HStack(){
            
            //MARK: PROFILIMAGE
            if notification.users?.count == 1{
                ImageView(size: .xsmall, imageUrl: notification.users![0].profileImageUrl, background: true)
                
                
                Text("@\(notification.users![0].userName)")
                    .fontWeight(.semibold)
                    .foregroundStyle(.colorOrange)
                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                +
                Text(notification.type.notidicationMessage)
                    //.fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .font(.custom("HankenGrotesk-Regular", size: .P2))
            }
            
            if notification.users?.count == 2 {
                ZStack{
                    
                    ImageView(size: .xxsmall, imageUrl: notification.users![0].profileImageUrl, background: true)
                    
                    ImageView(size: .xxsmall, imageUrl: notification.users![1].profileImageUrl, background: true)
                    
                        .offset(x: 10, y: 10)
                }.frame(width: 40)
                
                Text("@\(notification.users![0].userName)")
                    .fontWeight(.semibold)
                    .foregroundStyle(.colorOrange)
                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                
                +
                Text(" and ")
                    .foregroundStyle(.black)
                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                
                +
                Text("@\(notification.users![0].userName)")
                    .fontWeight(.semibold)
                    .foregroundStyle(.colorOrange)
                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                +
                Text(notification.type.notidicationMessage)
                    //.fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .font(.custom("HankenGrotesk-Regular", size: .P2))
            }
            
            if notification.users?.count ?? 0 > 2 {
                ZStack{
                    ImageView(size: .xxsmall, imageUrl: notification.users![0].profileImageUrl, background: true)
                    
                    ImageView(size: .xxsmall, imageUrl: notification.users![1].profileImageUrl, background: true)
                    
                        .offset(x: 10, y: 10)
                }.frame(width: 40)
                
                Text("@\(notification.users![0].userName), @\(notification.users![1].userName)")
                    .fontWeight(.semibold)
                    .foregroundStyle(.colorOrange)
                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                
                +
                Text(" and \((notification.users?.count ?? 0) - 2) more")
                    .foregroundStyle(.black)
                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                
                +
                Text(notification.type.notidicationMessage)
                    //.fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .font(.custom("HankenGrotesk-Regular", size: .P2))
            }
            
            Spacer()
            
            if notification.type != .follow {
                if let imageUrl = notification.post?.imageUrls {
                    KFImage(URL(string: imageUrl[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: 48, height: 48)
                }
            }
            
            
            
        }.frame(height: 64)
        .padding(.horizontal, 8)
            .onFirstAppear {
                Task{
                    try await viewModel.updateSeen()
                }
            }
    }
}
/*
#Preview {
    NotificationCell()
}*/
