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
				
				print("httpResponse.statusCode (In the RequestManager): \(httpResponse.statusCode)")
				print("----------------")
				
				switch httpResponse.statusCode {
				case 200...299:
					print("All OK: \(httpResponse.statusCode)")
					
					let justData = Just(data).decode(type: T.self, decoder: JSONDecoder())
						.mapError { error in
							ApiError.unknownError
						}
						.eraseToAnyPublisher()
					
					return justData
					
				case 400...499:
					print("Client error: \(httpResponse.statusCode)")
					
					let justData = Just(data).decode(type: T.self, decoder: JSONDecoder())
						.mapError { error in
							ApiError.internalError(reason: "\(httpResponse.statusCode)")
						}
						.eraseToAnyPublisher()
					
					return justData
				
				case 500...599:
					print("Server error: \(httpResponse.statusCode)")
					
					let justData = Just(data).decode(type: T.self, decoder: JSONDecoder())
						.mapError { error in
							ApiError.serverError(reason: "\(httpResponse.statusCode)")
						}
						.eraseToAnyPublisher()
					
					return justData
					
				default:
					let error = ApiError.unknownError
					
					return Fail(error: error).eraseToAnyPublisher()
				}
			}
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
		
		return dataTask
	}
}
