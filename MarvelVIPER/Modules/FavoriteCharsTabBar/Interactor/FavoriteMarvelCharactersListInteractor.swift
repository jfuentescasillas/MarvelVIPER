//
//  FavoriteMarvelCharactersListInteractor.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 07/02/23.
//


import Foundation


protocol FavoriteMarvelCharactersListInteractorProtocol {
	func fetchCharactersFromDataBaseBusiness(success: @escaping([FavoriteCharacter]?) -> (), failure: @escaping(ApiError?) -> ())
	//func searchCharacter(characterName: String, pageOffset: Int, success: @escaping([MarvelResults]?) -> (), failure: @escaping(ApiError?) -> ())
}


class FavoriteMarvelCharactersListInteractor: BaseInteractor<FavoriteMarvelCharsListPresenterProtocol> {
	var provider: FavoriteCharsListProviderProtocol = FavoriteCharsListProvider()
}


extension FavoriteMarvelCharactersListInteractor: FavoriteMarvelCharactersListInteractorProtocol {
	func fetchCharactersFromDataBaseBusiness(success: @escaping ([FavoriteCharacter]?) -> (), failure: @escaping (ApiError?) -> ()) {
		
	}
}
