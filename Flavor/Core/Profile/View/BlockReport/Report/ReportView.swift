//
//  ReportView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var reportText = ""
    var body: some View {
        VStack{
            
            HStack{
                
                Button(action: {
                    
                }){
                    Text("Cancel")
                        .font(.primaryFont(.P1))
                }
                
                Spacer()
                
                Text("Report @\(viewModel.user.userName)")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Cancel")
                    .opacity(0)
            }.padding(.horizontal, 16)
            
            
            Divider()
            
            
            Text("Tell us more:")
                .font(.primaryFont(.P1))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            
            TextField("Write here...", text: $reportText, axis: .vertical)
                .padding(8)
                .font(.primaryFont(.P2))
                .frame(maxWidth: .infinity)
                .frame(height: 100, alignment: .top)
                .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.clear)
                    .stroke(Color(.systemGray))
                )
                .padding(.horizontal, 16)
                
            CustomButton(text: "Report", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: .colorOrange, action: {
                Task{
                    try await viewModel.report(reportText: reportText)
                    dismiss()
                }
                
            })
            .padding(.horizontal, 16)
            .padding(.top, 8)
            Spacer()
        }
    }
}

#Preview {
    ReportView()
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}
