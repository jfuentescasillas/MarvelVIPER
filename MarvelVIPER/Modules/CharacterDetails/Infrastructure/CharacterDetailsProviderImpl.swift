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


/*
 Bueno:   https://gateway.marvel.com/v1/public/characters/1010853?apikey=b5a004aac50e22dbccea83b58947bf97&ts=1&hash=cf8530437ab0e239d120f70010f33a34
 Impreso: https://gateway.marvel.com/v1/public/characters/1017100?apikey=b5a004aac50e22dbccea83b58947bf97&ts=1&hash=cf8530437ab0e239d120f70010f33a34
 */
