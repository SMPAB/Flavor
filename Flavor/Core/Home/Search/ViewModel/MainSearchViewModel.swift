//
//  MainSearchViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import Foundation
import Firebase
class MainSearchViewModel: ObservableObject {
    @Published var usernames: [String] = []
    @Published var searchText = ""
    
    
    @Published var recommenderPosts: [Post] = []
    @Published var fetchingRecomended = false
    private var lastRecomendedSnapshot: DocumentSnapshot?
    
    @Published var trendingPosts: [Post] = []
    @Published var fetchingTrending = false
    private var lastTrending: DocumentSnapshot?
    
    func fetchUsersnames() async throws {
        self.usernames = try await UserService.fetchAllUsernamesNoLowercase()
    }
    
    func fetchRecomendedPosts() async throws {
        fetchingRecomended = true
        let (newRecomended, lastDocument) = try await PostService.fetchRecomendedPosts(lastDocument: lastRecomendedSnapshot)
        for i in 0..<newRecomended.count {
            if !recommenderPosts.contains(where: {$0.id == newRecomended[i].id}){
                recommenderPosts.append(newRecomended[i])
            }
        }
        lastRecomendedSnapshot = lastDocument
        fetchingRecomended = false
    }
    
    func fetchTrendingPosts() async throws {
        fetchingTrending = true
        let (newTrending, lastDocument) = try await PostService.fetchTrendingPosts(lastDocument: lastRecomendedSnapshot)
        for i in 0..<newTrending.count {
            if !trendingPosts.contains(where: {$0.id == newTrending[i].id}){
                trendingPosts.append(newTrending[i])
            }
        }
        lastRecomendedSnapshot = lastDocument
        fetchingTrending = false
    }
}
