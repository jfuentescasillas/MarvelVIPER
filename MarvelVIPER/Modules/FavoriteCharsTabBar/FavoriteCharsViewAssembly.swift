//
//  FavoriteCharsViewAssembly.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 26/01/23.
//


import UIKit


final public class FavoriteCharsViewAssembly {
	static func favoriteCharsViewNavigationController() -> BaseNavigationController {
		let navigationController = BaseNavigationController(rootViewController: favoriteCharsViewController())
				
		return navigationController
	}
	
	
	static func favoriteCharsViewController() -> FavoriteCharsViewController {
		let vc = FavoriteCharsViewController.createFromStoryboard()
		vc.title = "favoriteCharactersVCTitle".localized
		
		return vc
	}
}
