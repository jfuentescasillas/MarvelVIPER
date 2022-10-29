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
	func fetchSearchedItems(searchedName: String, pageSearchedOffset: Int)
	func cellViewModel(at indexPath: IndexPath) -> CharacterCollectionViewCellViewModel
	func fetchNextCharacters()  // Pagination
	func didselectItem(at indexPath: IndexPath)
	func resetButtonPressed()
}


class MarvelCharactersListPresenterImpl: BasePresenter<MarvelCharactersListViewController, MarvelCharactersListRouterProtocol> {
	// Properties related to the PresenterProtocol
	var numCharacters: Int {
		return viewModel.count
	}
	
	// Public properties
	var interactor: MarvelCharactersListInteractorProtocol?
	
	// View Model Properties
	private var viewModel = [MarvelResults]() {
		didSet {
			self.viewController?.reloadCollectionViewData()
		}
	}
	
	private var viewModelAux = [MarvelResults]() {
		didSet {
			self.viewController?.reloadCollectionViewData()
		}
	}
	
	// Private properties
	private var fetchedCharacters: Int		    = 0
	private var fetchedCharactersInSearch: Int	= 0
	private var pageOffset: Int  	 		    = 0   // This is needed for the pagination
	private var pageSearchOffsetGlobal: Int	    = 0
	private var pageOffsetAux: Int 			    = 0
	private var searchedName: String 		    = ""  // When the user searches for a character's name, it will be stored in this variable
	private var hasMoreCharacters: Bool 	    = true
	private var hasMoreCharactersInSearch: Bool = true
	private var isLoadingMoreCharacters: Bool   = false
	private var isSearchingCharacters: Bool     = false
}


