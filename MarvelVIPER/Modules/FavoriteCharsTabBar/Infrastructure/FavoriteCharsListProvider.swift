//
//  FavoriteCharsListProvider.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 07/02/23.
//


import Foundation
import Combine


protocol FavoriteCharsListProviderProtocol {
	func fetchFavoriteChars(completionHandler: @escaping (Result<FavoriteCharacter, ApiError>) -> Void)
}


class FavoriteCharsListProvider: FavoriteCharsListProviderProtocol {
	let provider: RequestManagerProtocol = RequestManager()
	var cancellable = [AnyCancellable]()
	
	
	func fetchFavoriteChars(completionHandler: @escaping (Result<FavoriteCharacter, ApiError>) -> Void) {
		
	}
}
