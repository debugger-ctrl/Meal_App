//
//  RecipeDetailViewModel.swift
//  Meal_App
//
//  Created by Hitesh Reddy on 29/06/24.
//

import Foundation
import Combine

class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: DetailedRecipe?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRecipeDetail(id: String) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: DetailedRecipeResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching recipe detail: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if let recipe = response.meals?.first {
                    self.recipe = recipe
                } else {
                    print("No meals found")
                }
            })
            .store(in: &self.cancellables)
    }
}
