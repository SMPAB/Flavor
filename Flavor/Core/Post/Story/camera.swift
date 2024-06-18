//
//  camera.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation
import SwiftUI
import AVFoundation
import Iconoir
import CoreImage.CIFilterBuiltins

struct camera: View{
    
    @StateObject var camera = cameraModel()
    @Binding var showOption: Bool
    @EnvironmentObject var homeVM: HomeViewModel
    
    //@State var mainFilteredImage: FilteredImage?
   
    
    let filters : [CIFilter] = [
        CIFilter.sepiaTone(),
        CIFilter.photoEffectFade(),
        CIFilter.colorMonochrome(),
        CIFilter.photoEffectChrome(),
        CIFilter.bloom(),
        CIFilter.colorPosterize()
        
        
    ]
    
    @State var allImages: [FilteredImage] = []
    var body: some View{
        
        let width = UIScreen.main.bounds.width
        
        NavigationStack{
            ZStack{
                
                Color.black .ignoresSafeArea(.all, edges: .all)
                
               
                    ZStack{
                        CameraPreview(camera: camera)
                            .ignoresSafeArea(.all, edges: .all)
                            .onTapGesture(count: 2, perform: {
                                if !camera.isTaken{
                                    camera.switchCamera()
                                }
                            })
                        
                        /*if let uiImage = mainFilteredImage?.image{
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .rotationEffect(.degrees(90))
                                .frame(width: width, height: width*5/4)
                                .clipShape(Rectangle())
                                .offset(y: -UIScreen.main.bounds.height/14)
                        }*/
                    }
                
                
                   
                
                
                
                
                    if camera.isTaken{
                        ZStack{
                            //MARK: TOOLBAR
                            
                            VStack{
                                HStack{
                                    Button(action: {
                                        camera.reTake()
                                        
                                    }){
                                        Iconoir.xmark.asImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(.colorWhite)
                                    }
                                    
                                    Spacer()
                                    
                                    
                                }.padding(.horizontal, 16)
                                
                                Spacer()
                            }.padding(.top, UIScreen.main.bounds.height/25)
                            
                            if let image = camera.filteredImage{
                                Image(uiImage: image.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: width*5/4)
                                    .clipShape(Rectangle())
                                    .padding(.bottom, 50)
                            } else {
                                Image(uiImage: camera.uiimage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: width*5/4)
                                    .clipShape(Rectangle())
                                    .padding(.bottom, 50)
                            }
                            
                            
                            VStack{
                                
                                Spacer()
                                
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack(spacing: 10){
                                        
                                        Image(uiImage: camera.uiimage!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 76, height: 76)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .onTapGesture {
                                                //camera.filteredImage?.filter = filtered.filter
                                               
                                                camera.updateFilter(to: .additionCompositing(), remove: true)
                                            }
                                        
                                        ForEach(allImages.sorted(by: {$0.filter?.name ?? "" > $1.filter?.name ?? ""})) { filtered in
                                            
                                            VStack{
                                                    Image(uiImage: filtered.image)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .rotationEffect(.degrees(90))
                                                        .frame(width: 76, height: 76)
                                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                                        .onTapGesture {
                                                            //camera.filteredImage?.filter = filtered.filter
                                                            camera.updateFilter(to: filtered.filter!)
                                                            print("DEBUG APP FILTERED IMAGE: \(camera.filteredImage)")
                                                        }
                                                    
                                                    
                                                
                                            }
                                            
                                        }
                                    }.padding()
                                }.padding(.bottom, 40)
                            }
                            
                            
                            VStack{
                                
                                Spacer()
                                
                                HStack{
                                    Button(action: {
                                        camera.savePic()
                                    }){
                                       Text("Save")
                                            .font(.primaryFont(.P1))
                                            .foregroundStyle(.colorWhite)
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                    }.background(
                                    RoundedRectangle(cornerRadius: 32)
                                        .fill(Color(.systemGray))
                                    )
                                    
                                    Spacer()
                                    
                                    
                                    NavigationLink(destination: {
                                        UploadStoryView(image: camera.filteredImage)
                                            .environmentObject(homeVM)
                                    }){
                                       Text("Next")
                                            .font(.primaryFont(.P1))
                                            .foregroundStyle(.colorWhite)
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                    }.background(
                                    RoundedRectangle(cornerRadius: 32)
                                        .fill(Color(.colorOrange))
                                    )
                                    
                                    
                                }.padding(.horizontal, 16)
                                
                                
                            }//.padding(.top, UIScreen.main.bounds.height/25)
                        }.background(.black)
                    } else {
                        ZStack{
                            
                            //MARK: TOOLBAR
                            VStack{
                                HStack{
                                    Button(action: {
                                        homeVM.showCamera.toggle()
                                    }){
                                        Iconoir.xmark.asImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(.colorWhite)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        camera.flash.toggle()
                                    }){
                                        if camera.flash {
                                            Iconoir.flash.asImage
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(.colorWhite)
                                        } else {
                                            Iconoir.flashOff.asImage
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(.colorWhite)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    
                                    Button(action: {
                                        camera.switchCamera()
                                    }){
                                        Iconoir.rotateCameraRight.asImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(.colorWhite)
                                    }
                                    
                                    
                                }.padding(.horizontal, 16)
                                
                                Spacer()
                            }.padding(.top, UIScreen.main.bounds.height/25)
                            
                            
                            //MARK: TAKE IMAGE BUTTON
                            
                            Button(action: {
                                camera.takePic()
                            }){
                                ZStack{
                                    
                                    Circle()
                                        .fill(.colorWhite)
                                        .frame(width: 80, height: 80)
                                    
                                    Circle()
                                        .fill(.colorWhite)
                                        .stroke(.black)
                                        .frame(width: 73, height: 73)
                                        
                                }
                            }.offset(y: (UIScreen.main.bounds.height - width*5/4) / 1.3)
                           
                        }
                    }
                
            }.onAppear{
                camera.check()
            }
            .onChange(of: camera.isTaken){
                if camera.isTaken{
                    showOption = false
                } else {
                    showOption = true
                }
            }
            .onChange(of: camera.picData, perform: { (_) in
                allImages.removeAll()
                loadFilters()
            })
        }
        
    }
    
