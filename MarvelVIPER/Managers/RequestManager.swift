//
//  RequestManager.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 13/05/22.
//


import UIKit
import Combine
import CoreData


// MARK: - RequestManagerProtocol
protocol RequestManagerProtocol: AnyObject {
	func requestGeneric<T: Decodable>(requestDto: RequestDTO, entityClass: T.Type) -> AnyPublisher<T, ApiError>
	func requestCharacterSearch<T: Decodable>(requestDto: RequestDTO, entityClass: T.Type) -> AnyPublisher<T, ApiError>
	
	//func requestFromDatabase<T: Decodable>(withRequest: NSFetchRequest<FavoriteCharacter>?,
	//										 entityClass: T.Type) -> AnyPublisher<T, ApiError>
	func requestFromDatabase(withRequest: NSFetchRequest<FavoriteCharacter>?) -> [FavoriteCharacter]?
	func saveCommentsAndUpdateCoreData(withComment: String, withViewModel: FavoriteCharacter) -> Bool
}


class RequestManager: RequestManagerProtocol {
	// MARK: - Request Marvel Characters List
	// Otra forma de escribirlo:
	// internal func requestGeneric<T>(requestDto: RequestDTO, entityClass: T.Type) -> AnyPublisher<T, ApiError> where T: Decodable
	internal func requestGeneric<T: Decodable>(requestDto: RequestDTO, entityClass: T.Type) -> AnyPublisher<T, ApiError> {
		let endpoint = requestDto.endpoint
		
		guard let url = URL(string: endpoint) else {
			let error = ApiError.unknownError
			
			return Fail(error: error).eraseToAnyPublisher()
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
	
	
	// MARK: - Request a Search for a Marvel Character's Name
	internal func requestCharacterSearch<T: Decodable>(requestDto: RequestDTO, entityClass: T.Type) -> AnyPublisher<T, ApiError> {
		let endpoint = requestDto.endpoint
		
		guard let url = URL(string: endpoint) else {
			let error = ApiError.unknownError
			
			return Fail(error: error).eraseToAnyPublisher()
		}
				
		let dataTask = URLSession.shared.dataTaskPublisher(for: url)
			.mapError { error -> ApiError in
				ApiError.unknownError
			}
			.flatMap { data, response -> AnyPublisher<T, ApiError> in
				guard let httpResponse = response as? HTTPURLResponse else {
					return Fail(error: ApiError.unknownError).eraseToAnyPublisher()
				}
				
				print("httpResponse.statusCode (In the RequestManager searching a character): \(httpResponse.statusCode)")
				print("----------------")
				
				switch httpResponse.statusCode {
				case 200...299:
					print("All OK (searching character): \(httpResponse.statusCode)")
					
					let justData = Just(data).decode(type: T.self, decoder: JSONDecoder())
						.mapError { error in
							ApiError.unknownError
						}
						.eraseToAnyPublisher()
					
					return justData
					
				case 400...499:
					print("Client error (searching character): \(httpResponse.statusCode)")
					
					let justData = Just(data).decode(type: T.self, decoder: JSONDecoder())
						.mapError { error in
							ApiError.internalError(reason: "\(httpResponse.statusCode)")
						}
						.eraseToAnyPublisher()
					
					return justData
				
				case 500...599:
					print("Server error (searching character): \(httpResponse.statusCode)")
					
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
	
	
	// MARK: - Request data from Database
	//internal func requestFromDatabase<T: Decodable>(withRequest: NSFetchRequest<FavoriteCharacter>? = FavoriteCharacter.fetchRequest(),
		//											entityClass: T.Type) -> AnyPublisher<T, ApiError> {
	internal func requestFromDatabase(withRequest: NSFetchRequest<FavoriteCharacter>? = FavoriteCharacter.fetchRequest()) -> [FavoriteCharacter]? {
		// Unwrap request
		guard let withRequest = withRequest else { fatalError("Fatal error in requestFromDatabase") }
		
		withRequest.returnsObjectsAsFaults = true
		
		// Core Data Properties
		let appDelegate  = UIApplication.shared.delegate as! AppDelegate
		lazy var context = appDelegate.persistentContainer.viewContext
		
		// Character Properties.
		var favChars: [FavoriteCharacter]?
		
		do {
			let results = try context.fetch(withRequest)
						
			if results.count > 0  {
				// Assign the results found in favBeersArray
				favChars = results
				
				/*print("FavBeers: \(favBeers)")
				print("---------------")*/
				
				// Just to check what is being saved
				/*for result in results as [NSManagedObject] {
					guard let savedFavBeerID = result.value(forKey: "favBeerID") as? Int16 else { return }
					guard let savedFavBeerName = result.value(forKey: "favBeerName") as? String else { return }
					guard let savedFavBeerDescription = result.value(forKey: "favBeerDescription") as? String else { return }
					
					print("The saved fav beer ID is: \(savedFavBeerID)")
					print("The saved fav beer Name is: \(savedFavBeerName)")
					print("The saved fav beer Description is: \(savedFavBeerDescription)")
					print("---------------(inside requestFavoriteBeers() at FavoriteBeersTablePresenter class)")
					
				}*/
			} /* else if isSearching {
				viewController?.showMessageAlert(title: "noFavoriteCharsFoundTitle".localized,
									   message: "noFavoriteCharsFoundMsg".localized)
			}*/ else {
				print("Initial status with an empty list.")
			}
		} catch {
			print("Error requesting the list of favorite characters")
		}
		
		return favChars
	}
	
	
	// MARK: - Update Database
	func saveCommentsAndUpdateCoreData(withComment: String, withViewModel: FavoriteCharacter) -> Bool {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context 	= appDelegate.persistentContainer.viewContext
				
		withViewModel.setValue(withComment, forKey: "favCharacterComments")
		
		// Save everything
		do {
			try context.save()
			
			return true
		} catch {
			print("Error trying to save favorite beer Comment inside FavBeerDetailsPresenter")
			
			return false
		}		
	}
}
