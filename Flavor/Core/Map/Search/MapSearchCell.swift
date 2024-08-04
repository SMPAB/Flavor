//
//  MapSearchCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-23.
//

import SwiftUI

struct MapSearchCell: View {
    
    let Title: String
    let subTitle: String
    var body: some View {
        HStack{
            /*Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundStyle(Color(.systemBlue))
                .accentColor(.colorWhite)
                .frame(width: 40, height: 40)*/
            
            VStack(alignment: .leading, spacing: 4){
                Text(Title)
                    .font(.primaryFont(.P1))
                
                Text(subTitle)
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.frame(height: 50, alignment: .top)
            .padding(.horizontal, 16)
    }
}

#Preview {
    MapSearchCell(Title: "StarBucks", subTitle: "häradsvägen 95a")
}