     func loadFilters() {
        
        let context = CIContext()
         let rotatingAngle: CGFloat = 90
        filters.forEach{ (filter) in
            
            DispatchQueue.global(qos: .userInteractive).async {
                let CiImage = CIImage(data: camera.picData)
                
                filter.setValue(CiImage, forKey: kCIInputImageKey)
                
                guard let newImage = filter.outputImage else { return }
                let cgimage = context.createCGImage(newImage, from: newImage.extent)
                
               /* var filteredUIImage = UIImage(cgImage: cgimage!)
                if let rotatedImage = filteredUIImage.rotated(by: rotatingAngle){
                    filteredUIImage = rotatedImage
                }*/
                
                
                let filterData = FilteredImage(image: /*filteredUIImage*/UIImage(cgImage: cgimage!), filter: filter)
                
                DispatchQueue.main.async {
                    self.allImages.append(filterData)
                }
            }
           
           
            
        }
    }
    
    func applyFilter(to image: UIImage, using filter: CIFilter) -> UIImage {
            let context = CIContext()
            guard let ciImage = CIImage(image: image) else { return image }
            
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            guard let outputImage = filter.outputImage,
                  let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
            
            return UIImage(cgImage: cgImage)
        }
}

struct FilteredImage: Identifiable, Hashable {
    var id = UUID().uuidString
    var image: UIImage
    var filter: CIFilter?
}
struct CameraPreview: UIViewRepresentable{
    @ObservedObject var camera : cameraModel
    
