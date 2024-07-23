//
//  TestGrid.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-01.
//

import SwiftUI
import Iconoir

struct TestGrid: View {
    
    let posts: [String]

    @State var albumPosts: [Post] = []
   
    
    @State var width = UIScreen.main.bounds.width
    
    @State var cornerRadius: CGFloat = 8
    
    @State var paddingBottom: CGFloat = 0
    
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    let variableTitle: String
    let variableSubtitle: String?
    
   
    
    var body: some View {
       
        
        let gridItems = [GridItem(.fixed(width * 120/390), spacing: width * 10/390/1.2, alignment: .leading),
                         GridItem(.fixed(width * 120/390), spacing: width * 10/390/1.2, alignment: .leading),
                         GridItem(.fixed(width * 120/390), spacing: width * 10/390/1.2, alignment: .leading)]
        
        
        
        
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: width * 10/390/1.2) {
                ForEach(Array(posts.enumerated()), id: \.element) { index, postId in
                    
                    let modIndex = index % 14
                    
                    if modIndex == 0 {
                        ZStack(alignment: .topTrailing){
                            GridCell(user: profileVM.user, postId: postId, profileVM: profileVM, widthMultiplier: 250, heightMultiplier: 250, cornerRadius: cornerRadius, variableTitle: variableTitle, variableSubtitle: variableSubtitle)
                                .environmentObject(homeVM)
                                .frame(width: width * 250/390, height: width * 250/390)
                                .cornerRadius(cornerRadius)
                                .frame(height: width * 120/390, alignment: .top)
                            
                            if !profileVM.album  && postId == homeVM.currentlyPinnedPost{
                                Iconoir.pinSolid.asImage
                                    .foregroundStyle(.colorWhite)
                                    .padding(4)
                                    
                            }
                        }
                        
                            
                            
                    } else if modIndex == 3 {
                        GridCell(user: profileVM.user, postId: postId, profileVM: profileVM, widthMultiplier: 120, heightMultiplier: 250, cornerRadius: cornerRadius, variableTitle: variableTitle, variableSubtitle: variableSubtitle)
                            .environmentObject(homeVM)
                            .frame(width: width * 120/390, height: width * 250/390)
                            .cornerRadius(cornerRadius)
                            .frame(height: width * 120/390, alignment: .top)
                            
                    } else if modIndex == 6{
                        
                        GridCell(user: profileVM.user, postId: postId, profileVM: profileVM, widthMultiplier: 250, heightMultiplier: 120, cornerRadius: cornerRadius, variableTitle: variableTitle, variableSubtitle: variableSubtitle)
                            .environmentObject(homeVM)
                            .frame(width: width * 250/390, height: width * 120/390)
                            .cornerRadius(cornerRadius)
                            .frame(width: width * 120/390, alignment: .trailing)
                            
                        
                    } else if modIndex == 8 {
                        GridCell(user: profileVM.user, postId: postId, profileVM: profileVM, widthMultiplier: 250, heightMultiplier: 250, cornerRadius: cornerRadius, variableTitle: variableTitle, variableSubtitle: variableSubtitle)
                            .environmentObject(homeVM)
                            .frame(width: width * 250/390, height: width * 250/390)
                            .cornerRadius(cornerRadius)
                            .frame(height: width * 120/390, alignment: .top)
                            
                    } else if modIndex == 12 {
                        GridCell(user: profileVM.user, postId: postId, profileVM: profileVM, widthMultiplier: 120, heightMultiplier: 250, cornerRadius: cornerRadius, variableTitle: variableTitle, variableSubtitle: variableSubtitle)
                            .environmentObject(homeVM)
                            .frame(width: width * 120/390, height: width * 250/390)
                            .cornerRadius(cornerRadius)
                            .frame(height: width * 120/390, alignment: .top)
                           
                    } else if modIndex == 13 {
                        GridCell(user: profileVM.user, postId: postId, profileVM: profileVM, widthMultiplier: 250, heightMultiplier: 120, cornerRadius: cornerRadius, variableTitle: variableTitle, variableSubtitle: variableSubtitle)
                            .environmentObject(homeVM)
                            .frame(width: width * 250/390, height: width * 120/390)
                            .cornerRadius(cornerRadius)
                            .frame(width: width * 120/390, alignment: .leading)
                            
                    } else {
                        GridCell(user: profileVM.user, postId: postId, profileVM: profileVM, widthMultiplier: 120, heightMultiplier: 120, cornerRadius: cornerRadius, variableTitle: variableTitle, variableSubtitle: variableSubtitle)
                            .environmentObject(homeVM)
                            .frame(width: width * 120/390, height: width * 120/390)
                            .cornerRadius(cornerRadius)
                            .frame(height: width * 120/390, alignment: .top)
                            
                    }
                    
                    
                    if modIndex == 0  || modIndex == 8 {
                        Color.clear
                    }
                    if modIndex == 1  || modIndex == 5 || modIndex == 9 || modIndex == 13{
                        Group {
                            Color.clear
                            Color.clear
                        }
                    }
                }
            }
            .frame(width: 380)
            .padding(.bottom, paddingBottom)
            .onAppear {
                            let paddingPattern: Set<Int> = [1, 2, 4, 5, 6, 9, 13]
                            let modIndex = posts.count % 14
                            
                            if paddingPattern.contains(modIndex) {
                                paddingBottom = width * 120/390 + 16
                            } else {
                                paddingBottom = 0
                            }
                        }
        }
        
    }
}
/*
#Preview {
    TestGrid()
}*/
