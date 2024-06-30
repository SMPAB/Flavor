//
//  Uploading.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-29.
//

import SwiftUI
import Lottie

struct Uploading: View {
    
    @Binding var finished: Bool
    let image: UIImage?
    
    var body: some View {
        VStack{
            
            Text("Your post will soon be uploaded!")
                .font(.primaryFont(.P1))
                .fontWeight(.semibold)
            
            Text("dont exit the application")
                .font(.primaryFont(.P2))
                .foregroundStyle(Color(.systemGray))
            
            
            LottieView(animation: .named("Uploading"))
                .playbackMode(finished ? .playing(.toProgress(1, loopMode: .playOnce)) : .playing(.fromFrame(1, toFrame: 105, loopMode: .playOnce)))
                
                
                .resizable()
                .frame(width: 72, height: 72)
            
        }.padding(16)
        .background(
        RoundedRectangle(cornerRadius: 32)
            .fill(.colorWhite)
            .shadow(radius: 5)
        )
    }
}

#Preview {
    Uploading(finished: .constant(false), image: nil)
}
