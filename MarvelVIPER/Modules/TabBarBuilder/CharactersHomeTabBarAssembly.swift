//
//  CharactersHomeTabBarAssembly.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 15/05/22.
//


import UIKit


final public class CharactersHomeTabBarAssembly {
	static func charactersTabBarController() -> CharactersHomeTabBar {
		let tabBarViewContr = CharactersHomeTabBar.createFromStoryboard()
		let oneVC = MarvelCollectionAssembly.marvelCharactersNavigationController()
		let twoVC = FavoriteCharsViewAssembly.favoriteCharsViewNavigationController()
		
		let oneCustomTabBarItem = UITabBarItem(title: "charactersTabBarItem".localized, image: UIImage(systemName: "person.3"), tag: 0)
		let twoCustomTabBarItem = UITabBarItem(title: "favoritesTabBarItem".localized, image: UIImage(systemName: "star"), tag: 1)
		
		oneVC.tabBarItem = oneCustomTabBarItem
		twoVC.tabBarItem = twoCustomTabBarItem
		
		tabBarViewContr.viewControllers = [oneVC, twoVC]		
			
		return tabBarViewContr
	}
}
