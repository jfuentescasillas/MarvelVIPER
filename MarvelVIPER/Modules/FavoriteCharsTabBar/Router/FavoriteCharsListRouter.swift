//
//  FavoriteCharsListRouter.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 07/02/23.
//

import Foundation


protocol FavoriteCharsListRouterProtocol {
	// This viewModel exists in CharacterDetailsViewController
	func goToFavCharDetailVC(with favCharViewModel: FavoriteCharacter)
}


class FavoriteCharsListRouter: BaseRouter<FavoriteMarvelCharsListPresenterProtocol> {
	
}


extension FavoriteCharsListRouter: FavoriteCharsListRouterProtocol {
	internal func goToFavCharDetailVC(with favCharViewModel: FavoriteCharacter) {
		//print("favCharViewModel: \(favCharViewModel)")
		
		let vc = FavoriteCharDetailsAssembly.favoriteCharDetailsViewController(withFavoriteCharacter: favCharViewModel) 
		
		if let navigationController = viewController?.navigationController {
			navigationController.pushViewController(vc, animated: true) //present(vc, animated: true)
		} else {
			viewController?.present(vc, animated: true)
		}
	}
}
