//
//  MarvelCharactersListProviderImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 13/05/22.
//


import Foundation
import Combine
import CryptoKit


protocol MarvelCharactersListProviderProtocol {
	func fetchMarvelCharacters(pageOffset: Int, completionHandler: @escaping (Result<MarvelCharacterModel, ApiError>) -> Void)
	func fetchCharacterSearch(characterName: String, pageOffset: Int, completionHandler: @escaping (Result<MarvelCharacterModel, ApiError>) -> Void)
}


class MarvelCharactersListProviderImpl: MarvelCharactersListProviderProtocol {
	let provider: RequestManagerProtocol = RequestManager()
	var cancellable = [AnyCancellable]()
	
	// Properties needed for the generation of the timeStamp and the hashkey
	private let timeStamp: String = String(Date().timeIntervalSince1970)
	private var generatedHashKey: String {
		return MD5(withData: "\(timeStamp)\(SensitiveData().prApiKey)\(SensitiveData().pbApiKey)")
	}
	
	
	internal func fetchMarvelCharacters(pageOffset: Int, completionHandler: @escaping (Result<MarvelCharacterModel, ApiError>) -> Void) {
		let charactersListEndpoint = URLEndpoint.baseURL + URLEndpoint.setCharsLimit + URLEndpoint.setCharsOffset + "\(pageOffset)" + URLEndpoint.setTimeStamp + timeStamp + URLEndpoint.setApiKey + SensitiveData().pbApiKey + URLEndpoint.setHashKey + generatedHashKey
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
			}
			.store(in: &cancellable)
	}
	
	
	internal func fetchCharacterSearch(characterName: String, pageOffset: Int, completionHandler: @escaping (Result<MarvelCharacterModel, ApiError>) -> Void) {
		let characterSearchEndpoint = URLEndpoint.baseURL + URLEndpoint.setCharsLimit + URLEndpoint.setCharsOffset + "\(pageOffset)&" + "nameStartsWith=\(characterName)" + URLEndpoint.setTimeStamp + timeStamp + URLEndpoint.setApiKey + SensitiveData().pbApiKey + URLEndpoint.setHashKey + generatedHashKey
		
		let request = RequestDTO(params: nil,
								 method: .get,
								 endpoint: characterSearchEndpoint)
		
		provider.requestCharacterSearch(requestDto: request, entityClass: MarvelCharacterModel.self)
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
			}
			.store(in: &cancellable)
	}
	
	
	// MARK: - To create the hash, CryptoKit is used.
	private func MD5(withData: String) -> String {
		let dataToHash = Insecure.MD5.hash(data: withData.data(using: .utf8) ?? Data())
		let hashMapped =  dataToHash.map {
			String(format: "%02hhx", $0)
		}
		.joined()
		
		return hashMapped
	}
}