    func makeUIView(context: Context) -> some UIView {
        let screenWidth = UIScreen.main.bounds.width
                let screenHeight = screenWidth * 5 / 4
                
        let x = (UIScreen.main.bounds.width - screenWidth) / 2.5
        let y = (UIScreen.main.bounds.height - screenHeight) / 2.5
                let frame = CGRect(x: x, y: y, width: screenWidth, height: screenHeight)
                
                let view = UIView(frame: frame)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        camera.session.sessionPreset = .photo
        
        camera.session.startRunning()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

class cameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    @Published var isTaken = false
    @Published var testTake = "no pic"
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    @Published var backCamera = false
    @Published var image: Image?
    @Published var uiimage: UIImage?
    @Published var flash = false
    

    @Published var filteredImage: FilteredImage?
    @Published var publishStoryView = false





    func check(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ (status) in
                if status{
                    self.setUp()
                }
            }
        case .restricted:
            AVCaptureDevice.requestAccess(for: .video){ (status) in
                if status{
                    self.setUp()
                }
            }
        case .denied:
            AVCaptureDevice.requestAccess(for: .video){ (status) in
                if status{
                    self.setUp()
                }
            }
        case .authorized:
            setUp()
            return
         default:
            return
        }
    }

    func setUp(){
        do{
            
            self.session.beginConfiguration()
                
            //Denna can strula beroende på camera
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
           let deviceFront = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        }catch{
            print(error.localizedDescription)
        }
    }


    //MARK: SWITCH CAMERA

    func switchCamera() {
        session.beginConfiguration()
        let currentInput = session.inputs.first as? AVCaptureDeviceInput
        session.removeInput(currentInput!)
        let newCameraDevice = currentInput?.device.position == .back ? getCamera(with: .front) : getCamera(with: .back)
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        session.addInput(newVideoInput!)
        session.commitConfiguration()
    }

    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        guard let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] else {
            return nil
        }
        
        return devices.filter {
            $0.position == position
            }.first
    }


    //MARK: FLASH

    func toggleTorch(on: Bool) {
        /*guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    try device.setTorchModeOn(level: 1.0)
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }*/
    }


    //MARK: TAKE PIC

    func takePic(){
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            
            if flash {
                
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: 1.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    device.torchMode = .off
                    
                    self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.82){
                    do{
                        
                        
                        
                        try device.setTorchModeOn(level: 1.0)
                        device.unlockForConfiguration()
                        
                        
                        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                            do {
                                try device.lockForConfiguration()
                                 device.torchMode = .off
                                 device.unlockForConfiguration()
                            }catch{}
                            
                        }*/
                       
                    } catch {
                        
                    }
                }
            
                
                
                
                
                
            } else {
                self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            }
            
            
        } catch {
            
        }
        
        
        /*DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.4) {
            
            
            
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                self.isTaken.toggle()
            }
            
            
        }*/
        
       
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if error != nil{
            self.testTake = "Error capturing photo: \(error?.localizedDescription)"
            return
        }
        
        
        self.session.stopRunning()
        self.isTaken.toggle()
        
        do {
            try device.lockForConfiguration()
            device.torchMode = .off
            device.unlockForConfiguration()
        }catch {}
        
        
        //self.testTake = "working"
        
        guard let imageData = photo.fileDataRepresentation() else { return }
       
        self.picData = imageData
        
        self.uiimage = UIImage(data: picData)
        
        if let uiimage = uiimage {
            self.filteredImage = FilteredImage(image: uiimage)
            self.image = Image(uiImage: uiimage)
        }
        
        
        
        
        
    }


    func reTake(){
        DispatchQueue.global(qos: .background).async {
            
            self.session.startRunning()
            
            DispatchQueue.main.async {
                self.isTaken.toggle()
            }
        }
    }



    func savePic(){
        
        
        
        
       // let image = UIImage(data: self.picData)
        if let image = filteredImage?.image{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        } else if let image = UIImage(data: self.picData){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
       
        
        
        
        self.isSaved = true
        
    }

    func uploadPic() {
        // Force-unwrap picData since you are certain it contains valid image data
        let image = UIImage(data: self.picData)

        // Call the upload functions
        
    }
    
    func updateFilter(to filter: CIFilter, remove: Bool = false) {
            guard let uiimage = uiimage else { return }
            let filteredUIImage = applyFilter(to: uiimage, using: filter, remove: remove)
            filteredImage = FilteredImage(image: filteredUIImage, filter: filter)
        }

        func applyFilter(to image: UIImage, using filter: CIFilter, remove: Bool = false) -> UIImage {
            let context = CIContext()
            guard let ciImage = CIImage(image: image) else { return image }
            
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            if remove {
                // If remove is true, return the original image without applying the filter
                //return image.rotated(by: 90) ?? image // Rotating back to the original orientation
                return image
            } else {
                // Apply the filter
                guard let outputImage = filter.outputImage,
                      let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
                
                let filteredUIImage = UIImage(cgImage: cgImage)
                
                // Rotate the filtered image back to the original orientation
                return filteredUIImage.rotated(by: 90) ?? filteredUIImage // Rotating by 270 degrees to correct the 90-degree rotation
            }
        }





}

//ROTATE
extension UIImage {
    func rotated(by angle: CGFloat) -> UIImage? {
        let radians = angle * (.pi / 180)
        var newSize = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        context.rotate(by: radians)
        
        self.draw(in: CGRect(
            x: -self.size.width / 2,
            y: -self.size.height / 2,
            width: self.size.width,
            height: self.size.height)
        )
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}


