//
//  RecipeViewModel.swift
//  Meal_App
//
//  Created by Hitesh Reddy on 29/06/24.
//

import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRecipes() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                   case .failure(let error):
                    print("Error fetching recipes: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                // Sort recipes alphabetically by name
                self.recipes = response.meals.sorted(by: { $0.name < $1.name })
            })
            .store(in: &self.cancellables)
    }
}
