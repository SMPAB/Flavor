//
//  VariableView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI

struct VariableView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var scrollToSelected = false

    var body: some View {
        VStack (spacing: 8){
            
            HStack{
                               Button(action: {
                                   dismiss()
                                   homeVM.showVariableView = false
                                   homeVM.variablesTitle = ""
                                   homeVM.variableSubTitle = nil
                                   
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                       homeVM.variableUplaods = []
                                   }
                                   
                               }){
                                   Image(systemName: "chevron.left")
                                       .foregroundStyle(.black)
                               }
                               
                               Spacer()
                               
                               VStack{
                                   
                                   if let subtitle = homeVM.variableSubTitle{
                                       Text(subtitle)
                                           .font(.primaryFont(.P1))
                                           .foregroundStyle(Color(.systemGray))
                                   }
                                   Text(homeVM.variablesTitle)
                                       .font(.primaryFont(.P1))
                                       .fontWeight(.semibold)
                                       
                               }
                               
                               Spacer()
                               
                               Image(systemName: "chevron.left")
                                   .opacity(0)
                           }.padding(.horizontal, 16)
            
            Divider()
            
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 8) {
                        

                       

                        // List of uploads
                        LazyVStack(spacing: 32) {
                            ForEach(homeVM.variableUplaods.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()}).indices, id: \.self) { index in
                                FeedCell(post: homeVM.variableUplaods[index])
                                    .frame(width: UIScreen.main.bounds.width - 32)
                                    .environmentObject(homeVM)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white)
                                            .shadow(color: Color.orange, radius: 3)
                                            .opacity(0.2)
                                    )
                                    .padding(.horizontal, 16)
                                    .id(index) // Set an id for each FeedCell
                            }
                        }
                        .padding(.top, 16)
                        .onChange(of: scrollToSelected) { scrollToSelected in
                            if scrollToSelected {
                                DispatchQueue.main.async {
                                    if let selectedIndex = homeVM.variableUplaods.firstIndex(where: { $0.id == homeVM.selectedVariableUploadId }) {
                                        
                                            proxy.scrollTo(selectedIndex, anchor: .top)
                                        
                                    }
                                }
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        scrollToSelected = true
                        // Reset selectedUploadId when VariableView appears
                        //homeVM.selectedUploadId = nil
                    }
                }
            }
        }.onChange(of: homeVM.deletedPost){ newValue in
            dismiss()
        }
    }
}



#Preview {
    VariableView()
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
