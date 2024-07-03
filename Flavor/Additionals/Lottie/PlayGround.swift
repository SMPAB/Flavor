//
//  PlayGround.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-02.
//

import SwiftUI

struct PlayGround: View {
    var body: some View {
        QRCodeView(urlString: "https://example.com/posts/hello")
    }
}

#Preview {
    PlayGround()
}
