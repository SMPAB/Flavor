//
//  QR-code.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-02.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct QRCodeView: View {
    let urlString: String
    
    var body: some View {
        if let qrCodeImage = generateQRCode(from: urlString) {
            
            ZStack{
                Image(uiImage: qrCodeImage)
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .cornerRadius(8)
                
                
                
                Image("appstore")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .contentShape(RoundedRectangle(cornerRadius: 8))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                            .stroke(.colorWhite, lineWidth: 14)
                    )
                
            }
            
        } else {
            Text("Failed to generate QR code")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
            let data = Data(string.utf8)
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                filter.setValue("H", forKey: "inputCorrectionLevel") // Higher error correction level
                if let outputImage = filter.outputImage {
                    let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10)) // Increase scale for higher resolution
                    let gradientQRCode = transformedImage.applyGradientColors(startColor: UIColor.yellow, endColor: UIColor.orange)
                    let context = CIContext()
                    if let cgImage = context.createCGImage(gradientQRCode, from: gradientQRCode.extent) {
                        return UIImage(cgImage: cgImage)
                    }
                }
            }
            return nil
        }
    }

    extension CIImage {
        func applyGradientColors(startColor: UIColor, endColor: UIColor) -> CIImage {
            let filter = CIFilter(name: "CILinearGradient")!
            let startVector = CIVector(x: extent.minX, y: extent.maxY)
            let endVector = CIVector(x: extent.maxX, y: extent.minY)
            filter.setValue(startVector, forKey: "inputPoint0")
            filter.setValue(endVector, forKey: "inputPoint1")
            filter.setValue(CIColor(color: startColor), forKey: "inputColor0")
            filter.setValue(CIColor(color: endColor), forKey: "inputColor1")
            
            let gradientImage = filter.outputImage!.cropped(to: extent)
            
            let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha")!
            maskToAlphaFilter.setValue(self, forKey: kCIInputImageKey)
            let maskToAlphaImage = maskToAlphaFilter.outputImage!
            
            let coloredQRCode = gradientImage.applyingFilter("CIMultiplyCompositing", parameters: [
                kCIInputBackgroundImageKey: maskToAlphaImage
            ])
            
            return coloredQRCode
        }
    }
