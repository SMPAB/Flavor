//
//  CustomAlertModifier.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    var title: String?
    var message: String
    var boldMessage: String?
    var afterBold: String?
    var confirmAction: () -> Void
    var cancelAction: () -> Void
    var imageUrl: String?
    var dismissText: String
    var acceptText: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPresented ? 3 : 0)
            
            if isPresented {
                CustomAlertView(
                    title: title,
                    message: message,
                    boldMessage: boldMessage,
                    afterBold: afterBold,
                    confirmAction: {
                        confirmAction()
                        isPresented = false
                    },
                    cancelAction: {
                        cancelAction()
                        isPresented = false
                    },
                    imageUrl: imageUrl,
                    dismissText: dismissText,
                    acceptText: acceptText
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>,
                     title: String? = nil,
                     message: String,
                     boldMessage: String? = nil,
                     afterBold: String? = nil,
                     confirmAction: @escaping () -> Void,
                     cancelAction: @escaping () -> Void,
                     imageUrl: String? = nil,
                     dismissText: String,
                     acceptText: String) -> some View {
        self.modifier(CustomAlertModifier(isPresented: isPresented,
                                          title: title,
                                          message: message,
                                          boldMessage: boldMessage,
                                          afterBold: afterBold,
                                          confirmAction: confirmAction,
                                          cancelAction: cancelAction,
                                          imageUrl: imageUrl,
                                          dismissText: dismissText,
                                          acceptText: acceptText))
    }
}

