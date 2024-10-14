//
//  EmptySearchView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import SwiftUI
import Kingfisher

struct EmptySearchView: View {
    
    @EnvironmentObject var searchVM: MainSearchViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        VStack(alignment: .leading){
            Text("Recomended for your")
                .font(.primaryFont(.H4))
                .fontWeight(.semibold)
                .padding(.leading, 8)
                
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack(spacing: 16){
                    ForEach(searchVM.recommenderPosts){ post in
                        
                        
                        NavigationLink(
                            destination: VariableView()
                            .environmentObject(homeVM)
                            .onAppear{
                                homeVM.variableUplaods = searchVM.recommenderPosts
                                homeVM.selectedVariableUploadId = post.id
                                homeVM.variablesTitle = "Recomended"
                            }
                        ){
                            VStack{
                                
                                if let imageUrl = post.imageUrls{
                                    KFImage(URL(string: imageUrl[0]))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 175, height: 175)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .contentShape(RoundedRectangle(cornerRadius: 8))
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                                    LinearGradient(
                                                                        gradient: Gradient(colors: [.colorYellow, .colorOrange]),
                                                                        startPoint: .topLeading,
                                                                        endPoint: .bottomTrailing
                                                                    ),
                                                                    lineWidth: 4// Adjust the width of the border as needed
                                                                )
                                        )
                                        
                                        
                                }
                                
                                
                                HStack{
                                    Text("@\(post.ownerUsername)")
                                        .font(.primaryFont(.P2))
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                            }.onFirstAppear {
                                if post == searchVM.recommenderPosts.last{
                                    Task{
                                        try await searchVM.fetchRecomendedPosts()
                                    }
                                }
                            }
                            .foregroundStyle(.black)
                            /*.onTapGesture {
                                AnalyticsManager.shared.logEvent(name: "SearchLandingView_RecomendedPostTapped")
                            }*/
                            .frame(width: 179, height: 200)
                            
                        }
                        
                        
                    }
                    
                    if searchVM.fetchingRecomended {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .frame(width: 180, height: 170)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .frame(width: 180, height: 170)
                    }
                }.padding(.horizontal, 16)
            }
            
            Rectangle()
                .fill(Color(.gray))
                .frame(height: 1)
                .padding(.horizontal, 8)
            Text("Trending right now")
                .font(.primaryFont(.H4))
                .fontWeight(.semibold)
                .padding(.leading, 8)
                
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack(spacing: 16){
                    ForEach(searchVM.trendingPosts){ post in
                        NavigationLink(destination: 
                                        VariableView()
                            .environmentObject(homeVM)
                            .onAppear{
                                homeVM.variableUplaods = searchVM.trendingPosts
                                homeVM.variablesTitle = "Trending"
                                homeVM.selectedVariableUploadId = post.id
                            }
                        ) {
                            VStack{
                                
                                if let imageUrl = post.imageUrls{
                                    KFImage(URL(string: imageUrl[0]))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 175, height: 175)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .contentShape(RoundedRectangle(cornerRadius: 8))
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                                    LinearGradient(
                                                                        gradient: Gradient(colors: [.colorYellow, .colorOrange]),
                                                                        startPoint: .topLeading,
                                                                        endPoint: .bottomTrailing
                                                                    ),
                                                                    lineWidth: 4// Adjust the width of the border as needed
                                                                )
                                        )
                                        
                                        
                                }
                                
                                
                                HStack{
                                    Text("@\(post.ownerUsername)")
                                        .font(.primaryFont(.P2))
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                            }.onFirstAppear {
                                if post == searchVM.trendingPosts.last {
                                    Task{
                                        try await searchVM.fetchTrendingPosts()
                                    }
                                }
                            }
                            .frame(width: 179, height: 200)
                            .foregroundStyle(.black)
                        }
                    }
                    
                    if searchVM.fetchingTrending {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .frame(width: 180, height: 170)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .frame(width: 180, height: 170)
                    }
                }.padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    EmptySearchView()
}
