//
//  NetworkErrorHandler.swift
//  FoodApp
//
//  Created by Kyrylo Derkach on 03.10.2023.
//

import Foundation
import UIKit

class NetworkErrorHandler {
    
    static func handle(presentAlertIn viewController: UIViewController, _ networkError: NetworkError) {
        var title = ""
        var message = ""
        
        switch networkError {
        case .internetError:
            title = "Internet Error"
            message = "Seems like you have no internet connection"
        case .requestFailed(let error):
            title = "Request Failed"
            message = error.localizedDescription
        case .decodingError:
            title = "Decoding Error"
            message = "Failed to decode the request parameters"
        case .classificationError:
            title = "Classification Error"
            message = "We couldn't classify your dish"
        case .guessNutritionError:
            title = "Nutrition guess failed"
            message = "Sorry, we cannot guess nutrition of this dish"
        case .serverError(let errorCode):
            title = "Server Error"
            message = "The server encountered an error with code \(errorCode)"
        case .unknown:
            title = "Unknown Error"
            message = "An unknown error occurred. Contact the devs"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true)
        }
    }
    
}
