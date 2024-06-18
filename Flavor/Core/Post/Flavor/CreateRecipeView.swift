//
//  CreateRecipeView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI
import Iconoir

struct CreateRecipeView: View {
    @EnvironmentObject var viewModel: UploadFlavorPostViewModel
    @Environment(\.dismiss) var dismiss

    private var difficualty: Int {
        return viewModel.recipeDiff ?? 0
    }
    var body: some View {
        ScrollView {
            VStack (spacing: 24){
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Create Recipe")
                        .font(.custom("HankenGrotesk-Regular", size: .H4))
                        .fontWeight(.semibold)
                    Spacer()
                    
                    Image(systemName: "chevron.left").opacity(0)
                    
                }.padding(.horizontal, 16)
                    .padding(.top, 8)
                
                VStack(alignment: .leading){
                    Text("Create a post")
                        .font(.custom("HankenGrotesk-Regular", size: .H4))
                        .fontWeight(.semibold)
                    
                    Text("Create a recipe for the world or just for your inner circle. Will it be a public feast or a private treat?")
                        .font(.custom("HankenGrotesk-Regular", size: .P2))
                        .foregroundStyle(Color(.systemGray))
                        
                }
                
                VStack(spacing: 5){
                    HStack{
                        Text("Recipe name:")
                            .font(.custom("HankenGrotesk-Regular", size: .P1))
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    
                    TextField("Write your recipe name...", text: $viewModel.recipeTitle)
                        .padding(.horizontal)
                        .frame(height: 53)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .stroke(Color(.systemGray), lineWidth: 1)
                        )
                }.padding(.horizontal, 16)
                
                VStack(spacing: 5){
                    HStack{
                        Text("Difficulty")
                            .font(.custom("HankenGrotesk-Regular", size: .P1))
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    HStack{
                        
                        
                        Button(action: {
                            withAnimation{
                                viewModel.recipeDiff = 1
                            }
                            
                        }){
                            VStack{
                                Text("Very Easy")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                Text("🍜")
                            }.opacity(difficualty > 0 ? 1 : 0.3)
                        }.foregroundStyle(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation{
                                viewModel.recipeDiff = 2
                            }
                        }){
                            VStack{
                                Text("Easy")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                Text("🍜")
                            }.opacity(difficualty > 1 ? 1 : 0.3)
                        }.foregroundStyle(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation{
                                viewModel.recipeDiff = 3
                            }
                        }){
                            VStack{
                                Text("Medium")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                Text("🍜")
                            }.opacity(difficualty > 2 ? 1 : 0.3)
                        }.foregroundStyle(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation{
                                viewModel.recipeDiff = 4
                            }
                        }){
                            VStack{
                                Text("Hard")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                Text("🍜")
                            }.opacity(difficualty > 3 ? 1 : 0.3)
                        }.foregroundStyle(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation{
                                viewModel.recipeDiff = 5
                            }
                        }){
                            VStack{
                                Text("Very Hard")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                Text("🍜")
                            }.opacity(difficualty > 4 ? 1 : 0.3)
                        }.foregroundStyle(.black)
                        
                    }
                }.padding(.horizontal, 16)
                
                
                HStack(spacing: 32){
                    VStack(alignment: .leading){
                        Text("Time:")
                            .font(.custom("HankenGrotesk-Regular", size: .P1))
                            .fontWeight(.semibold)
                        
                        Menu(viewModel.recipeTime == nil ? "Select Time" : viewModel.recipeTime!){
                            Button(action:{
                                viewModel.recipeTime = "<20min"
                            }){
                                Text("<20min")
                                    
                            }
                            
                            Button(action:{
                                viewModel.recipeTime = "20 - 30min"
                            }){
                                Text("20 - 30min")
                                    
                            }
                            
                            Button(action:{
                                viewModel.recipeTime = "30 - 40min"
                            }){
                                Text("30 - 40min")
                                    
                            }
                            
                            Button(action:{
                                viewModel.recipeTime = "40 - 60min"
                            }){
                                Text("40 - 60min")
                                    
                            }
                            
                            Button(action:{
                                viewModel.recipeTime = "1h - 1h 30min"
                            }){
                                Text("1h - 1h 30min")
                                    
                            }
                            
                            Button(action:{
                                viewModel.recipeTime = ">1h 30min"
                            }){
                                Text(">1h 30min")
                                    
                            }
                            
                            
                        }.foregroundStyle(Color.black)
                            .font(.custom("HankenGrotesk-Regular", size: .P2))
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.clear)
                                .stroke(Color.gray)
                            )
                            
                    }
                    
                    
                    VStack(alignment: .leading){
                        Text("Servings:")
                            .font(.custom("HankenGrotesk-Regular", size: .P1))
                            .fontWeight(.semibold)
                        
                        Menu(viewModel.recipeServings == nil ? "Select servings" : "\(viewModel.recipeServings!) servings"){
                            Button(action:{
                                viewModel.recipeServings = 2
                            }){
                                Text("2 servings")
                                    
                            }
                            
                            Button(action:{
                                viewModel.recipeServings = 4
                            }){
                                Text("4 servings")
                                    
                            }
                            
                            Button(action:{
                                viewModel.recipeServings = 6
                            }){
                                Text("6 servings")
                                    
                            }
                            
                            Button(action:{
                                viewModel.recipeServings = 8
                            }){
                                Text("8 servings")
                                    
                            }
                            
                            Button(action:{
                                viewModel.recipeServings = 10
                            }){
                                Text("10 servings")
                                    
                            }
                            
                            
                        }.foregroundStyle(Color.black)
                            .font(.custom("HankenGrotesk-Regular", size: .P2))
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.clear)
                                .stroke(Color.gray)
                            )
                            
                    }
                }.padding(.horizontal, 16)
                
                HStack{
                    Text("Steps")
                        .font(.custom("HankenGrotesk-Regular", size: .H4))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.recipeSteps.append(steps(stepNumber: viewModel.recipeSteps.count + 1, text: "", utensils: [], ingrediences: []))
                    }){
                        Iconoir.plusCircle.asImage
                            .foregroundStyle(.black)
                    }
                }.padding(.horizontal, 16)
                
                
                ForEach(Array(viewModel.recipeSteps.enumerated()), id: \.element) { index, step in
                    VStack {
                        HStack{
                            Text("Step: \(index + 1)") // Display 1-based index
                                .font(.custom("HankenGrotesk-Regular", size: .P1))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button(action: {
                                // Remove the step at this index
                                viewModel.recipeSteps.remove(at: index)
                            }){
                                Iconoir.minus.asImage
                                    .foregroundStyle(.black)
                            }
                            
                        }
                    }.padding(.horizontal, 16)
                }
                
            }
        }
    }

}

#Preview {
    CreateRecipeView()
}
