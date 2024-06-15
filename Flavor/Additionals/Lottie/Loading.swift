//
//  Loading.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI
import Lottie

struct Loading: View {
    var body: some View {
        LottieView(animation: .named("LoadingAnimation"))
            .playbackMode(.playing(.toProgress(1, loopMode: .autoReverse)))
            .resizable()
            .frame(width: 72, height: 72)
    }
}

#Preview {
    Loading()
}
