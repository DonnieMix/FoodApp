//
//  RecipeCell.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 01.10.2023.
//

import Foundation
import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    
    func configure(with recipe: BriefRecipe) {
        self.dishNameLabel.text = recipe.title
        self.dishImageView.imageFromServerURL(recipe.image, placeHolder: UIImage(systemName: "questionmark"))
    }
}
