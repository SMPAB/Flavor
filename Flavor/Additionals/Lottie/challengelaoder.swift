//
//  challengelaoder.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-01.
//

import SwiftUI
import Lottie

struct challengelaoder: View {
    var body: some View {
        LottieView(animation: .named("challenges"))
            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
            .resizable()
            .frame(width: 140, height: 140)
    }
}

#Preview {
    challengelaoder()
}
