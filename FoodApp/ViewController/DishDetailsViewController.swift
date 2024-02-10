//
//  DishDetailsViewController.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 01.10.2023.
//

import Foundation
import UIKit

class DishDetailsViewController: UIViewController {
    var recipeId: Int?
    var recipe: Recipe?
    var nutrition: Nutrition?
    var unableToGuessNutrition: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var guessNutritionButton: UIButton!
    @IBOutlet weak var guessedCuisineLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var dietsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    let alert = UIAlertController(title: "Oops..", message: "There was an error getting dish data", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recipeId = recipeId {
            loadElements(recipeId: recipeId)
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default))
    }
    
    func loadElements(recipeId: Int) {
        RapidAPIService.shared.request(endpoint: .getRecipeInformation(recipeId: recipeId)) { (result: Result<Recipe, NetworkError>) in
            switch result {
            case .success(let recipe):
                DispatchQueue.main.async {
                    self.recipe = recipe
                    self.dishNameLabel.text = recipe.title
                    self.dishImageView.imageFromServerURL(recipe.image, placeHolder: UIImage(systemName: "questionmark"))
                    self.prepTimeLabel.text = "Preparation time: \(recipe.readyInMinutes) mins"
                    self.servingsLabel.text = "Servings: \(recipe.servings)"
                    self.linkButton.setTitle(recipe.sourceUrl, for: .normal)
                    self.linkButton.addAction(UIAction { _ in
                        guard let url = URL(string: recipe.sourceUrl) else { return }
                        UIApplication.shared.open(url)
                    }, for: .touchUpInside)
                    self.dietsLabel.text = "Diets: \(recipe.diets.joined(separator: ", "))"
                    self.instructionsLabel.text = "Instructions: \(recipe.instructions)"
                }
                let ingredientList = recipe.extendedIngredients.map { $0.original }
                RapidAPIService.shared.request(endpoint: .classifyCuisine(title: recipe.title, ingredientList: ingredientList)) { (result: Result<DishClassificationResponse, NetworkError>) in
                    switch result {
                    case .success(let dishClassificationResponse):
                        let cuisine = dishClassificationResponse.cuisine
                        DispatchQueue.main.async {
                            self.guessedCuisineLabel.text = "Guessed cuisine: \(cuisine)"
                        }
                    case .failure(let error):
                        NetworkErrorHandler.handle(presentAlertIn: self, error)
                        print("Error: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                NetworkErrorHandler.handle(presentAlertIn: self, error)
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func guessNutrition() {
        guard let recipe = recipe else { return }
        if nutrition != nil {
            showNutritionAlertMessage()
            return
        } else if unableToGuessNutrition {
            NetworkErrorHandler.handle(presentAlertIn: self, .guessNutritionError)
            return
        }
        RapidAPIService.shared.request(endpoint: .guessNutritionByDishName(dishName: recipe.title)) { (result: Result<Nutrition, NetworkError>) in
            switch result {
            case .success(let nutrition):
                DispatchQueue.main.async {
                    self.nutrition = nutrition
                    self.showNutritionAlertMessage()
                }
            case .failure(let error):
                NetworkErrorHandler.handle(presentAlertIn: self, error)
                if case .guessNutritionError = error {
                    self.unableToGuessNutrition = true
                }
                print("Error: \(error.localizedDescription)")
            }
            
        }
    }
    
    func showNutritionAlertMessage() {
        guard let recipe = recipe,
              let nutrition = nutrition else { return }
        let alert = UIAlertController(title: "\(recipe.title) nutrition info", message: "Calories: \(nutrition.calories)\n Fat: \(nutrition.fat)\n Protein: \(nutrition.protein)\n Carbs: \(nutrition.carbs)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
