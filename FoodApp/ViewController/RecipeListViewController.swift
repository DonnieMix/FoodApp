//
//  DishesViewController.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 01.10.2023.
//

import Foundation
import UIKit

class RecipeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var recipes: [BriefRecipe] = []
    var selectedRecipe: BriefRecipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func searchRecipes(_ sender: UIButton) {
        guard let query = searchTextField.text else { return }
        RapidAPIService.shared.request(endpoint: .searchRecipes(query: query)) { (result: Result<ComplexSearchResponse, NetworkError>) in
            switch result {
            case .success(let searchResponse):
                guard let results = searchResponse.results else {
                    return
                }
                self.recipes = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                NetworkErrorHandler.handle(presentAlertIn: self, error)
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
