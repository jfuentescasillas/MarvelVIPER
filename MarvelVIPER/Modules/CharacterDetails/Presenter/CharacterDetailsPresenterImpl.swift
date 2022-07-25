//
//  CharacterDetailsPresenterImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 29/05/22.
//

import Foundation


protocol CharacterDetailsPresenterProtocol {
	func fetchCharacterDetailsFromAPI()
	func cellViewModel(at indexPath: IndexPath) -> CharacterDetailsViewModel
	func numberOfItemsInSection(inSection: Int) -> Int?
		
	//func didselectItem(at indexPath: IndexPath)
}


class CharacterDetailsPresenterImpl: BasePresenter<CharacterDetailsViewController, CharacterDetailsRouterProtocol> {
	// Public properties
	var interactor: CharacterDetailsInteractorProtocol?
	var characterID: Int?
	
	// Private properties
	private var numComics: Int?
	private var numSeries: Int?
	private var numStories: Int?
	private var numEvents: Int?
	
	private var isViewModelLoaded: Bool = false
	
	private var detailsViewModel = [CharacterDetailsViewModel]()
	private var resultsViewModel = [MarvelResults?]()
}


extension CharacterDetailsPresenterImpl: CharacterDetailsPresenterProtocol {
	func fetchCharacterDetailsFromAPI() {
		guard let charID = characterID else { return }
		
		interactor?.fetchDetailsFromRequestedApi(withID: charID, success: { [weak self] characterDetails in
			guard self != nil else { return }
			guard let charDetails = characterDetails else { return }
			
			self?.detailsViewModel.append(CharacterDetailsViewModel.init(characterName: charDetails.first?.name, characterImageURL: charDetails.first?.imageURL, characterDescription: charDetails.first?.description, characterComics: charDetails.first?.comics.items, characterSeries: charDetails.first?.series.items, characterStories: charDetails.first?.stories.items, characterEvents: charDetails.first?.events.items))
			self?.resultsViewModel = charDetails
			
			/*print("detailsViewModel: \(String(describing: self?.detailsViewModel))")
			print("resultsViewModel: \(String(describing: self?.resultsViewModel))")
			print("-------------------")*/
			
			self?.numComics  = self?.resultsViewModel[0]?.comics.items.count
			self?.numSeries  = self?.resultsViewModel[0]?.series.items.count
			self?.numStories = self?.resultsViewModel[0]?.stories.items.count
			self?.numEvents  = self?.resultsViewModel[0]?.events.items.count
			
			self?.isViewModelLoaded = true
			
			self?.viewController?.fetchDataFromPresenterToView(charDetailsViewModel: (self?.detailsViewModel.first)!)
			self?.viewController?.reloadTableView()
		}, failure: { (error) in
			print(error?.localizedDescription ?? "Error fetching the Character's Details from Api")
		})
	}
	
	
	func numberOfItemsInSection(inSection: Int) -> Int? {
		/*print("Section: \(inSection)")
		print("numberOfItemsInSection(): \(resultsViewModel.count)")
		print("-------------------")
		
		return resultsViewModel.count*/  // CÓDIGO DE ANDRÉS OCAMPO
				
		switch inSection {
		case 0, 1:  // Section 0: Character's Image, Section 1: Character's Description
			return resultsViewModel.count
			
		case 2:  // Section 2: Character's comics
			if numComics == 0 && isViewModelLoaded {
				return 1
			} else {
				return numComics
			}
						
		case 3:  // Section 3: Character's series
			if numSeries == 0 && isViewModelLoaded {
				return 1
			} else {
				return numSeries
			}
			
		case 4:  // Section 4: Character's stories
			if numStories == 0 && isViewModelLoaded {
				return 1
			} else {
				return numStories
			}
			
		case 5:  // Section 5: Character's events
			if numEvents == 0 && isViewModelLoaded {
				return 1
			} else {
				return numEvents
			}
			
		default:
			return 0
		}
	}
	

	func cellViewModel(at indexPath: IndexPath) -> CharacterDetailsViewModel {
		print("resultsViewModel: \(resultsViewModel) inside cellViewModel")
		return resultsViewModel[0]!.toDetailsCellViewModel
	}
}
