//
//  RecipeViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-19.
//

import Foundation

class RecipeViewModel: ObservableObject {
    private let recipeId: String
    @Published var recipe: Recipe?
    
    init(recipeId: String) {
        self.recipeId = recipeId
    }
    
    func fetchRecipe() async throws {
        self.recipe = try await PostService.fetchRecipe(recipeId: recipeId)
    }
    
    func checkIfUserSavedRecipe() async throws {
        if let recipe = recipe {
            self.recipe?.isSaved = try await PostService.checkIfUserSavedRecipe(recipeId: recipeId)
        }
    }
    
    func save() async throws {
        do {
            self.recipe?.isSaved = true
            try await PostService.saveRecipe(recipeId: recipeId)
        } catch {
            return
        }
        
    }
    
    func unSave() async throws {
        do {
            self.recipe?.isSaved = false
            try await PostService.unSaveRecipe(recipeId: recipeId)
        } catch {
            
        }
        
    }
}
