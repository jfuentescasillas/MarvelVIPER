//
//  SecondViewAssembly.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 15/05/22.
//


import UIKit


final public class SecondViewAssembly {
	static func secondViewNavigationController() -> BaseNavigationController {
		let navigationController = BaseNavigationController(rootViewController: secondViewController())
				
		return navigationController
	}
	
	
	static func secondViewController() -> SecondViewController {
		let vc = SecondViewController.createFromStoryboard()
		vc.title = "favoriteCharactersVCTitle".localized
		
		return vc
	}
}
