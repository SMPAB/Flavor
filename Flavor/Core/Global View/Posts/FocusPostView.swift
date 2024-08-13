//
//  FocusPostView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI
import Iconoir
import Kingfisher

struct FocusPostView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State var scalePhoto: CGFloat = 1.0
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        if let post = homeViewModel.focusPost{
            
        
            ZStack{
                VStack{
                    HStack{
                        Button(action: {
                            homeViewModel.showFocusPost.toggle()
                            homeViewModel.focusPostIndex = nil
                            homeViewModel.focusPost = nil
                        }){
                            Iconoir.xmark.asImage
                                .foregroundStyle(.colorWhite)
                        }
                        
                        Spacer()
                    }.padding(.horizontal, 16)
                    
                    Spacer()
                }.padding(.top, 100)
                
               
                TabView(selection: $homeViewModel.focusPostIndex){
                        ForEach(post.imageUrls!, id: \.self){ imageUrl in
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: width, height: width * 5/4)
                                .clipShape(Rectangle())
                                .contentShape(Rectangle())
                                .scaleEffect(scalePhoto)
                                .gesture(
                                    MagnificationGesture()
                                    .onChanged { value in
                                        scalePhoto = value
                                    }
                                    .onEnded { value in
                                        withAnimation{
                                            scalePhoto = 1.0
                                        }
                                        
                                    }
                                )
                                .tag(post.imageUrls?.firstIndex(where: {$0 == imageUrl}))
                                
                        }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .frame(height: width * 5/4)
                    
                
                VStack(alignment: .leading){
                    
                    Spacer()
                    if let title = post.title{
                        Text(title)
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.colorWhite)
                            .fontWeight(.semibold)
                    }
                    
                    if let caption = post.caption{
                        Text(caption)
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.colorWhite)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 100)
                
            }.frame(height: UIScreen.main.bounds.height + 100)
            .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(.black)
            )
            
               
        }
        
    }
}

#Preview {
    FocusPostView()
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
