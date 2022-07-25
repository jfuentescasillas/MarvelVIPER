//
//  CharactersListViewModel.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 14/05/22.
//


import Foundation


struct CharactersListViewModel {
	let charactersResponse: [MarvelResults]?
	
	init(businessModel: MarvelCharacterModel) {
		charactersResponse = businessModel.data.results
	}
}
