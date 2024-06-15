//
//  LandingView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct LandingView: View {
    
    @Binding var showLanding: Bool
    @State var showBackground = false
    @State private var visible = true
    
    var body: some View {
        ZStack{
            GifImageView("background")
                .scaleEffect(1.4)
        
        if !showBackground{
            Image("GradientStill")
                .scaleEffect(1.4)
        }
            VStack{
                Image("Logo_Single_White")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 110)
                
                Text("Savor the Flavor")
                    .font(.primaryFont(.H4))
                    .foregroundStyle(.colorWhite)
                
                Text("Tap anywhere to begin")
                    .font(.primaryFont(.P2))
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .opacity(visible ? 1 : 0.2)
                        .padding(.top)
            }
            
            
            
        }.onAppear{
            pulsateText()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    showBackground = true
            }
    }
        .onTapGesture{
            showLanding.toggle()
        }
        
    }
    
    private func pulsateText() {
        withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            visible.toggle()
        }
    }
}

#Preview {
    LandingView(showLanding: .constant(false))
}
