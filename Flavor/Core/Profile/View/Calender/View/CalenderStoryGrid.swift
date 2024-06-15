//
//  CalenderStoryGrid.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-15.
//

import SwiftUI

struct CalenderStoryGrid: View {
    @Binding var date: Date
    @EnvironmentObject var profileVM: ProfileViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CalenderStoryGrid(date: .constant(Date()))
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}
