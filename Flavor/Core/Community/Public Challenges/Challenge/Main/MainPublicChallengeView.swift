//
//  MainPublicChallengeView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-10.
//

import SwiftUI
import Iconoir
import Kingfisher

struct MainPublicChallengeView: View {
    
    @StateObject var viewModel: MainPublicChallengeVM
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State var showPublish = false
    
    @State var showYourContribution = false
    
    @Namespace var namespace
    
    @State var showLeave = false
    
    init(challenge: PublicChallenge, landingVM: LandingPublicChallengesViewModel) {
        self._viewModel = StateObject(wrappedValue: MainPublicChallengeVM(challenge: challenge, landingVM: landingVM))
    }
    
    var challenge: PublicChallenge {
        return viewModel.challenge
    }
    
    var prizes: [prize] {
        return viewModel.challenge.prizes ?? []
    }
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        ZStack {
            ScrollView {
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
                            withAnimation{
                                showLeave.toggle()
                            }
                        }) {
                            Text("Leave")
                                .font(.primaryFont(.P2))
                                .foregroundStyle(.black)
                        }
                    }.padding(.horizontal, 16)
                    
                    HStack(alignment: .top, spacing: 16){
                        ImageView(size: .medium, imageUrl: challenge.ownerImageUrl, background: false)
                        
                        VStack(alignment: .leading){
                            Text(challenge.title)
                                .font(.primaryFont(.H4))
                                .fontWeight(.semibold)
                            
                            Text(challenge.description)
                                .font(.primaryFont(.P2))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Deadline: \(challenge.endDate.dateValue().formattedChallengeCell())")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                        }
                    }.padding(.horizontal, 16)
                    
                    HStack{
                        Text("Status:")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        if challenge.userDoneVoting == true {
                            
                            HStack(spacing: 4){
                                Text("Voted")
                                    .font(.primaryFont(.P1))
                                
                                Iconoir.checkCircle.asImage
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }.foregroundStyle(Color(.systemGreen))
                            
                        } else {
                            HStack(spacing: 4){
                                Text("Voted")
                                    .font(.primaryFont(.P1))
                                
                                Iconoir.xmarkCircle.asImage
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }.foregroundStyle(Color(.systemRed))
                        }
                        
                        if challenge.userHasPublished == true {
                            HStack(spacing: 4){
                                Text("Published")
                                    .font(.primaryFont(.P1))
                                
                                Iconoir.checkCircle.asImage
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }.foregroundStyle(Color(.systemGreen))
                        } else {
                            HStack(spacing: 4){
                                Text("Published")
                                    .font(.primaryFont(.P1))
                                
                                Iconoir.xmarkCircle.asImage
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }.foregroundStyle(Color(.systemRed))
                        }
                        
                        Spacer()
                    }.padding(.horizontal, 16)
                    
                    
                    VStack(alignment: .leading){
                        Text("Prices:")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        if prizes.count > 0 {
                            Text("🥇\(prizes[0].prizeName)")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                        }
                        
                        if prizes.count > 1 {
                            Text("🥈\(prizes[1].prizeName)")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                        }
                    
                        if prizes.count > 2 {
                            Text("🥉\(prizes[2].prizeName)")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                        }
                    }.padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(height: 1)
                        .padding(.horizontal, 16)
                    
                    if viewModel.userPost == nil {
                        HStack{
                            Button(action: {
                                showPublish.toggle()
                            }) {
                                VStack (alignment: .leading){
                                    Text("Don't forget to pubish!")
                                        .font(.primaryFont(.P2))
                                        .foregroundStyle(.black)
                                        .fontWeight(.semibold)
                                    
                                    Iconoir.plus.asImage
                                        .foregroundStyle(Color(.systemGray))
                                        .frame(width: 80, height: 80)
                                        .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.clear)
                                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                            .foregroundStyle(Color(.systemGray))
                                        )
                                        
                                        
                                }
                            }
                            
                            Spacer()
                        }.padding(.horizontal, 16)
                            .padding(.top, 8)
                        
                    } else {
                        HStack{
                            VStack(alignment: .leading){
                                Text("Your contribution")
                                    .font(.primaryFont(.P2))
                                    .foregroundStyle(.black)
                                    .fontWeight(.semibold)
                                
                                if let post = viewModel.userPost {
                                    KFImage(URL(string: post.imageUrl ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        
                                        .frame(width: 80, height: 80)
                                        .matchedGeometryEffect(id: "post", in: namespace)
                                        .contentShape(RoundedRectangle(cornerRadius: 4))
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }
                                
                                
                            }.onTapGesture{
                                withAnimation{
                                    showYourContribution.toggle()
                                }
                            }
                            
                            Spacer()
                        }.padding(.horizontal, 16)
                    }
                    
                    
                    HStack{
                        Text("Published")
                            .font(.primaryFont(.H4))
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }.padding(.horizontal, 16)
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 8), count: 2)){
                        
                       /*
                        if let post = homeVM.newPublicChallengePosts.first(where: {$0.challengeId == viewModel.challenge.id}){
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
                                     
                                     ZStack(alignment: .bottomLeading){
                                         KFImage(URL(string: imageurl))
                                             .resizable()
                                             .scaledToFill()
                                             .frame(width: (width - 40)/2, height: (width - 40)/2)
                                             .clipShape(RoundedRectangle(cornerRadius: 8))
                                             .contentShape(RoundedRectangle(cornerRadius: 8))
                                         
                                         /*if viewModel.votes.contains(post.id) {
                                             Text("Your vote")
                                                 .font(.primaryFont(.P2))
                                                 .fontWeight(.semibold)
                                                 .foregroundStyle(Color(.systemGreen))
                                                 .padding(8)
                                         }*/
                                     }
                                     
                                         
                                 }  else {
                                     RoundedRectangle(cornerRadius: 8)
                                         .fill(Color(.systemGray6))
                                         .frame(width: (width - 40)/2, height: (width - 40)/2)
                                 }
                             }.foregroundStyle(.black)
                         }*/
                        
                        
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
                                            
                                            ZStack(alignment: .topTrailing){
                                                KFImage(URL(string: imageurl))
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: (width - 40)/2, height: (width - 40)/2)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                                    .contentShape(RoundedRectangle(cornerRadius: 8))
                                                    .shadow(color: viewModel.votes.contains(post.id) ? .colorOrange : .colorWhite, radius: 2)
                                                
                                                if viewModel.userPost?.id == post.id {
                                                    ZStack{
                                                        Circle()
                                                            .fill(Color(.systemGreen))
                                                             .frame(width: 24, height: 24)
                                                        
                                                        Iconoir.user.asImage
                                                            .resizable()
                                                            .frame(width: 16, height: 16)
                                                            .foregroundStyle(.colorWhite)
                                                    }.padding(8)
                                                   
                                                }
                                            }
                                            
                                                
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
                                    
                                    if challenge.finished != true {
                                        viewModel.selectedPost = post.id
                                        
                                        viewModel.showVoteView.toggle()
                                    } else {
                                        withAnimation(.spring){
                                            homeVM.selectedChallengePost = post
                                        }
                                        
                                    }
                                }
                               
                                
                                
                                
                            }
                        }
                    }
                    
                    
                }
            }.onFirstAppear {
                Task {
                    try await viewModel.fetchPosts()
                    try await viewModel.fetchUserPost(homeVM: homeVM)
                    try await viewModel.fetchVotes()
                }
            }
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(isPresented: $showPublish, content: {
                LandingCameraView(story: .constant(true))
                    .environmentObject(homeVM)
            })
            .onChange(of: homeVM.newPublicChallengePosts) {
                Task {
                    if let post = homeVM.newPublicChallengePosts.last {
                        viewModel.updateNewPost(post: post, homeVM: homeVM)
                        homeVM.newPublicChallengePosts = []
                    }
                    
                }
        }
            
            
            if viewModel.showVoteView {
                PublicVoteView()
                    .environmentObject(viewModel)
                    .environmentObject(homeVM)
                    .background(
                    Rectangle()
                        .fill(.white)
                    )
            }
            
            
            if showYourContribution {
                ZStack(alignment: .top){
                    Color.black.ignoresSafeArea(.all)
                    VStack{
                        HStack{
                            Button(action: {
                                withAnimation(.linear(duration: 0.1)) {
                                    showYourContribution.toggle()
                                }
                            }){
                                Iconoir.xmark.asImage
                                    .foregroundStyle(.colorWhite)
                            }
                            
                            Spacer()
                            
                            Text("Your post")
                                .font(.primaryFont(.H4))
                                .fontWeight(.semibold)
                                .foregroundStyle(.colorWhite)
                            
                            Spacer()
                            
                            Iconoir.xmark.asImage
                                .opacity(0)
                        }
                        
                        KFImage(URL(string: viewModel.userPost?.imageUrl ?? ""))
                            .resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: "post", in: namespace)
                        
                        HStack{
                            Text("\(viewModel.userPost?.votes ?? 0) votes")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }.padding(.horizontal, 16)
                            .foregroundStyle(.colorWhite)
                        
                        CustomButton(text: "Delete", textColor: .colorWhite, backgroundColor: Color(.systemRed), strokeColor: Color(.systemRed), action: {
                            withAnimation{
                                viewModel.deletePost = viewModel.userPost
                                viewModel.showDeletePost.toggle()
                            }
                        }).padding(.horizontal, 16)
                        
                        Spacer()
                    }
                    
                }.onTapGesture {
                    withAnimation(.linear(duration: 0.1)){
                        showYourContribution.toggle()
                    }
                }
                .customAlert(isPresented: $viewModel.showDeletePost, title: nil, message: "Are you sure you want to delete your post?", boldMessage: nil, afterBold: nil, confirmAction: {
                    
                        Task{
                            
                            try await viewModel.deletePost(homeVM: homeVM)
                            
                            homeVM.newPublicChallengePosts = []
                            withAnimation{
                                showYourContribution.toggle()
                                viewModel.showVoteView = false
                                viewModel.showDeletePost = false
                            }
                    }
                }, cancelAction: {
                    withAnimation{
                        viewModel.showDeletePost = false
                    }
                    
                }, imageUrl: viewModel.deletePost?.imageUrl, dismissText: "Cancel", acceptText: "Delete")
               
                
            }
        } .customAlert(isPresented: $showLeave, title: nil, message: "Are you sure you want to leave the challenge, if you have posted the post will be deleted!", boldMessage: nil, afterBold: nil, confirmAction: {
            Task{
                try await viewModel.leaveChallenge(homeVM: homeVM)
                dismiss()
                showLeave.toggle()
            }
            
        }, cancelAction: {
            showLeave.toggle()
        }, imageUrl: nil, dismissText: "Cancel", acceptText: "Leave")
        
    }
}

#Preview {
    MainPublicChallengeView(challenge: PublicChallenge.mockChallenges[0], landingVM: LandingPublicChallengesViewModel())
}
