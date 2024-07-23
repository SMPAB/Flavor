//
//  UserFeedView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-23.
//

import SwiftUI

struct UserFeedView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    
    var body: some View {
        ForEach(viewModel.feedPosts) { post in
            
        }
    }
}

#Preview {
    UserFeedView()
}
