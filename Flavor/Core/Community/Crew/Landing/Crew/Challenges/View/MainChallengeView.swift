//
//  MainChallengeView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-21.
//

import SwiftUI
import Iconoir
import Kingfisher
import Firebase

struct MainChallengeView: View {
    
    
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ChallengeViewModel
    
    @State var showTakePhoto = false
    @State var showEdit = false
    
    
    init(challenge: Challenge){
        self._viewModel = StateObject(wrappedValue: ChallengeViewModel(challenge: challenge))
    }
    
    
    
    var challenge: Challenge{
        return viewModel.challenge
    }
    
    //private let gridItems: [GridItem] = Array(repeating: .init(.flexible(), spacing: 8), count: 2)

    var body: some View {
        
        let width = UIScreen.main.bounds.width
        ZStack{
            ScrollView{
                VStack{
                    HStack{
                        Button(action: {
                            dismiss()
                        }){
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showEdit.toggle()
                        }){
                            Iconoir.settings.asImage
                                .foregroundStyle(.black)
                        }
                        
                    }.padding(.horizontal, 16)
                    
                    
                    VStack(spacing: 8){
                        HStack(spacing: 8){
                            ImageView(size: .medium, imageUrl: challenge.imageUrl, background: true)
                            
                            VStack(alignment: .leading){
                                Text(challenge.title)
                                    .font(.primaryFont(.H4))
                                    .fontWeight(.semibold)
                                
                                Text(challenge.description)
                                    .font(.primaryFont(.P1))
                                    
                                
                                Text("Deadline: \(challenge.endDate.dateValue().formattedChallengeCell())")
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                                
                            }.frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        
                        HStack{
                            Iconoir.check.asImage
                            
                            Text("\(challenge.completedUsers.count) members done")
                                .font(.primaryFont(.P2))
                            
                            Rectangle()
                                .fill(Color(.systemGray))
                                .frame(width: 1, height: 24)
                            
                            
                            Iconoir.hourglass.asImage
                            
                            Text("\(challenge.users.count - challenge.completedUsers.count) members left")
                                .font(.primaryFont(.P2))
                            
                            Spacer()
                        }
                        
                    }.padding(.horizontal, 16)
                    
                    
                    HStack{
                        
                    }.padding(.vertical, 8)
                    
                    HStack{
                        Text("Published")
                            .fontWeight(.semibold)
                            .font(.primaryFont(.H4))
                        
                        Spacer()
                    }.padding(.horizontal, 16)
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 8), count: 2)){
                        
                        if !viewModel.challenge.completedUsers.contains(Auth.auth().currentUser?.uid ?? "") {
                            
                            Button(action: {
                                showTakePhoto.toggle()
                            }){
                                VStack{
                                    HStack{
                                        Text("Don't forgett to publish")
                                            .font(.primaryFont(.P2))
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                    }
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.white))
                                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                            .frame(width: (width - 40)/2, height: (width - 40)/2)
                                        
                                        Iconoir.plus.asImage
                                            .foregroundStyle(.black)
                                    }
                                   
                                    
                                }.frame(width: (width - 40)/2)
                                    .foregroundStyle(.black)
                            }
                            
                        }
                        
                        if !viewModel.challengePosts.isEmpty{
                            ForEach(viewModel.challengePosts.sorted(by: {$0.votes > $1.votes})) { post in
                                
                                
                                    VStack{
                                        
                                        if let user = post.user {
                                            HStack{
                                                Text("@\(user.userName)")
                                                    .font(.primaryFont(.P2))
                                                    .fontWeight(.semibold)
                                                
                                                
                                                Spacer()
                                                
                                                Text("\(post.votes)")
                                                    .font(.primaryFont(.P2))
                                                    .fontWeight(.semibold)
                                            }.frame(width: (width - 40)/2)
                                        } else {
                                            
                                            HStack{
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(.systemGray6))
                                                    .frame(width: 100, height: 10)
                                                
                                                Spacer()
                                            }
                                            
                                        }
                                        if let imageurl = post.imageUrl{
                                            
                                           
                                            KFImage(URL(string: imageurl))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: (width - 40)/2, height: (width - 40)/2)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .contentShape(RoundedRectangle(cornerRadius: 8))
                                                
                                        }  else {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(.systemGray6))
                                                .frame(width: (width - 40)/2, height: (width - 40)/2)
                                        }
                                    }.foregroundStyle(.black)
                                .onFirstAppear {
                                    if viewModel.challengePosts.last?.id == challenge.id {
                                        Task{
                                            try await viewModel.fetchPosts()
                                        }
                                    }
                                }
                                .onTapGesture {
                                    viewModel.selectedPost = post.id
                                    print("DEBUG APP SELECTED POST: \(viewModel.selectedPost)")
                                    viewModel.showVoteView.toggle()
                                }
                               
                                
                                
                                
                            }
                        }
                        
                        
                        if viewModel.fetchingPosts {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                                .frame(width: (width - 40)/2, height: (width - 40)/2)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                                .frame(width: (width - 40)/2, height: (width - 40)/2)
                        }
                    }.padding(.horizontal, 16)
                }
            }.navigationBarBackButtonHidden(true)
            
            .onFirstAppear {
                Task{
                    try await viewModel.fetchPosts()
                }
            }
            
            if viewModel.showVoteView {
                MainVoteView()
                    .environmentObject(viewModel)
                    .environmentObject(homeVM)
                    //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(
                    Rectangle()
                        .fill(.white)
                    )
            }
        }.onFirstAppear {
            Task{
                try await viewModel.fetchVotes()
            }
        }
        .fullScreenCover(isPresented: $showTakePhoto){
            LandingCameraView(story: .constant(true))
                .environmentObject(homeVM)
        }
        .fullScreenCover(isPresented: $showEdit){
            EditChallengeView()
                .environmentObject(viewModel)
        }
    }
}
/*
#Preview {
    MainChallengeView()
}*/
