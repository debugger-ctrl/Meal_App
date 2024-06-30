//
//  RecipeListView.swift
//  Meal_App
//
//  Created by Hitesh Reddy on 29/06/24.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading data...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipeId: recipe.idMeal)) {
                            HStack {
                                AsyncImage(url: URL(string: recipe.thumbnailURL)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 2)
                                    } else if phase.error != nil {
                                        Color.red
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 2)
                                    } else {
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 2)
                                    }
                                }
                                .padding(.vertical, 8)
                                
                                Text(recipe.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.vertical, 8)
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .navigationBarTitle("Recipes")
                    .padding()
                }
            }
            .onAppear {
                viewModel.fetchRecipes()
            }
            .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview {
    RecipeListView()
}
