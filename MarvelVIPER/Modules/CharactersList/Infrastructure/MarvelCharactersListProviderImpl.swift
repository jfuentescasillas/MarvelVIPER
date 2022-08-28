//
//  MarvelCharactersListProviderImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 13/05/22.
//


import Foundation
import Combine


protocol MarvelCharactersListProviderProtocol {
	func fetchMarvelCharacters(pageOffset: Int, completionHandler: @escaping (Result<MarvelCharacterModel, ApiError>) -> Void)
}


class MarvelCharactersListProviderImpl: MarvelCharactersListProviderProtocol {
	let provider: RequestManagerProtocol = RequestManager()
	var cancellable = [AnyCancellable]()
	
	
	internal func fetchMarvelCharacters(pageOffset: Int, completionHandler: @escaping (Result<MarvelCharacterModel, ApiError>) -> Void) {
		let charactersListEndpoint = URLEndpoint.baseURL + URLEndpoint.setCharsLimit + URLEndpoint.setCharsOffset + "\(pageOffset)" + URLEndpoint.setTimeStamp + "\(1)" + URLEndpoint.setApiKey + SensitiveData().apiKey + URLEndpoint.setHashKey + SensitiveData().hashKey
		
		//print("charactersListEndpoint = \(charactersListEndpoint)")
		
		let request = RequestDTO(params: nil,
								 method: .get,
								 endpoint: charactersListEndpoint)
		
		provider.requestGeneric(requestDto: request, entityClass: MarvelCharacterModel.self)
			.sink { [weak self] (completion) in
				guard self != nil else { return }
				
				switch completion {
				case .finished:
					break
					
				case .failure(let error):
					completionHandler(.failure(error))
				}
			} receiveValue: { [weak self] responseCharacterModel in
				guard self != nil else { return }
				
				completionHandler(.success(responseCharacterModel))
			}.store(in: &cancellable)
	}
}
