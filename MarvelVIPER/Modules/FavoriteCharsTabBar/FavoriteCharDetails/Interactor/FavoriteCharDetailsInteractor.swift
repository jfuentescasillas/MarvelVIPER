//
//  FavoriteCharDetailsInteractor.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 10/02/23.
//

import Foundation


protocol FavoriteCharDetailsInteractorProtocol {
	func saveCommentsAndUpdateCoreData(withComment: String, withViewModel: FavoriteCharacter) -> Bool
}


class FavoriteCharDetailsInteractor: BaseInteractor<FavoriteCharDetailsPresenterProtocol>  {
	var provider: FavoriteCharDetailsProviderProtocol = FavoriteCharDetailsProvider()
}


extension FavoriteCharDetailsInteractor: FavoriteCharDetailsInteractorProtocol {
	func saveCommentsAndUpdateCoreData(withComment: String, withViewModel: FavoriteCharacter) -> Bool {
		return provider.saveCommentsAndUpdateCoreData(withComment: withComment, withViewModel: withViewModel)
	}
}
