//
//  MarvelCharactersListInteractorImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 14/05/22.
//


import Foundation


protocol MarvelCharactersListInteractorProtocol {
	func fetchCharactersFromAPIBusiness(pageOffset: Int, success: @escaping([MarvelResults]?) -> (), failure: @escaping(ApiError?) -> ())
}


class MarvelCharactersListInteractorImpl: BaseInteractor<MarvelCharactersListPresenterProtocol> {
	var provider: MarvelCharactersListProviderProtocol = MarvelCharactersListProviderImpl()
}


extension MarvelCharactersListInteractorImpl: MarvelCharactersListInteractorProtocol {
	internal func fetchCharactersFromAPIBusiness(pageOffset: Int, success: @escaping([MarvelResults]?) -> (), failure: @escaping(ApiError?) -> ()) {
		provider.fetchMarvelCharacters(pageOffset: pageOffset) { [weak self] (result) in
			guard self != nil else { return }
			  
			switch result {
			case .success(let response):
				success(response.data.results)
				
			case .failure(let error):
				failure(error)
			}
		}
	}
}
