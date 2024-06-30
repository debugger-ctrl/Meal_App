//
//  DetailedRecipe.swift
//  Meal_App
//
//  Created by Hitesh Reddy on 29/06/24.
//

import Foundation

struct DetailedRecipeResponse: Codable {
    let meals: [DetailedRecipe]?
}

struct DetailedRecipe: Codable, Identifiable {
    let id: String
    let name: String
    let instructions: String
    let thumbnailURL: String
    let ingredients: [String]
    let measurements: [String]

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case thumbnailURL = "strMealThumb"
    }

    struct DynamicKey: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        
        let ingredientPrefix = "strIngredient"
        let measurementPrefix = "strMeasure"
        
        let dynamicContainer = try decoder.container(keyedBy: DynamicKey.self)
        
        ingredients = try (1...20).compactMap {
            let key = DynamicKey(stringValue: "\(ingredientPrefix)\($0)")!
            return try dynamicContainer.decodeIfPresent(String.self, forKey: key)
        }.filter { !$0.isEmpty }
        
        measurements = try (1...20).compactMap {
            let key = DynamicKey(stringValue: "\(measurementPrefix)\($0)")!
            return try dynamicContainer.decodeIfPresent(String.self, forKey: key)
        }.filter { !$0.isEmpty }
    }
}
