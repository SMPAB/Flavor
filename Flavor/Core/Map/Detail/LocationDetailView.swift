//
//  LocationDetailView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-25.
//

import SwiftUI
import MapKit
import Iconoir
import Kingfisher

struct LocationDetailView: View {
    @StateObject var viewModel: LocationDetailVM
    @Namespace var namespace
    @EnvironmentObject var sceneController: SceneController
    
    init(MKMapItem: MKMapItem, mapVM: MapViewModel){
        self._viewModel = StateObject(wrappedValue: LocationDetailVM(selectedLocation: MKMapItem, mapVM: mapVM))
    }
    
    var MKItem: MKMapItem {
        return viewModel.selectedLocation
    }
    
    var location: Location? {
        return viewModel.location
    }
    @State private var locaroundScene: MKLookAroundScene?
    @State var triedFetchingLocaroundScene = false
    var body: some View {
        ZStack {
            ScrollView{
                VStack(spacing: 16){
                   
                    HStack(alignment: .top) {
                        VStack(alignment: .leading){
                            
                            
                                if let title = location?.name {
                                    if title != "" {
                                        Text(title)
                                            .font(.primaryFont(.H4))
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                    } else {
                                        Text(MKItem.placemark.name ?? "")
                                            .font(.primaryFont(.H4))
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                    }
                                } else {
                                    Text(MKItem.placemark.name ?? "")
                                        .font(.primaryFont(.H4))
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                }
                                
                            
                            
                            
                            
                            
                            
                            Text(MKItem.placemark.title ?? "")
                                .font(.primaryFont(.P2))
                                .foregroundStyle(Color(.systemGray))
                                .lineLimit(1)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            
                        
                        if let firstStory = viewModel.firstStory {
                            ImageView(size: .small, imageUrl: firstStory.imageUrl, background: true)
                                .onTapGesture {
                                    sceneController.showStorys = true
                                    sceneController.storyIds = location?.storyIds ?? []
                                    sceneController.hideOverlay = false
                                }
                        }
                        

                    }.padding(.horizontal, 16)
                    
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(height: 1)
                        .padding(.horizontal, 16)
                    
                    if let postIds = location?.postIds {
                        if !postIds.isEmpty {
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(postIds.prefix(5), id: \.self) { id in
                                        LocationDetailPostCell(postId: id, detailVM: viewModel)
                                            .environmentObject(sceneController)
                                            
                                    }
                                }.padding(.horizontal, 16)
                            }
                        }else {
                            if let scene = locaroundScene {
                                LookAroundPreview(initialScene: scene)
                                    .frame(height: 200)
                                    .cornerRadius(16)
                                    .padding()
                            } else {
                                if triedFetchingLocaroundScene {
                                    ContentUnavailableView("No preview Available", systemImage: "eye.slash")
                                }
                                
                            }
                        }
                       
                        
                    } else {
                        if let scene = locaroundScene {
                            LookAroundPreview(initialScene: scene)
                                .frame(height: 200)
                                .cornerRadius(16)
                                .padding()
                        } else {
                            if triedFetchingLocaroundScene {
                                ContentUnavailableView("No preview Available", systemImage: "eye.slash")
                            }
                            
                        }
                    }
                    
                   /* VStack(spacing: 8){
                        if let phoneNumber = MKItem.phoneNumber {
                            HStack(spacing: 8){
                                Iconoir.phone.asImage
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(Color(.systemGray))
                                
                                
                                Text(phoneNumber)
                                    .font(.primaryFont(.P2))
                                    .foregroundStyle(Color(.systemGray))
                                
                                Spacer()
                            }
                        }
                        
                        
                        if let link = MKItem.url {
                            HStack(spacing: 8){
                                Iconoir.link.asImage
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(Color(.systemGray))
                                    
                                
                                
                                Link(destination: link, label: {
                                    Text("\(link.absoluteString)")
                                        .underline()
                                        .font(.primaryFont(.P2))
                                        .foregroundStyle(Color(.systemGray))
                                })
                                  
                                Spacer()
                            }
                        }
                    }.padding(.horizontal, 16)*/
                    
                    VStack(spacing: 0){
                        
                        
                        
                        if let phoneNumber = MKItem.phoneNumber {
                            Link(destination: URL(string:"tel:\(phoneNumber)")! ){
                                HStack{
                                    Iconoir.phone.asImage
                                    
                                    
                                    VStack(alignment: .leading){
                                        Text("Call")
                                            .font(.primaryFont(.P1))
                                        
                                        Text(phoneNumber)
                                            .font(.primaryFont(.P2))
                                            .foregroundStyle(Color(.systemGray))
                                    }
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(.black)
                            }
                            
                            Divider()
                                .padding(.vertical, 16)
                        }
                        
                        //Website
                        if let link = MKItem.url {
                            Link(destination: link){
                                HStack{
                                    Iconoir.globe.asImage
                                    
                                    
                                    VStack(alignment: .leading){
                                        Text("Go to website")
                                            .font(.primaryFont(.P1))
                                        
                                        Text(link.relativeString)
                                            .font(.primaryFont(.P2))
                                            .foregroundStyle(Color(.systemGray))
                                            .lineLimit(1)
                                    }
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(.black)
                            }
                            
                            Divider()
                                .padding(.vertical, 16)
                        }
                        
                        
                        HStack{
                            Iconoir.mapPin.asImage
                            
                            
                            VStack(alignment: .leading){
                                Text("Open in apple maps")
                                    .font(.primaryFont(.P1))
                                
                                Text(MKItem.placemark.title ?? "")
                                    .font(.primaryFont(.P2))
                                    .foregroundStyle(Color(.systemGray))
                                    .lineLimit(1)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.black)
                            .onTapGesture {
                                MKItem.openInMaps()
                            }
                        
                    }.padding()
                        .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.colorWhite)
                            .shadow(radius: 5)
                            .opacity(0.3)
                        )
                    
                        .padding(.horizontal, 16)
                    
                    
                    
                    
                    
                }.padding(.top, 16)
                    
            }.padding(.bottom, 40)
            
            if let post = viewModel.selectedPost {
                ZStack{
                    Color.black.opacity(0.5)
                    
                    if let post = viewModel.selectedPost {
                        if let imageUrls = post.imageUrls{
                            KFImage(URL(string: imageUrls[0]))
                                .resizable()
                                .scaledToFill()
                                .matchedGeometryEffect(id: post.id, in: namespace)
                                .frame(width: 300, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .contentShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }.onTapGesture{
                    withAnimation{
                        viewModel.showPosts = false
                        viewModel.selectedPost = nil
                    }
                }
            }
            
        }.onFirstAppear{
            
            Task {
                fetchLookaroundPreview()
                try await viewModel.fetchLocation()
            }
            print("DEBUG APP ID: \(viewModel.getIdentifier(for: MKItem))")
    }
        
    }
    
    
    
    func fetchLookaroundPreview() {
        
        locaroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: MKItem)
            locaroundScene = try? await request.scene
            triedFetchingLocaroundScene = true
            print("DEBUG APP FETCHED LOOKAROUND SCENE: \(locaroundScene)")
        }
    }
}

#Preview {
    LocationDetailView(MKMapItem: MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: 73.123129312, longitude: 72.2139123))), mapVM: MapViewModel())
}
