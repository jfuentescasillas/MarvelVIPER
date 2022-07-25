//
//  RequestManager.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 13/05/22.
//


import Foundation
import Combine


protocol RequestManagerProtocol: AnyObject {
	func requestGeneric<T: Decodable>(requestDto: RequestDTO, entityClass: T.Type) -> AnyPublisher<T, ApiError>
}


class RequestManager: RequestManagerProtocol {
	// MARK: - Request Marvel Characters List
	// Otra forma de escribirlo:
	// internal func requestGeneric<T>(requestDto: RequestDTO, entityClass: T.Type) -> AnyPublisher<T, ApiError> where T: Decodable
	internal func requestGeneric<T: Decodable>(requestDto: RequestDTO, entityClass: T.Type) -> AnyPublisher<T, ApiError> {
		let endpoint = requestDto.endpoint
		
		guard let url = URL(string: endpoint) else {
			preconditionFailure("\(ApiError.unknownError)")
		}
				
		let dataTask = URLSession.shared.dataTaskPublisher(for: url)
			.mapError { error -> ApiError in
				ApiError.unknownError
			}
			.flatMap { data, response -> AnyPublisher<T, ApiError> in
				guard let httpResponse = response as? HTTPURLResponse else {
					return Fail(error: ApiError.unknownError).eraseToAnyPublisher()
				}
				
				if (200...299).contains(httpResponse.statusCode) {
					let justData = Just(data).decode(type: T.self, decoder: JSONDecoder())
						.mapError { error in
							ApiError.unknownError
						}
						.eraseToAnyPublisher()
					
					return justData
				} else {
					let error = ApiError.unknownError
					
					return Fail(error: error).eraseToAnyPublisher()
				}				
			}
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
		
		return dataTask
	}
}