extension MarvelCharactersListPresenterImpl: MarvelCharactersListPresenterProtocol {
	// MARK: Normal fetching of 100 characters. This is run at the beginning of the app
	func fetchCharactersFromAPI() {
		viewController?.startActivity()
		
		interactor?.fetchCharactersFromAPIBusiness(pageOffset: pageOffset, success: { [weak self] resultArray in
			guard let self = self else { return }
			guard let resultArray = resultArray else { return }
			
			self.viewModel.removeAll()
			self.viewModel 		   = resultArray
			self.viewModelAux 	   = self.viewModel
			self.fetchedCharacters = resultArray.count
			
			self.viewController?.stopAndHideActivity()
		}, failure: { errorApi in
			guard let errorString = errorApi?.localizedDescription else { return }
			
			let errorInt: Int = Int(errorString) ?? -100
			
			switch errorInt {
			case (400...499):
				self.viewController?.showClientRequestErrorMsg()
				
			case (500...599):
				self.viewController?.showServerErrorMsg()
				
			default:
				self.viewController?.showNoInternetMsg()
			}
			
			print("errorApi?.localizedDescription fetching chars: \(errorApi?.localizedDescription ?? "Error fetching chars")")
		})
	}
	
	
	// MARK: Search for a character
	func fetchSearchedItems(searchedName: String, pageSearchedOffset: Int) {
		self.searchedName  		= searchedName
		isLoadingMoreCharacters = false
		isSearchingCharacters   = true

		viewController?.enableResetButton()  // The "reset" button is activated in the view
		
		if pageSearchedOffset == 0 {
			hasMoreCharactersInSearch = true
			pageSearchOffsetGlobal = 0
			
			viewModel.removeAll()
		}
		
		interactor?.searchCharacter(characterName: searchedName, pageOffset: pageSearchedOffset,
									success: { [weak self] resultOfSearch in
			guard let self = self else { return }
			guard let resultOfSearch = resultOfSearch else { return }
				
			self.fetchedCharactersInSearch = resultOfSearch.count
			
			if self.fetchedCharactersInSearch < 100 {
				self.hasMoreCharactersInSearch = false
			}
			
			self.viewModel += resultOfSearch
			
			if self.viewModel.isEmpty == false {
				self.viewController?.stopAndHideActivity()
			} else {
				self.viewController?.showEmptySearchResult()
			}
		}, failure: { errorApi in
			guard let errorString = errorApi?.localizedDescription else { return }
			
			let errorInt: Int = Int(errorString) ?? -100
			
			switch errorInt {
			case (400...499):
				self.viewController?.showClientRequestErrorMsg()
				
			case (500...599):
				self.viewController?.showServerErrorMsg()
				
			default:
				self.viewController?.showNoInternetMsg()
			}
			
			print("errorApi?.localizedDescription fetching chars: \(errorApi?.localizedDescription ?? "Error fetching character search")")
		})
		
		viewController?.startActivity()
	}
	
	
	// MARK: Reset the character's search
	func resetButtonPressed() {
		isSearchingCharacters     = false
		isLoadingMoreCharacters   = false
		hasMoreCharactersInSearch = true
		hasMoreCharacters 		  = true
		
		fetchedCharactersInSearch = 0
		pageSearchOffsetGlobal    = 0
		
		viewModel.removeAll()
		viewModel  = viewModelAux
		pageOffset = pageOffsetAux
		
		fetchCharactersFromResetButton()
	}
	
	
	// MARK: Used to show the Character's information in the cell of the list
	internal func cellViewModel(at indexPath: IndexPath) -> CharacterCollectionViewCellViewModel {
		let item = viewModel[indexPath.row]
		
		return item.toCollectionCellViewModel
	}
	
	
	// MARK: Used for the Pagination
	internal func fetchNextCharacters() {
		viewController?.startActivity()
		
		// When the last page of characters is reached, the api will fetch back less than 100 characters (which is the maximum nr. of chars. asked to the api), this means that when the fetchedCharacters is less than 100...
		if isSearchingCharacters == false {
			if fetchedCharacters < 100 {
				hasMoreCharacters = false
				
				viewController?.noMoreCharactersAvailable()
			}
			
			// ...then there are no more characters to fetch and the pagination will be deactivated in the next "guard"
			guard !isLoadingMoreCharacters && hasMoreCharacters else {
				viewController?.stopAndHideActivity()
				
				return
			}
			
			isLoadingMoreCharacters = true
			pageOffset += 100
			
			interactor?.fetchCharactersFromAPIBusiness(pageOffset: pageOffset, success: { [weak self] resultArray in
				guard let self = self else { return }
				guard let resultArray = resultArray else { return }
				
				self.viewModel += resultArray
				
				if self.isSearchingCharacters == false {
					self.viewModelAux = self.viewModel
					self.pageOffsetAux = self.pageOffset
				}
				
				self.fetchedCharacters = resultArray.count
				
				self.isLoadingMoreCharacters = false
				
				self.viewController?.stopAndHideActivity()
			}, failure: { errorApi in
				print("errorApi?.localizedDescription fetching MORE chars: \(errorApi?.localizedDescription ?? "Error fetching MORE chars")" )
				self.viewController?.showNoInternetMsg()
			})
		} else {  // Case when isSearchingCharacters == true
			if fetchedCharactersInSearch < 100 {
				hasMoreCharactersInSearch = false
				
				viewController?.noMoreCharactersAvailable()
			}
			
			// ...then there are no more characters (when the search of a character is active) to fetch and the pagination will be deactivated in the next "guard"
			guard !isLoadingMoreCharacters && hasMoreCharactersInSearch else {
				viewController?.stopAndHideActivity()
				
				return
			}
			
			isLoadingMoreCharacters = true
			pageSearchOffsetGlobal += 100
		
			fetchSearchedItems(searchedName: self.searchedName, pageSearchedOffset: pageSearchOffsetGlobal)
		}
	}
	
	
	private func fetchCharactersFromResetButton() {
		viewController?.startActivity()
		
		pageOffset = pageOffsetAux
		viewModel = viewModelAux
		
		viewController?.scrollToBottom(atIndex: viewModel.count)
		viewController?.reactivateHasMoreCharacters()
	}
	
	
	internal func didselectItem(at indexPath: IndexPath) {
		router?.goToDetailVC(with: viewModel[indexPath.row].id)
	}
}
