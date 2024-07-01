//
//  TestGrid.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-01.
//

import SwiftUI

struct TestGrid: View {
    
    let posts: [String] = ["dfg", "abc", "post3", "post4", "post5", "post6", "post7", "post8", "post9", "post10", "post11", "post12", "post13", "a3c", "po2t3", "p2st4", "podst5", "posat6", "posat7", "pocst8", "poasst9", "posdwt10", "pos123t11", "posdat12"]
    
    @State var width = UIScreen.main.bounds.width
    
    @State var cornerRadius: CGFloat = 8
    
    @State var paddingBottom: CGFloat = 0
    
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
       
        
        let gridItems = [GridItem(.fixed(width * 120/390), spacing: width * 10/390, alignment: .leading),
                         GridItem(.fixed(width * 120/390), spacing: width * 10/390, alignment: .leading),
                         GridItem(.fixed(width * 120/390), spacing: width * 10/390, alignment: .leading)]
        
        
        
        
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: width * 10/390) {
                ForEach(Array(posts.enumerated()), id: \.element) { index, postId in
                    
                    let modIndex = index % 14
                    
                    if modIndex == 0 {
                        GridCell(user: profileVM.user, postId: postId, profileVM: profileVM, widthMultiplier: 250, heightMultiplier: 250, cornerRadius: cornerRadius)
                            .frame(width: width * 250/390, height: width * 250/390)
                            .background(Color.red)
                            .cornerRadius(cornerRadius)
                            .frame(height: width * 120/390, alignment: .top)
                            
                    } else if modIndex == 3 {
                        Text("\(postId)")
                            .frame(width: width * 120/390, height: width * 250/390)
                            .background(Color.red)
                            .cornerRadius(cornerRadius)
                            .frame(height: width * 120/390, alignment: .top)
                            
                    } else if modIndex == 6{
                        
                        Text("\(postId)")
                            .frame(width: width * 250/390, height: 120)
                            .background(Color.red)
                            .cornerRadius(cornerRadius)
                            .frame(width: width * 120/390, alignment: .trailing)
                            
                        
                    } else if modIndex == 8 {
                        Text("\(postId)")
                            .frame(width: width * 250/390, height: width * 250/390)
                            .background(Color.red)
                            .cornerRadius(cornerRadius)
                            .frame(height: width * 120/390, alignment: .top)
                            
                    } else if modIndex == 12 {
                        Text("\(postId)")
                            .frame(width: width * 120/390, height: width * 250/390)
                            .background(Color.red)
                            .cornerRadius(cornerRadius)
                            .frame(height: width * 120/390, alignment: .top)
                           
                    } else if modIndex == 13 {
                        Text("\(postId)")
                            .frame(width: width * 250/390, height: 120)
                            .background(Color.red)
                            .cornerRadius(cornerRadius)
                            .frame(width: width * 120/390, alignment: .leading)
                            
                    } else {
                        Text("\(postId)")
                            .frame(width: width * 120/390, height: width * 120/390)
                            .background(Color.red)
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
                                paddingBottom = width * 120/390
                            } else {
                                paddingBottom = 0
                            }
                        }
        }
        
    }
}

#Preview {
    TestGrid()
}
