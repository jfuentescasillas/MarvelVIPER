//
//  CharacterDetailsInteractorImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 29/05/22.
//

import Foundation


protocol CharacterDetailsInteractorProtocol {
	func fetchDetailsFromRequestedApi(withID characterID: Int, success: @escaping([MarvelResults]?) -> Void, failure: @escaping(ApiError?) -> Void)
}


class CharacterDetailsInteractorImpl: BaseInteractor<CharacterDetailsPresenterProtocol> {
	var provider: CharacterDetailsProviderProtocol = CharacterDetailsProviderImpl()
}


extension CharacterDetailsInteractorImpl: CharacterDetailsInteractorProtocol {
	internal func fetchDetailsFromRequestedApi(withID characterID: Int, success: @escaping([MarvelResults]?) -> Void, failure: @escaping(ApiError?) -> Void) {
		provider.fetchCharacterDetails(withID: characterID) { [weak self] result in
			guard self != nil else { return }
			
			switch result {
			case .success(let response):
				success(response)
				
			case .failure(let error):
				failure(error)
			}
		}
	}
}
