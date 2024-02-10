//
//  RecipeListViewController.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 01.10.2023.
//

import Foundation
import UIKit

extension RecipeListViewController: UITableViewDelegate {
    
}

extension RecipeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeCell
        let recipe = recipes[indexPath.row]
        guard let cell = cell else {
            return UITableViewCell()
        }
        cell.configure(with: recipe)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDishDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.selectedRecipe = recipes[indexPath.row]
            }
            if let destinationVC = segue.destination as? DishDetailsViewController,
               let selectedRecipe = self.selectedRecipe {
                destinationVC.recipeId = selectedRecipe.id
            }
        }
    }
}
