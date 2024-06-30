//
//  UploadAnimationModifier.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-30.
//

import SwiftUI
import Lottie

struct UploadAnimationModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    @Binding var finished: Bool
    let image: UIImage?
    let finishedAction: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPresented ? 3 : 0)
            
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                Uploading(finished: $finished, image: image)
                    .onChange(of: finished) { newValue in
                        if newValue {
                            finishedAction()
                            withAnimation {
                               // isPresented = false
                            }
                        }
                    }
            }
        }
    }
}

extension View {
    func uploadAnimation(isPresented: Binding<Bool>, finished: Binding<Bool>, image: UIImage?, finishedAction: @escaping () -> Void) -> some View {
        self.modifier(UploadAnimationModifier(isPresented: isPresented, finished: finished, image: image, finishedAction: finishedAction))
    }
}
