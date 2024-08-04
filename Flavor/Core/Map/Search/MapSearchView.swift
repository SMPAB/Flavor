//
//  MapSearchView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-23.
//

import SwiftUI
import Iconoir

struct MapSearchView: View {
    
    
    @EnvironmentObject var viewModel: MapViewModel
    var body: some View {
        VStack {
            HStack{
                
                Button(action: {
                    viewModel.showSearch.toggle()
                }){
                    Text("Avbryt")
                        .foregroundStyle(.black)
                        .font(.primaryFont(.P1))
                }
            Spacer()
                
                Text("Locations")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Avbryt")
                    .opacity(0)
            }.padding(.horizontal, 16)
            
            Divider()
            
            HStack{
                Iconoir.search.asImage
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color(.systemGray))
                
                TextField("Search...", text: $viewModel.queryFragment)
                    .font(.primaryFont(.P1))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                
                
                Button(action: {
                    viewModel.queryFragment = " "
                }){
                    Iconoir.xmark.asImage
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color(.systemGray))
                        .frame(width: 24, height: 24)
                }
                
                    
            }
            .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
            
                .padding(.horizontal, 16)
            
            
            ScrollView{
                ForEach(viewModel.results, id: \.self) { result in
                    MapSearchCell(Title: result.title, subTitle: result.subtitle)
                        .onTapGesture {
                            viewModel.queryFragment = result.title
                            viewModel.selectLocation(result)
                            viewModel.showSearch.toggle()
                        }
                }
            }
           
        }
    }
}

#Preview {
    MapSearchView()
}
