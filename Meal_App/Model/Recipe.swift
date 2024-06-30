//
//  Recipe.swift
//  Meal_App
//
//  Created by Hitesh Reddy on 29/06/24.
//

import Foundation

struct Recipe: Identifiable, Codable {
    var id: String { strMeal }
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var name: String {
        strMeal
    }
    
    var thumbnailURL: String {
        strMealThumb
    }
}

struct RecipeResponse: Codable {
    let meals: [Recipe]
}
