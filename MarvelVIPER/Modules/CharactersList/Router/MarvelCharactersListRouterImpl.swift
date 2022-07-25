//
//  MarvelCharactersListRouterImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 13/05/22.
//


import Foundation


protocol MarvelCharactersListRouterProtocol {
	func goToDetailVC(with characterID: Int)
}


class MarvelCharactersListRouterImpl: BaseRouter<MarvelCharactersListPresenterProtocol> {
	
}


extension MarvelCharactersListRouterImpl: MarvelCharactersListRouterProtocol {
	internal func goToDetailVC(with characterID: Int) {
		let vc = CharacterDetailsAssembly.characterDetailsViewController(dto: CharacterIdDTO(charID: characterID))
		
		if let navigationController = viewController?.navigationController {
			navigationController.pushViewController(vc, animated: true)
		} else {
			viewController?.present(vc, animated: true)
		}
		
	}
}
