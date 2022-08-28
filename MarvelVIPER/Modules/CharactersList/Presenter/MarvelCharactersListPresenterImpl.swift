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
		viewController?.startActivity()
		
		interactor?.fetchCharactersFromAPIBusiness(pageOffset: pageOffset, success: { [weak self] resultArray in
			guard self != nil else { return }
			
			guard let resultArray = resultArray else { return }
			
			self?.viewModel.removeAll()
			self?.viewModel = resultArray
						
			self?.viewController?.stopAndHideActivity()
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
	
	
	internal func cellViewModel(at indexPath: IndexPath) -> CharacterCollectionViewCellViewModel {
		let item = viewModel[indexPath.row]
		
		return item.toCollectionCellViewModel
	}
	
	
	internal func fetchNextCharacters() {
		viewController?.startActivity()
		
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
				
				self?.viewController?.stopAndHideActivity()
			}, failure: { errorApi in
				print("errorApi?.localizedDescription fetching MORE chars: \(errorApi?.localizedDescription ?? "Error fetching MORE chars")" )
				self.viewController?.showNoInternetMsg()
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
