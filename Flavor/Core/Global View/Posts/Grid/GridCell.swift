//
//  GridCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-01.
//

import SwiftUI
import Kingfisher

struct GridCell: View {
    
    
    
    let widthMultiplier: Int
    let heightMultiplier: Int
    let cornerRadius: CGFloat
    
    
    
    @State var width = UIScreen.main.bounds.width
    
    @StateObject var viewModel: GridCellViewModel
    
    @EnvironmentObject var homeVM: HomeViewModel
    let profileVM: ProfileViewModel
    
    let variableTitle: String
    let variableSubTitle: String?
    
    init(user: User, postId: String, profileVM: ProfileViewModel, widthMultiplier: Int, heightMultiplier: Int, cornerRadius: CGFloat, variableTitle: String, variableSubtitle: String?) {
        self._viewModel = StateObject(wrappedValue: GridCellViewModel(postId: postId, user: user, profileVM: profileVM))
        self.widthMultiplier = widthMultiplier
        self.heightMultiplier = heightMultiplier
        self.cornerRadius = cornerRadius
        self.profileVM = profileVM
        self.variableTitle = variableTitle
        self.variableSubTitle = variableSubtitle
    }
    var body: some View {
        ZStack{
            if let post = viewModel.post {
                
                
                if let imageUrls = post.imageUrls {
                    
                    NavigationLink(destination:
                                    VariableView()
                                    .environmentObject(homeVM)
                                    .onAppear{
                                        homeVM.selectedVariableUploadId = post.id
                                        homeVM.variableUplaods = profileVM.posts.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
                                        homeVM.variablesTitle = variableTitle
                                        homeVM.variableSubTitle = variableSubTitle
                                    }
                    ){
                        KFImage(URL(string: imageUrls[0]))
                            .resizable()
                            .scaledToFill()
                            .frame(width: width * (CGFloat(widthMultiplier)/390), height: width * (CGFloat(heightMultiplier)/390))
                            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .background(.red)
                    }
                    
                    
                        
                }
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemGray6))
                    .frame(width: width * (CGFloat(widthMultiplier)/390), height: width * (CGFloat(heightMultiplier)/390))
                    .background(.blue)
                    
            }
        }.onFirstAppear {
            Task{
                try await viewModel.fetchPost()
            }
        }
        
    }
}
/*
#Preview {
    GridCell(user: User.mockUsers[0], widthMultiplier: 120, heightMultiplier: 120)
}*/
