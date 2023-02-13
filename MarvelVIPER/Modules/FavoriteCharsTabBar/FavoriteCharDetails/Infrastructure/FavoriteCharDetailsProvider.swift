//
//  FavoriteCharDetailsProvider.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 10/02/23.
//


import Foundation


protocol FavoriteCharDetailsProviderProtocol {
	func saveCommentsAndUpdateCoreData(withComment: String, withViewModel: FavoriteCharacter) -> Bool
}


class FavoriteCharDetailsProvider: FavoriteCharDetailsProviderProtocol {
	let provider: RequestManagerProtocol = RequestManager()
	
	
	func saveCommentsAndUpdateCoreData(withComment: String, withViewModel: FavoriteCharacter) -> Bool {
		return provider.saveCommentsAndUpdateCoreData(withComment: withComment, withViewModel: withViewModel)
	}
}
