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
    
    @State var showAlert = false

    private var difficualty: Int {
        return viewModel.recipeDiff ?? 0
    }
    var body: some View {
        ScrollView {
            VStack (spacing: 24){
                HStack{
                    Button(action: {
                        showAlert.toggle()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Create Recipe")
                        .font(.custom("HankenGrotesk-Regular", size: .H4))
                        .fontWeight(.semibold)
                    Spacer()
                    
                    Button(action: {
                        viewModel.recipe = true
                        viewModel.combineIngredientsAndUtensils()
                        print("DEBUG APP RECIPE ING: \(viewModel.recipeIng)")
                        print("DEBUG APP RECIPE UTT: \(viewModel.recipeUtt)")
                        dismiss()
                    }){
                        Text("save")
                            .font(.primaryFont(.P1))
                            .foregroundStyle(.black)
                    }
                    
                }.padding(.horizontal, 16)
                    .padding(.top, 8)
                
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
                        viewModel.recipeSteps.append(steps(stepNumber: viewModel.recipeSteps.count + 1, text: "", utensils: utensil(utensil: ""), ingrediences: [ingrediences(units: "0", ingredient: "", messurment: "")]))
                    }){
                        Iconoir.plusCircle.asImage
                            .foregroundStyle(.black)
                    }
                }.padding(.horizontal, 16)
                
                
                ForEach(Array(viewModel.recipeSteps.enumerated()), id: \.offset) { index, step in
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
                        
                        HStack{
                            Text("Ingrediences")
                                .font(.primaryFont(.P1))
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.recipeSteps[index].ingrediences.append(ingrediences(units: "0", ingredient: "", messurment: ""))
                            }){
                                Iconoir.plusSquare.asImage
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.black)
                            }
                        }
                        
                        HStack{
                            VStack(alignment: .leading){
                                Text("Quantity:")
                                    .font(.primaryFont(.P2))
                                   
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading){
                                Text("Unit:")
                                    .font(.primaryFont(.P2))
                                    
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading){
                                Text("Ingredient:")
                                    .font(.primaryFont(.P2))
                                    
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        ForEach(Array(viewModel.recipeSteps[index].ingrediences.enumerated()), id: \.offset) { ind, step in
                            HStack{
                                VStack(alignment: .leading){
                                    //Text("Quantity:")
                                       // .font(.primaryFont(.P2))
                                    
                                    TextField("", text: $viewModel.recipeSteps[index].ingrediences[ind].units)
                                        .font(.primaryFont(.P2))
                                        .padding(4)
                                        .frame(height: 20)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(.white)
                                            .stroke(Color(.systemGray))
                                        )
                                        .keyboardType(.numberPad)
                                    
                                    
                                }
                                
                                
                                VStack(alignment: .leading){
                                    //Text("Units:")
                                       // .font(.primaryFont(.P2))
                                    
                                    Menu{
                                        Button(action: {
                                            viewModel.recipeSteps[index].ingrediences[ind].messurment = "grams"
                                        }){
                                           Text("grams")
                                                .font(.primaryFont(.P2))
                                        }
                                    } label: {
                                        Text(viewModel.recipeSteps[index].ingrediences[ind].messurment.isEmpty ? "select unit" : viewModel.recipeSteps[index].ingrediences[ind].messurment)
                                            .font(.primaryFont(.P2))
                                            .padding(4)
                                            .frame(height: 20)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(.white)
                                                .stroke(Color(.systemGray))
                                            )
                                            .foregroundStyle(.black)
                                    }
                                    
                                    
                                }
                                
                                
                                VStack(alignment: .leading){
                                   // Text("Ingretient:")
                                        //.font(.primaryFont(.P2))
                                    
                                    TextField("Write Ingredient", text: $viewModel.recipeSteps[index].ingrediences[ind].ingredient)
                                        .font(.primaryFont(.P2))
                                        .padding(4)
                                        .frame(height: 20)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(.white)
                                            .stroke(Color(.systemGray))
                                        )
                                    
                                    
                                }
                            }
                        }
                        
                        VStack(alignment: .leading){
                            Text("Utensils")
                                .font(.primaryFont(.P1))
                            
                            
                            TextField("Write your utensils", text: $viewModel.recipeSteps[index].utensils.utensil)
                                .font(.primaryFont(.P2))
                                .padding(4)
                                .frame(height: 24)
                                .frame(maxWidth: .infinity)
                                .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.white)
                                    .stroke(Color(.systemGray))
                                )
                        }
                        
                        
                        VStack(alignment: .leading){
                            Text("Instructions")
                                .font(.primaryFont(.P1))
                            
                            
                            TextField("Write your instructions", text: $viewModel.recipeSteps[index].text)
                                .font(.primaryFont(.P2))
                                .padding(4)
                                .frame(height: 24)
                                .frame(maxWidth: .infinity)
                                .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.white)
                                    .stroke(Color(.systemGray))
                                )
                        }
                        
                        
                        
                        
                        
                        
                        
                    }.padding(.horizontal, 16)
                }
                
            }
        }.customAlert(isPresented: $showAlert, message: "By going back your recipe wont be saved.", confirmAction: {
            dismiss()
            showAlert.toggle()
        }, cancelAction: {
            showAlert.toggle()
        }, dismissText: "cancel", acceptText: "go back")
    }

    
}

#Preview {
    CreateRecipeView()
        .environmentObject(UploadFlavorPostViewModel())
}
