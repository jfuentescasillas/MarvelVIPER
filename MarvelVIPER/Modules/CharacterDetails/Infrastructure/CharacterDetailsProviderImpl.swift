//
//  CharacterDetailsProviderImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 05/06/22.
//

import Foundation
import Combine
import CryptoKit


// MARK: - CharacterDetailsProviderProtocol
protocol CharacterDetailsProviderProtocol {
	func fetchCharacterDetails(withID characterID: Int, completionHandler: @escaping (Result<[MarvelResults], ApiError>) -> Void)
}


// MARK: - CharacterDetailsProviderImpl
class CharacterDetailsProviderImpl: CharacterDetailsProviderProtocol {
	// MARK: - Properties
	let provider: RequestManagerProtocol = RequestManager()
	var cancellable = Set<AnyCancellable>()

	// Properties needed for the generation of the timeStamp and the hashkey
	private let timeStamp: String = String(Date().timeIntervalSince1970)
	private var generatedHashKey: String {
		return MD5(withData: "\(timeStamp)\(SensitiveData().prApiKey)\(SensitiveData().pbApiKey)")
	}
	
	
	// MARK: - Protocol Methods
	internal func fetchCharacterDetails(withID characterID: Int, completionHandler: @escaping (Result<[MarvelResults], ApiError>) -> Void) {
		let detailsEndpoint = CharacterDetailsURLEndpoint.baseURL + "\(characterID)" + CharacterDetailsURLEndpoint.setApiKey + SensitiveData().pbApiKey + CharacterDetailsURLEndpoint.setTimeStamp + timeStamp + CharacterDetailsURLEndpoint.setHashKey + generatedHashKey
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
	
	
	// MARK: - To create the hash, CryptoKit is used.
	private func MD5(withData: String) -> String {
		let dataToHash = Insecure.MD5.hash(data: withData.data(using: .utf8) ?? Data())
		let hashMapped = dataToHash.map {
			String(format: "%02hhx", $0)
		}
		.joined()
		
		return hashMapped
	}
}
