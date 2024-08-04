//
//  MapFocusPostView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-02.
//

import SwiftUI
import Iconoir
import Kingfisher

struct MapFocusPostView: View {
    
    @EnvironmentObject var sceneController: SceneController
    
    @State var scalePhoto: CGFloat = 1.0
    @State var offsetPhoto: CGFloat = 0
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        ZStack{
            
            Color.black.ignoresSafeArea()
            if sceneController.showPost {
                if let post = sceneController.selectedPost {
                    ZStack{
                        VStack{
                            HStack{
                                Button(action: {
                                    sceneController.hideOverlay.toggle()
                                    sceneController.selectedPost = nil
                                    sceneController.showPost = false
                                }){
                                    Iconoir.xmark.asImage
                                        .foregroundStyle(.colorWhite)
                                }
                                
                                Spacer()
                            }.padding(.horizontal, 16)
                            
                            Spacer()
                        }.padding(.top, 100)
                        
                       
                        TabView{
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
                    .onTapGesture {
                        sceneController.hideOverlay.toggle()
                        sceneController.selectedPost = nil
                        sceneController.showPost = false
                    }
                   
                } else {
                    VStack{}.onAppear{sceneController.hideOverlay.toggle()}
                }
            }
            
            if sceneController.showStorys {
                
               
                
                ForEach(sceneController.storyIds, id: \.self) { id in
                    StoryDisplayView(id: id)
                        .environmentObject(sceneController)
                        .onTapGesture {
                            sceneController.storyIds.removeAll(where: {$0 == id})
                            
                            if sceneController.storyIds.isEmpty {
                                sceneController.hideOverlay = true
                                sceneController.storyIds = []
                                sceneController.showStorys = false
                            }
                        }
                        
                }
            }
        } /*.gesture(
            DragGesture()
                .onChanged({ newValue in
                    let value = newValue.translation.height
                    
                    offsetPhoto = value
                })
            
                .onEnded({ endValue in
                    let value = endValue.translation.height
                    
                    if value < 200 {
                        withAnimation{
                            offsetPhoto = 0
                        }
                    } else {
                        sceneController.hideOverlay.toggle()
                        sceneController.selectedPost = nil
                        sceneController.showPost = false
                        offsetPhoto = 0
                    }
                })
        )
        .offset(y: offsetPhoto)*/
    }
}
