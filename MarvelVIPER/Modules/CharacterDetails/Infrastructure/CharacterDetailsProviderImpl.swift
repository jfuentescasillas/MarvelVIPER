//
//  CharacterDetailsProviderImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 05/06/22.
//

import Foundation
import Combine


protocol CharacterDetailsProviderProtocol {
	func fetchCharacterDetails(withID characterID: Int, completionHandler: @escaping (Result<[MarvelResults], ApiError>) -> Void)
}


class CharacterDetailsProviderImpl: CharacterDetailsProviderProtocol {
	let provider: RequestManagerProtocol = RequestManager()
	var cancellable = [AnyCancellable]()

	
	internal func fetchCharacterDetails(withID characterID: Int, completionHandler: @escaping (Result<[MarvelResults], ApiError>) -> Void) {
		let detailsEndpoint = CharacterDetailsURLEndpoint.baseURL + "\(characterID)" + CharacterDetailsURLEndpoint.setApiKey + SensitiveData().apiKey + CharacterDetailsURLEndpoint.setTimeStamp + "\(1)" + CharacterDetailsURLEndpoint.setHashKey + SensitiveData().hashKey
		let request = RequestDTO(params: nil,
								 method: .get,
								 endpoint: detailsEndpoint)
		
		provider.requestGeneric(requestDto: request, entityClass: MarvelCharacterModel.self).sink { [weak self] completion in
			guard self != nil else { return }
			
			switch completion {
			case .finished:
				break
				
			case .failure(let error):
				completionHandler(.failure(error))
			}
		} receiveValue: { [weak self] marvelResults in
			guard self != nil else { return }
			
			completionHandler(.success(marvelResults.data.results))
		}.store(in: &cancellable)
	}
}
