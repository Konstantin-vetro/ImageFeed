//
//  AlertPresenter.swift
//  ImageFeed
//

import Foundation
import UIKit

class AlertPresenter {
    func createAlertController(viewController: UIViewController,
                               title: String,
                               message: String,
                               action: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: action)
        alert.addAction(action)
        viewController.present(viewController, animated: true)
    }
}
