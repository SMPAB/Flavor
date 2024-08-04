//
//  StoryDisplayView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-03.
//

import SwiftUI
import Firebase
import Kingfisher
import Iconoir

struct StoryDisplayView: View {
    
    @StateObject var viewModel: StoryDisplayVM
    @EnvironmentObject var controller: SceneController
    
    init(id: String){
        self._viewModel = StateObject(wrappedValue: StoryDisplayVM(storyId: id))
    }
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        ZStack{
            Color.black.ignoresSafeArea()
            
            
            VStack{
                HStack{
                    Button(action: {
                        controller.hideOverlay = true
                        controller.storyIds = []
                        controller.showStorys = false
                    }){
                        Iconoir.xmark.asImage
                            .foregroundStyle(.colorWhite)
                    }
                    
                    Spacer()
                }.padding(.horizontal, 16)
                
                Spacer()
            }.padding(.top, 80)
            
            if let story = viewModel.story {
                ZStack{
                    
                   
                    
                    KFImage(URL(string: story.imageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: width * 6/4)
                        .clipShape(Rectangle())
                        .contentShape(Rectangle())
                    
                    /*VStack{
                        
                        HStack{
                            
                            Button(action: {
                                controller.hideOverlay = true
                                controller.storyIds = []
                                controller.showStorys = false
                            }){
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.colorWhite)
                            }
                            
                            
                            Spacer()
                        }.padding(.horizontal, 16)
                        Spacer()
                            
                        
                        
                    }.padding(.vertical, 16)*/
                }.frame(width: width, height: width * 6/4)
            }
            
            
            
            
            if viewModel.fetchingStory {
                Loading()
            }
        }.frame(height: UIScreen.main.bounds.height)
        .onAppear{
            Task {
                try await viewModel.fetchStory()
            }
        }
    }
}

#Preview {
    StoryDisplayView(id: "12321ejqwdaksda")
}
