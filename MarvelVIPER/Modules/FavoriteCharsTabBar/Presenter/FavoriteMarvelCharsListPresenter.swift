//
//  FavoriteMarvelCharsListPresenter.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 07/02/23.
//


import UIKit
import CoreData


protocol FavoriteMarvelCharsListPresenterProtocol {
	var numFavChars: Int { get }
	
	func fetchCharactersFromDatabase()
	func fetchSearchedFavoriteItems(searchedName: String)
	func cellViewModel(at indexPath: IndexPath) -> FavoriteCharacter
	func didselectItem(at indexPath: IndexPath)
	func resetButtonPressed()
}


class FavoriteMarvelCharactersListPresenter: BasePresenter<FavoriteCharsViewController, FavoriteCharsListRouterProtocol> {
	// Properties related to the PresenterProtocol
	var numFavChars: Int {
		return favChars.count
	}
	
	// Public properties
	var interactor: FavoriteMarvelCharactersListInteractorProtocol?
	
	// View Model Properties
	private var favChars = [FavoriteCharacter]() {
		didSet {
			viewController?.reloadTableViewData()
		}
	}

	// Private properties
	private var isSearching: Bool = false
	private var searchedName: String = ""  // When the user searches for a character's name, it will be stored in this variable
	
	// Core Data Properties
	let appDelegate  = UIApplication.shared.delegate as! AppDelegate
	lazy var context = appDelegate.persistentContainer.viewContext
	
	
	// MARK: - Create, Read, Update and Delete (CRUD) Data in CoreData
	// MARK: Load Data
	private func loadFavCharsData(withRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()) {
		viewController?.startActivity()
		
		withRequest.returnsObjectsAsFaults = true
	
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
			} else if isSearching {
				viewController?.showMessageAlert(title: "noFavoriteCharsFoundTitle".localized,
									   message: "noFavoriteCharsFoundMsg".localized)
			} else {
				print("Initial status with an empty list.")
			}
		} catch {
			print("Error requesting the list of favorite characters")
		}
		
		viewController?.stopAndHideActivity()
	}
}


// MARK: - Extension
extension FavoriteMarvelCharactersListPresenter: FavoriteMarvelCharsListPresenterProtocol {
	func fetchCharactersFromDatabase() {
		loadFavCharsData()
	}
	
	
	func fetchSearchedFavoriteItems(searchedName: String) {
		
	}
	
	
	func cellViewModel(at indexPath: IndexPath) -> FavoriteCharacter {
		return favChars[indexPath.row]
	}
	
	
	func didselectItem(at indexPath: IndexPath) {
		
	}
	
	
	func resetButtonPressed() {
		print("Button to Reset the Favorite Characters Search was pressed")
	}
}
