//
//  OptionsSheet.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-02.
//

import SwiftUI
import Iconoir

struct OptionsSheet: View {
    
    @EnvironmentObject var cellVM: FeedCellViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    var post: Post {
        return cellVM.post
    }
    
    var isSaved: Bool {
        return cellVM.post.hasSaved ?? false
    }
    
    var isPinned: Bool {
        return post.pinned ?? false
    }
    var body: some View {
        VStack(spacing: 8){
            HStack(spacing: 8){
                
                Button(action: {
                    handleSavedTapped()
                }){
                    VStack{
                        
                        if !isSaved{
                            Iconoir.bookmark.asImage
                                
                            Text("Save")
                                .font(.primaryFont(.P2))
                        } else {
                            Iconoir.bookmarkSolid.asImage
                                
                            Text("Remove from saved")
                                .font(.primaryFont(.P2))
                        }
                        
                    }
                    .frame(height: 64)
                    
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                }.foregroundStyle(.black)
                
                
                Button(action: {
                    cellVM.showOptionsSheet.toggle()
                    
                    homeVM.QRuserName = cellVM.post.user?.userName ?? ""
                    homeVM.QRCODELINK = "/posts/\(cellVM.post.id)"
                    homeVM.whatWasSaved = "POST"
                    withAnimation{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                            homeVM.showQRCode = true
                        }
                    }
                    
                }){
                    VStack{
                        Iconoir.qrCode.asImage
                            
                        Text("QR-code")
                            .font(.primaryFont(.P2))
                    }
                    .frame(height: 64)
                    
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                }.foregroundStyle(.black)
                
            }
            
            
            if cellVM.post.ownerUid != homeVM.user.id {
                VStack{
                    VStack(spacing: 0){
                        
                        Button(action: {
                            cellVM.showOptionsSheet = false
                            homeVM.navigationUser = cellVM.post.user
                            homeVM.navigateToUser = true
                        }){
                            HStack{
                                Iconoir.profileCircle.asImage
                                    
                                Text("Go to account")
                                    .font(.primaryFont(.P2))
                                
                                Spacer()
                            }.foregroundStyle(Color(.black))
                                .padding(.horizontal, 16)
                            .frame(height: 44)
                        }
                        
                        
                        Divider()
                        
                        Button(action: {
                            cellVM.showOptionsSheet = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                cellVM.showReportSheet = true
                            }
                        }) {
                            HStack{
                                Iconoir.warningCircle.asImage
                                    
                                Text("Report Flavor")
                                    .font(.primaryFont(.P2))
                                
                                Spacer()
                            }.foregroundStyle(Color(.systemRed))
                                .padding(.horizontal, 16)
                            .frame(height: 44)
                        }
                    }
                    
                    
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                }.foregroundStyle(.black)
            } else {
                VStack{
                    VStack(spacing: 0){
                        
                       
                        
                        Button(action: {
                           handlePinnedTapped()
                        }){
                            HStack{
                                
                                if isPinned {
                                    Iconoir.pinSolid.asImage
                                        
                                    Text("Remove pin on profile")
                                        .font(.primaryFont(.P2))
                                    
                                    Spacer()
                                } else {
                                    Iconoir.pin.asImage
                                        
                                    Text("Pin on profile")
                                        .font(.primaryFont(.P2))
                                    
                                    Spacer()
                                }
                                
                            }.foregroundStyle(Color(.black))
                                .padding(.horizontal, 16)
                            .frame(height: 44)
                        }
                        
                        
                        Divider()
                        
                        
                        Button(action: {
                            
                            cellVM.showOptionsSheet = false
                            homeVM.editPost = cellVM.post
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                                homeVM.showEditPost = true
                            }
                        }){
                            HStack{
                                Iconoir.editPencil.asImage
                                    
                                Text("Edit")
                                    .font(.primaryFont(.P2))
                                
                                Spacer()
                            }.foregroundStyle(Color(.black))
                                .padding(.horizontal, 16)
                            .frame(height: 44)
                        }
                        
                        
                        Divider()
                        
                        Button(action: {
                            cellVM.showOptionsSheet = false
                            homeVM.deletePost = post
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                withAnimation(.spring(duration: 0.2, bounce: 0.4)){
                                    homeVM.showDeletePostAlert = true
                                }
                            }
                            
                           
                        }) {
                            HStack{
                                Iconoir.trash.asImage
                                    
                                Text("Delete flavor")
                                    .font(.primaryFont(.P2))
                                
                                Spacer()
                            }.foregroundStyle(Color(.systemRed))
                                .padding(.horizontal, 16)
                            .frame(height: 44)
                        }
                    }
                    
                    
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                }.foregroundStyle(.black)
            }
        }.padding(.horizontal, 16)
    }
    
    func handleSavedTapped() {
        if isSaved{
            Task{
                try await cellVM.unsave()
            }
        } else {
            Task{
                try await cellVM.save()
            }
        }
    }
    
    func handlePinnedTapped() {
        if isPinned {
            Task {
                try await cellVM.unpin()
                homeVM.newUnpinPost = post.id
            }
        } else {
            Task {
                try await cellVM.pin(homeVM: homeVM)
                homeVM.newPinPost = post.id
            }
        }
    }
}

#Preview {
    OptionsSheet()
        .environmentObject(FeedCellViewModel(post: Post.mockPosts[0]))
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
