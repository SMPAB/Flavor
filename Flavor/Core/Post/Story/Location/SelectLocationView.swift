//
//  SelectLocationView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-30.
//

import SwiftUI
import MapKit
import Iconoir

struct SelectLocationView: View {
    
    @Binding var selectedLocation: MKMapItem?
    @Binding var selectedLocationTitle: String?
    @StateObject var viewModel = SelectLocationVM()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack{
                
                Button(action: {
                    dismiss()
                    //viewModel.showSearch.toggle()
                }){
                    Text("Avbryt")
                        .foregroundStyle(.black)
                        .font(.primaryFont(.P1))
                }
            Spacer()
                
                Text("Platser")
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
            }
            .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
            
                .padding(.horizontal, 16)
            
            
            ScrollView{
                ForEach(viewModel.results.filter({viewModel.containsNumber($0.subtitle)}), id: \.self) { result in
                    
                   
                        MapSearchCell(Title: result.title, subTitle: result.subtitle)
                            .onTapGesture {
                                viewModel.queryFragment = result.title
                                viewModel.selectLocation(result)
                                selectedLocationTitle = result.title
                                //viewModel.showSearch.toggle()
                            }
                    
                    
                }
            }
           
        }.onChange(of: viewModel.selectedMKItem){
            if let mkItem = viewModel.selectedMKItem {
                selectedLocation = mkItem
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SelectLocationView(selectedLocation: .constant(nil), selectedLocationTitle: .constant(nil))
}
