//
//  AppAssembly.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 11/05/22.
//


import UIKit


protocol AppAssemblyProtocol {
	func setPrincipalViewController(in window: UIWindow)
}


class AppAssembly: AppAssemblyProtocol {
	var actualViewController: UIViewController!
	
	
	internal func setPrincipalViewController(in window: UIWindow) {
		//customUI()
		actualViewController = CharactersHomeTabBarAssembly.charactersTabBarController() //MarvelCollectionAssembly.marvelCharactersNavigationController()
		
		window.rootViewController = actualViewController
		window.makeKeyAndVisible()
	}
	
	
	// Uncomment in case of customization of NavBar and TabBar
	/*private func customUI() {
		let navBar = UINavigationBar.appearance()
		navBar.barTintColor = UIColor.systemGreen//(named: "Label Color")
		navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]//(red: 255/255, green: 255/255, blue: 0, alpha: 1)]  // Text color
		
		let tabBar = UITabBar.appearance()
		tabBar.barTintColor = UIColor.systemYellow//(named: "White Color")//(red: 0/255, green: 0/255, blue: 230/255, alpha: 1)
		tabBar.tintColor = UIColor.systemRed//(named: "System Green Color")//(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)  // Text color
	}*/
}
