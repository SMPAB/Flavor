//
//  LandingCameraView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI

struct LandingCameraView: View {
    
    @Binding var story: Bool
    @State var localStory = false
    @State var showOptions = true
    @EnvironmentObject var homeVM: HomeViewModel
    
    
    var body: some View {
        ZStack{
            if localStory{
                camera(showOption: $showOptions)
                    .environmentObject(homeVM)
            } else {
                NewPostView(showOptions: $showOptions)
                    .environmentObject(homeVM)
            }
            
            if showOptions{
                VStack{
                    Spacer()
                    
                    HStack{
                        Button(action: {
                            withAnimation{
                                localStory = false
                            }
                            
                        }){
                            Text("Post")
                                .font(.primaryFont(.P1))
                                .foregroundStyle(.colorWhite)
                                .fontWeight(.semibold)
                        }
                        
                        Rectangle()
                            .frame(width: 1, height: 37)
                        
                        Button(action: {
                            withAnimation{
                                localStory = true
                            }
                        }){
                            Text("Story")
                                .font(.primaryFont(.P1))
                                .foregroundStyle(.colorWhite)
                                .fontWeight(.semibold)
                        }
                    }.padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(localStory ? .black : Color(.systemGray))
                    )
                    .offset(x: localStory ? -30 : 30)
                    
                    
                   
                    
                    
                }
            }
            
        }.onAppear{
            localStory = story
        }
    }
}

#Preview {
    LandingCameraView(story: .constant(false))
}
