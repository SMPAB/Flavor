//
//  ReportStory.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-04.
//

import SwiftUI

struct ReportStory: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State var text = ""
    let story: Story
    
    var body: some View {
        ScrollView{
            HeaderMain(action: {
                Task {
                    try await homeVM.reportStory(story, text: text)
                    dismiss()
                }
            }, cancelText: "Cancel", title: "Report Story", actionText: "Report").padding(.horizontal, 16)
            
            Divider()
            
            VStack(alignment: .leading){
                Text("Tell us more")
                    .font(.primaryFont(.P1))
                    .fontWeight(.semibold)
                
                CustomTextField(text: $text, textInfo: "Write about the report...", secureField: false, multiRow: true, search: false)
            }.padding(.horizontal, 16)
            
            
            
        }
    }
}
/*
#Preview {
    ReportStory()
}*/
