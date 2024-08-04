//
//  CustomSheetView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-02.
//

import SwiftUI

struct CustomSheetView: View {
    
    let minHeight: CGFloat
    let maxHeight: CGFloat
    @State private var offset: CGFloat = 0
    
    @State var dissableScrolling = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    VStack {
                        Text("BACBACBSCASC")
                            .font(.system(size: 24)) // Adjust as needed
                            .padding()
                            .background(Color.orange) // Adjust color as needed
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .background(GeometryReader { innerGeometry in
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: innerGeometry.frame(in: .global).minY)
                    })
                }
                .scrollDisabled(dissableScrolling)
                .frame(maxWidth: .infinity)
                .background(Color.white) // Adjust color as needed
                .cornerRadius(12)
                .shadow(radius: 8) // Optional visual enhancement
                .animation(.easeOut, value: offset) // Smooth transition
                .offset(y: offset)
            }.gesture(
                
                    DragGesture()
                        .onChanged{ value in
                            print("DRAGOFFSETVALUE: \(value.translation.height)")
                            offset = value.translation.height
                        }
               
                
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
               // self.offset = value
                print("\(value)")
                
                if value < 139 {
                    
                } else {
                    dissableScrolling = true
                }
            }
        }
        .frame(height: maxHeight)
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    CustomSheetView(minHeight: 300, maxHeight: 600)
}
