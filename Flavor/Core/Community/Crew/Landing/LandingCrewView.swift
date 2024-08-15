//
//  LandingCrewView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-19.
//

import SwiftUI
import Kingfisher
import Iconoir

struct LandingCrewView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @StateObject var viewModel = LandingCrewViewModel()
    @State var createCrew = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8){
                Text("My crews")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                Text("You have ")
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
                
               + Text("\(viewModel.crews.count) crews")
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
                
                
                Button(action: {
                    createCrew.toggle()
                }){
                    Text("Create Crew +")
                        .font(.primaryFont(.P1))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.clear)
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .foregroundStyle(Color(.systemGray))
                        )
                }.foregroundStyle(Color(.systemGray))
                
                ForEach(viewModel.crews){ crew in
                    NavigationLink(destination:
                                    MainCrewView(crew: crew, landingVM: viewModel)
                        .environmentObject(homeVM)
                    ) {
                        HStack(spacing: 16){
                            ImageView(size: .medium, imageUrl: crew.imageUrl, background: false)
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text(crew.crewName)
                                    .font(.primaryFont(.H4))
                                    .fontWeight(.semibold)
                                
                                HStack{
                                    
                                    HStack(spacing: 2){
                                        Iconoir.community.asImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 16, height: 16)
                                        
                                        Text("\(crew.uids.count) members")
                                    }
                                    
                                    
                                    HStack(spacing: 2){
                                        Iconoir.globe.asImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 16, height: 16)
                                        
                                        Text("\(crew.publicCrew ? "Public" : "Private")")
                                    }
                                    
                                    
                                }.foregroundStyle(Color(.systemGray))
                                    .font(.primaryFont(.P2))
                                
                                
                            }
                            
                            
                            Spacer()
                            
                            Text("3")
                                .font(.primaryFont(.P2))
                                .foregroundStyle(.colorWhite)
                                .frame(width: 24, height: 24)
                                .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.colorOrange)
                                )
                        }.padding(16)
                            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.clear)
                                .stroke(Color(.systemGray4))
                        )
                    }
                }
                
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color(.systemGray))
                    .frame(height: 1)
                    .padding(.vertical, 8)
                    
                
                
                Text("Join other crews!")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                Text("Find people with similar interests")
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
                
            }.padding(.horizontal, 16)
            
            .onFirstAppear {
                Task{
                    try await viewModel.fetchCrews()
                }
        }
        }.fullScreenCover(isPresented: $createCrew){
            CreateCrewView(currentUser: homeVM.user, landingVM: viewModel)
                .environmentObject(homeVM)
        }
    }
}

#Preview {
    LandingCrewView()
}
