//
//  MarvelCharacterModel.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 13/05/22.
//


import Foundation


struct MarvelCharacterModel: Codable {
	let code: Int
	let data: MarvelData
}


struct MarvelData: Codable {
	let total: Int
	let results: [MarvelResults]
}


struct MarvelResults: Codable {
	let id: Int
	let name: String
	let description: String
	let thumbnail: MarvelThumbnail
	let comics: MarvelComics
	let series: MarvelSeries
	let stories: MarvelStories
	let events: MarvelEvents
}


struct MarvelThumbnail: Codable {
	let path: String
	let imageExtension: String
	
	// Renaming the image extension property since it has a name conflicting with reserved word "extension"
	private enum CodingKeys: String, CodingKey {
		case path
		case imageExtension = "extension"
	}
}


struct MarvelComics: Codable {
	let items: [MarvelItems]
}


struct MarvelSeries: Codable {
	let items: [MarvelItems]
}


struct MarvelStories: Codable {
	let items: [MarvelItems]
}


struct MarvelEvents: Codable {
	let items: [MarvelItems]
}


struct MarvelItems: Codable {
	let name: String
}


// Extension: Different computed properties for different purposes
extension MarvelResults {
	var imageURL: URL? {
		return URL(string: "\(thumbnail.path).\(thumbnail.imageExtension)")
	}
	
	var toCollectionCellViewModel: CharacterCollectionViewCellViewModel {
		return CharacterCollectionViewCellViewModel(characterImageURL: imageURL, characterName: name, characterDescription: description)
	}
	
	
	var toDetailsCellViewModel: CharacterDetailsViewModel {
		return CharacterDetailsViewModel(characterName: name, characterImageURL: imageURL, characterDescription: description, characterComics: comics.items, characterSeries: series.items, characterStories: stories.items, characterEvents: events.items)
	}
}
