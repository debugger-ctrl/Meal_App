//
//  RecipeDetailView.swift
//  Meal_App
//
//  Created by Hitesh Reddy on 29/06/24.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipeId: String
    @StateObject private var viewModel = RecipeDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                if let recipe = viewModel.recipe {
                    AsyncImage(url: URL(string: recipe.thumbnailURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
                        case .failure(_):
                            Color.red
                                .frame(height: 300)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
                        case .empty:
                            ProgressView()
                                .frame(height: 300)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
                        @unknown default:
                            ProgressView()
                                .frame(height: 300)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
                        }
                    }
                    .padding(.bottom, 16)
                    
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .padding(.bottom, 4)
                        
                        ForEach(recipe.ingredients.indices, id: \.self) { index in
                            HStack {
                                Text("\(recipe.ingredients[index])")
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("- \(recipe.measurements[index])")
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instructions")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .padding(.bottom, 4)
                        
                        // Split the instructions by ". " and create bullet points
                        ForEach(recipe.instructions.split(separator: ".").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }, id: \.self) { instruction in
                            if !instruction.isEmpty {
                                HStack(alignment: .top) {
                                    Text("•")
                                    Text("\(instruction).")
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                } else {
                    ProgressView("Loading data...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }
            .navigationBarTitle(viewModel.recipe?.name ?? "Loading...", displayMode: .inline)
            .onAppear {
                viewModel.fetchRecipeDetail(id: recipeId)
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipeId: "52893")
    }
}
