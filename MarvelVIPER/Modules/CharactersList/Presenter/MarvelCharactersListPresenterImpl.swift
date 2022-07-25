//
//  MarvelCharactersListPresenterImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 13/05/22.
//


import Foundation


protocol MarvelCharactersListPresenterProtocol {
	var numCharacters: Int { get }
	
	func fetchCharactersFromAPI()
	func cellViewModel(at indexPath: IndexPath) -> CharacterCollectionViewCellViewModel
	func fetchNextCharacters()  // Pagination
	func didselectItem(at indexPath: IndexPath)
}


class MarvelCharactersListPresenterImpl: BasePresenter<MarvelCharactersListViewController, MarvelCharactersListRouterProtocol> {
	// Properties related to the PresenterProtocol
	var numCharacters: Int {
		return viewModel.count
	}
	
	// Public properties
	var interactor: MarvelCharactersListInteractorProtocol?
	var viewModel = [MarvelResults]() {
		didSet {
			self.viewController?.reloadCollectionViewData()
		}
	}
	
	// Private properties
	private var pageOffset: Int  	 		  = 0   // This is needed for the pagination
	private var searchedName: String 		  = ""  // When the user searches for a beer's name, it will be stored in this variable
	private var hasMoreCharacters: Bool 	  = true
	private var isLoadingMoreCharacters: Bool = false
	private var isSearchingCharacters: Bool   = false
}


extension MarvelCharactersListPresenterImpl: MarvelCharactersListPresenterProtocol {
	func fetchCharactersFromAPI() {
		interactor?.fetchCharactersFromAPIBusiness(pageOffset: pageOffset, success: { [weak self] resultArray in
			guard self != nil else { return }
			
			guard let resultArray = resultArray else { return }
			
			self?.viewModel.removeAll()
			self?.viewModel = resultArray
						
			// Output data going from Presenter to View
			// Safely unwrapped thanks to guard let result array = resultArray
		}, failure: { errorApi in
			print(errorApi?.localizedDescription ?? "Problems fetching the Marvel Characters")
		})
	}
	
	
	internal func cellViewModel(at indexPath: IndexPath) -> CharacterCollectionViewCellViewModel {
		let item = viewModel[indexPath.row]
		
		return item.toCollectionCellViewModel
	}
	
	
	internal func fetchNextCharacters() {
		// When the last page of characters is reached, the api will fetch back less than 100 characters (which is the maximum nr. of chars. asked to the api), this means that when the numCharacters is less than 100...
		if numCharacters < 100 {
			hasMoreCharacters = false
		}
		
		// ...then there are no more characters to fetch and the pagination will be deactivated in the next "guard"
		guard !isLoadingMoreCharacters && hasMoreCharacters else { return }
		
		isLoadingMoreCharacters = true
		pageOffset += 100
		
		if isSearchingCharacters == false {
			interactor?.fetchCharactersFromAPIBusiness(pageOffset: pageOffset, success: { [weak self] resultArray in
				guard self != nil else { return }
				
				guard let resultArray = resultArray else { return }
				
				self?.viewModel += resultArray
				
				self?.isLoadingMoreCharacters = false
			}, failure: { errorApi in
				print(errorApi?.localizedDescription ?? "Problems fetching more Marvel Characters (could not use pagination)")
			})
		} else {
			//interactor?.searchCharacters(charactersName: searchedName, pageOffset: pageOffset)
		}
		//viewController?.startActivity()
	}
	
	
	internal func didselectItem(at indexPath: IndexPath) {
		router?.goToDetailVC(with: viewModel[indexPath.row].id)
	}
}
