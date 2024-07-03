//
//  QRCode.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-02.
//

import SwiftUI

struct QRCode: View {
    
    let name: String?
    let whatWasSaved: String?
    @Binding var showView: Bool
    let LINK: String
    
    
    var body: some View {
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea(.all).onTapGesture {
                    showView.toggle()
                }
                
                VStack {
                    VStack{
                        CodeView(string: "\(LINK)")
                            .padding(.bottom)
                        
                        Text("Scan this QR-code with a smartphone or any other sutable device")
                            .multilineTextAlignment(.center)
                            .font(.primaryFont(.P2))
                            .foregroundStyle(Color(.systemGray))
                            .padding(.bottom)
                        
                        
                        
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 32)
                   
                    Divider()
                    
                    Button(action: {
                        Task {
                                   let renderer = ImageRenderer(content: CodeView(string: LINK))
                                   renderer.proposedSize = .init(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
                                   
                                   guard let uiImage = renderer.uiImage else {
                                       print("Failed to generate QR code image.")
                                       return
                                   }
                                   
                                   UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                            
                            showView.toggle()
                            }
                        
                    }){
                        Text("Save to cameraroll")
                            .frame(maxWidth: .infinity)
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                    }.padding(.top, 4)
                    
                    
                    Divider()
                    
                    
                    Button(action: {
                        showView.toggle()
                    }){
                        Text("Done")
                            .frame(maxWidth: .infinity)
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.black)
                    
                    }.padding(.bottom, 8)
                    
                    
                } .frame(maxWidth: 300)
                    
                    .background(.colorWhite)
                    .cornerRadius(16)
               
            }
        }
        
        @ViewBuilder
        func CodeView(string: String) -> some View {
            VStack {
                QRCodeView(urlString: "https://apps.apple.com/app/flavor/id6499230618" /*"https://example.com/\(string)"*/)
                    .padding(.bottom, 16)
                
                if let text = whatWasSaved {
                    GradientText(text: "\(text) WAS SAVED \(Date().formattedQRDate())")
                        .font(.primaryFont(.P2))
                }
                if let name = name {
                    GradientText(text: "@\(name)")
                        .font(.primaryFont(.P2))
                }
            }.padding(.horizontal, 32)
                .padding(.top, 32)
                .padding(.bottom, 16)
                
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.colorWhite)
                    .stroke(Color(.systemGray4))
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            // Adjusted to use the correct SwiftUI color syntax
        }
    
    
}

#Preview {
    QRCode(name: "EmilioMz", whatWasSaved: "POST", showView: .constant(true), LINK: "")
}

extension Date {
    func formattedQRDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "nl") // Setting Dutch locale for "JUNI"
        return formatter.string(from: self).uppercased()
    }
}

struct GradientText: View {
    var text: String
    
    var body: some View {
        Text(text)
            
            .foregroundColor(.clear)
            .overlay(
                LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing)
                    .mask(Text(text).font(.primaryFont(.P2)))
            )
    }
}
