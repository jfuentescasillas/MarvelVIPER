//
//  UIViewControllerExt.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 11/05/22.
//


import UIKit


extension UIViewController {
	// Function called from the Builders. This function helps to create a view from a Storyboard
	static func createFromStoryboard() -> Self {
		return UIStoryboard(name: String(describing: self), bundle: .main).instantiateViewController(withIdentifier: String(describing: self)) as! Self
	}
	
	
	// Create Global Alert Controller
	func showMessageAlert(title: String = "", message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alertController.addAction(OKAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
}
