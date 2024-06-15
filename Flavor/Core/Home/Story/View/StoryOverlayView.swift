//
//  StoryOverlayView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-14.
//

import SwiftUI


struct StoryOverlayView: View {
    
    //let user: User
    
    @EnvironmentObject var storyVM: HomeViewModel
    
    @State var moveTabBar = false
    
    var body: some View {
        
        TabView(selection: $storyVM.selectedStoryUser){
            ForEach($storyVM.storyUsers) { $user in
                GeometryReader { proxy in
                    ZStack {
                        ScrollView(showsIndicators: false){
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack (alignment: .top, spacing: 16){
                                    
                                    ForEach(storyVM.storyUsers){ storyUser in
                                        
                                        ImageView(size:  (storyUser.id == storyVM.selectedStoryUser) ? .xlarge : .medium, imageUrl: storyUser.profileImageUrl, background: (storyUser.seenStory ?? false && storyVM.selectedStoryUser != storyUser.id) ? false : true)
                                            .opacity((storyUser.seenStory ?? false && storyVM.selectedStoryUser != storyUser.id) ? 0.7 : 1)
                                            .onTapGesture {
                                                withAnimation{
                                                    storyVM.selectedStoryUser = storyUser.id
                                                    
                                                }
                                            }
                                    }
                                }.frame(height: 140)
                                    .padding(.leading, 16)
                            }.padding(.bottom, 5)
                                .frame(height: 140)
                                
                            HStack{
                                NavigationLink(destination: Text("\(user.userName)")){
                                    Text("@\(user.userName)")
                                        .font(.custom("HankenGrotesk-Regular", size: 18))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black)
                                }
                                
                                
                                Spacer()
                                
                                Text("\(user.streak ?? 0) day streak")
                                    .font(.custom("HankenGrotesk-Regular", size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color(.systemGray))
                            }.padding(.horizontal)
                            
                            Divider()
                            
                            let today = Calendar.current.startOfDay(for: Date())
                                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

                            let storiesToday = user.storys?.filter { Calendar.current.isDate($0.timestamp.dateValue(), inSameDayAs: Date()) }
                            let storiesYesterday = user.storys?.filter { Calendar.current.isDate($0.timestamp.dateValue(), inSameDayAs: yesterday) }
                           
                            if !(storiesToday?.isEmpty ?? [].isEmpty){
                                VStack(spacing: 16){
                                    Text("\(today.toFormattedString()) (Today)")
                                        .font(.primaryFont(.P1))
                                        .fontWeight(.semibold)
                                    
                                    ForEach(Array(storiesToday!.enumerated()), id: \.element.id) { index, story in
                                        StoryCell(story: story, oddStory: index % 2 != 0)
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                            
                            if !(storiesYesterday?.isEmpty ?? [].isEmpty){
                                VStack(spacing: 16){
                                    Text("\(yesterday.toFormattedString()) (Yesterday)")
                                        .font(.primaryFont(.P1))
                                        .fontWeight(.semibold)
                                    
                                    ForEach(Array(storiesYesterday!.enumerated()), id: \.element.id) { index, story in
                                        StoryCell(story: story, oddStory: index % 2 != 0)
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                            
                            /*if let storys = user.storys {
                                if !storys.isEmpty {
                                    ForEach(Array(storys.enumerated()), id: \.element.id) { index, story in
                                        
                                       
                                        StoryCell(story: story, oddStory: index % 2 != 0)
                                            .environmentObject(storyVM)
                                            .padding(.horizontal, 16)
                                            .onAppear{
                                                print("DEBUG APP STORIES TODAY COUNT: \(storiesToday?.count)")
                                                
                                                print("DEBUG APP STORIES YESTERDAY COUNT: \(storiesYesterday?.count)")
                                            }
                                    }
                                }
                            }*/
                        }.background(.colorWhite)
                            .refreshable(){
                                storyVM.showStory = false
                            }
                        
                    }.onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            Task{ 
                                try await  storyVM.fetchStorysForUser()
                                try await storyVM.storySeen()
                            }
                        }
                        
                    }
                    
                    
                    
                    .rotation3DEffect(
                        getAngle(proxy: proxy),
                        axis: (x: 0, y: 1, z: 0),
                        anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                        perspective: 2.5
                        
                )
                }
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.colorWhite)
            .onAppear{
                UIScrollView.appearance().isScrollEnabled = false
            }
        
        
            
    }
    
    func updateStory(forward: Bool = true, user: User){
        if !forward {
            if let first = storyVM.storyUsers.first,first.id != user.id {
                
                let storyIndex = storyVM.storyUsers.firstIndex { currentStory in
                    return user.id == currentStory.id
                } ?? 0
                
                withAnimation{
                    storyVM.selectedStoryUser = storyVM.storyUsers[storyIndex - 1].id
                    
                }
            }
            
            return
        }

            if let lastStory = storyVM.storyUsers.last,lastStory.id == user.id{
                storyVM.showStory = false
            } else {
                let storyIndex = storyVM.storyUsers.firstIndex{ currentStory in
                    return user.id == currentStory.id
                } ?? 0
                withAnimation{
                    storyVM.selectedStoryUser = storyVM.storyUsers[storyIndex + 1].id
                    
                }
                
            }
        
    }
    
    func getAngle(proxy: GeometryProxy)->Angle{
        
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        
        let rotationAngle: CGFloat = 45
        let degrees = rotationAngle * progress
        
        
        return Angle(degrees: Double(degrees))
        
    }
}

#Preview {
    //StoryOverlayView(user: User.MOCK_USER[0])
    Tabview(user: User.mockUsers[0], authService: AuthService())
}
