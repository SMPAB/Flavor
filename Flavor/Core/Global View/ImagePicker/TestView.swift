//
//  TestView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct TestView: View {
    
    @State var image: Image?
    @State var uiImage: UIImage?
    @State var showView = false
    
    var body: some View {
        ZStack{
            VStack{
                Text("Change Image")
                    .onTapGesture {
                        showView.toggle()
                    }
                
                
                if let image = uiImage{
                    Image(uiImage: image).resizable().frame(width: 100, height: 100)
                }
            }
            
            if showView{
                ImagePickerOptions(image: $image, uiimage: $uiImage, showView: $showView, imageType: .albumImage)
            }
            
        }
    }
}

#Preview {
    TestView()
}
