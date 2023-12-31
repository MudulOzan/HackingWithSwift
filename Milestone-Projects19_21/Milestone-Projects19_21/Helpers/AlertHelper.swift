//
//  Helpers.swift
//  ConsolidationVIII
//
//  Created by Ozan Mudul on 10.02.2023.
//

import UIKit

extension UIViewController {
	func showAlert(title: String, message: String?) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(okAction)
		present(alertController, animated: true)
	}
}
