//
//  MainRecipeView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-19.
//

import SwiftUI
import Kingfisher
import Iconoir

struct MainRecipeView: View {
    //let recipe: Recipe

    @State var servings = 4

    //@State var save = false
    
    @StateObject var viewModel: RecipeViewModel
    @Environment(\.dismiss) var dismiss
    
    init(recipeId: String){
        self._viewModel = StateObject(wrappedValue: RecipeViewModel(recipeId: recipeId))
    }
    
    
    var save: Bool {
        return viewModel.recipe?.isSaved ?? false
    }

    
    var body: some View {
        
        ZStack{
            if let recipe = viewModel.recipe{
                
                var utensilsText: String {
                    recipe.utensils.map { $0.utensil }.joined(separator: ", ")
                }
                
                
                
                ScrollView {
                    VStack(spacing: 16){
                        HStack{
                            Button(action: {
                                dismiss()
                            }){
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(Color.black)
                            }
                            
                            Spacer()
                            
                            Text(recipe.name)
                                .font(.custom("HankenGrotesk-Regular", size: .H4))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.left").opacity(0)
                        }.padding(.horizontal, 16)
                        
                        if let imageUrl = recipe.imageUrl {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32)
                                .contentShape(RoundedRectangle(cornerRadius: 16))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32)
                        }
                        
                        HStack{
                            Spacer()
                            
                            Button(action: {
                                handleSavedTapped()
                            }){
                                if save {
                                    Iconoir.bookmarkSolid.asImage
                                        .foregroundStyle(Color(.colorOrange))
                                } else {
                                    Iconoir.bookmark.asImage
                                        .foregroundStyle(Color(.colorOrange))
                                }
                                
                            }
                            
                            Button(action: {
                                
                            }){
                                Iconoir.shareIos.asImage
                                    .foregroundStyle(.black)
                            }
                        }.padding(.horizontal, 16)
                        
                        Rectangle()
                            .frame(height: 1)
                            .padding(.horizontal, 16)
                            .foregroundStyle(Color(.systemGray))
                        
                        
                        HStack{
                            Spacer()
                            VStack{
                                Text("Difficulty")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                    .foregroundStyle(Color(.systemGray))
                                
                                Text(difficultyString(diff: recipe.difficualty))
                                    .font(.custom("HankenGrotesk-Regular", size: .P1))
                                    .foregroundStyle(Color(.systemGray))
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            VStack{
                                Text("Time")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                    .foregroundStyle(Color(.systemGray))
                                
                                Text("\(recipe.time)")
                                    .font(.custom("HankenGrotesk-Regular", size: .P1))
                                    .foregroundStyle(Color(.systemGray))
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .padding(.horizontal, 16)
                            .foregroundStyle(Color(.systemGray))
                        
                        
                        HStack{
                            Text("Ingridients:")
                                .font(.custom("HankenGrotesk-Regular", size: .H4))
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }.padding(.horizontal, 16)
                        
                        HStack{
                            Text("Servings")
                                .font(.custom("HankenGrotesk-Regular", size: .P1))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button(action: {
                                if servings != 2{
                                    servings -= 2
                                }
                                
                            }){
                                Iconoir.minus.asImage
                                    .foregroundStyle(.black)
                                    .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.clear)
                                        .stroke(Color(.systemGray))
                                    )
                            }
                            
                            Text("\(servings)")
                                .font(.custom("HankenGrotesk-Regular", size: .P1))
                                .padding(.horizontal, 5)
                            
                            Button(action: {
                                if servings != 10{
                                    servings += 2
                                }
                                
                            }){
                                Iconoir.plus.asImage
                                    .foregroundStyle(.black)
                                    .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.clear)
                                        .stroke(Color(.systemGray))
                                    )
                            }
                        }.padding(.horizontal, 16)
                        
                        VStack(spacing: 8){
                            HStack(spacing: 24){
                                Text("Quantity:")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                    .frame(width: 50, alignment: .leading)
                                    
                                
                                Text("Unit:")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                    .frame(width: 50, alignment: .leading)
                                    
                                
                                Text("Ingredient:")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                
                                Spacer()
                                    
                            }.padding(.horizontal, 16)
                            ForEach(recipe.ingrediences, id: \.self) { ingredience in
                                
                                var quantity = Double(ingredience.units) ?? 0 // Default to 0 if conversion fails
                                var number = quantity * (Double(servings) / Double(viewModel.recipe!.servings))
                                HStack(spacing: 24){
                                    Text("\(Int(number))")
                                        .font(.custom("HankenGrotesk-Regular", size: .P1))
                                        .frame(width: 50, alignment: .leading)
                                        .fontWeight(.semibold)
                                    
                                    Text("\(ingredience.messurment)")
                                        .font(.custom("HankenGrotesk-Regular", size: .P1))
                                        .frame(width: 50, alignment: .leading)
                                        .fontWeight(.semibold)
                                    
                                    Text(ingredience.ingredient)
                                        .font(.custom("HankenGrotesk-Regular", size: .P1))
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }.padding(.horizontal, 16)
                            }
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .padding(.horizontal, 16)
                            .foregroundStyle(Color(.systemGray))
                        
                        VStack(alignment: .leading, spacing: 8){
                            
                            Text("Utensils:")
                                .font(.custom("HankenGrotesk-Regular", size: .H4))
                                .fontWeight(.semibold)
                            Text("\(utensilsText)")
                                 .font(.custom("HankenGrotesk-Regular", size: .P1))
                                 .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(.horizontal, 16)
                        
                        
                       
                    
                        ForEach(recipe.steps, id: \.self){ step in
                            
                            var utensilsTextSpecific: String {
                                //step.utensils.map { $0.utensil }.joined(separator: ", ")
                                return step.utensils.utensil
                            }
                            
                            var ingredienceTextSpecific: String {
                                step.ingrediences.map { $0.ingredient}.joined(separator: ", ")
                            }
                            
                            VStack(alignment: .leading, spacing: 8){
                                
                                Rectangle()
                                    .frame(height: 1)
                                    //.padding(.horizontal, 16)
                                    .foregroundStyle(Color(.systemGray))
                                    .padding(.vertical, 8)
                                
                                Text("Step \(step.stepNumber):")
                                    .font(.custom("HankenGrotesk-Regular", size: .H4))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fontWeight(.semibold)
                                
                                /*if let imageUrl = recipe.imageUrl{
                                    KFImage(URL(string: imageUrl))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width - 32, height: 191)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: UIScreen.main.bounds.width - 32, height: 191)
                                }*/
                                
                                HStack(alignment: .top){
                                    Text("🍜")
                                    
                                    Text("\(ingredienceTextSpecific)")
                                        .font(.custom("HankenGrotesk-Regular", size: .P1))
                                }
                                
                                HStack(alignment: .top){
                                    Text("🍽️")
                                    
                                    Text("\(utensilsTextSpecific)")
                                        .font(.custom("HankenGrotesk-Regular", size: .P1))
                                }
                                
                                Text(step.text)
                                    .font(.custom("HankenGrotesk-Regular", size: .P1))
                                
                                
                                
                                
                                
                            }.padding(.horizontal, 16)
                            
                        }
                    }
                }
            }
        }.onFirstAppear {
            Task{
                try await viewModel.fetchRecipe()
                try await viewModel.checkIfUserSavedRecipe()
            }
        }
    }

    func handleSavedTapped(){
        if viewModel.recipe?.isSaved == true {
            Task {
                try await viewModel.unSave()
            }
        } else {
            Task {
                try await viewModel.save()
            }
        }
    }

    func difficultyString(diff: Int) -> String {
        switch diff{
        case 1:
                return "Very Easy"
        case 2:
            return "Easy"
            
        case 3:
            return "Medium"
            
        case 4:
            return "Hard"
        
        case 5:
            return "Very hard"
                
        default:
            return "Unknown"
        }
    }

}
/*
#Preview {
    MainRecipeView(recipe: Recipe(id: "001", ownerPost: "abcascmsad", name: "Taco", difficualty: 3, time: "20-30min", servings: 4, ingrediences: [ingrediences(units: "3", ingredient: "dl", messurment: "vatten")], steps: [], utensils: [], imageUrl: nil))
}*/
