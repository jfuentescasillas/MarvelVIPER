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
			
	func cellViewModel(at indexPath: IndexPath) -> FavoriteCharacter
	func didselectItem(at indexPath: IndexPath)
	func resetOrCancelButtonPressed()
	
	// CoreData methods to Create, Read, Update or Delete (CRUD) a character in the favorite list
	func fetchCharactersFromDatabase()
	func fetchSearchedFavoriteItems(searchedName: String)
	func deleteFavChar(at indexPath: IndexPath)
}


// MARK: - Main class. FavoriteMarvelCharactersListPresenter
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
	private var auxSearchedName: String = ""  // When the user searches for a character's name, it will be stored in this variable
	
	// Core Data Properties
	private let appDelegate  = UIApplication.shared.delegate as! AppDelegate
	private lazy var context = appDelegate.persistentContainer.viewContext
	
	
	// MARK: - Create, Read, Update and Delete (CRUD) Data
	// MARK: Read Data from Database (in Core Data)
	// (it's created in the CharacterDetailsPresenterImpl)
	private func loadFavCharsData(withRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()) {
		viewController?.startActivity()
		
		guard let results = interactor?.fetchCharactersFromDataBaseBusiness(withRequest: withRequest) else {
			viewController?.stopAndHideActivity()
			
			// This is active when the results from a search are empty
			if isSearching {
				viewController?.showMessageAlert(title: "noFavoriteCharsFoundTitle".localized,
									   message: "noFavoriteCharsFoundMsg".localized)
			}
			
			return			
		}
		
		if results.count > 0  {
			// Assign the results found in favBeersArray
			favChars = results
		} else {
			print("List is empty.")
		}
		
		viewController?.stopAndHideActivity()
	}
	
	
	// MARK: Delete Character from Favorite list
	func deleteFavChar(at indexPath: IndexPath) {
		context.delete(favChars[indexPath.row])  // This line goes first...
		favChars.remove(at: indexPath.row)  //...Then this line goes next.
		
		do {
			try context.save()
		} catch {
			print("Error Deleting the Character From Favorites")
		}
	}
}


// MARK: - Extension. FavoriteMarvelCharsListPresenterProtocol
extension FavoriteMarvelCharactersListPresenter: FavoriteMarvelCharsListPresenterProtocol {
	func fetchCharactersFromDatabase() {
		if isSearching {
			fetchSearchedFavoriteItems(searchedName: auxSearchedName)
		} else {
			loadFavCharsData()
		}
	}
	
	
	func fetchSearchedFavoriteItems(searchedName: String) {
		auxSearchedName	= searchedName
		isSearching     = true
		
		let searchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
		searchRequest.predicate = NSPredicate(format: "favCharName CONTAINS[cd] %@", searchedName)
		
		loadFavCharsData(withRequest: searchRequest)
	}
	
	
	func cellViewModel(at indexPath: IndexPath) -> FavoriteCharacter {
		return favChars[indexPath.row]
	}
	
	
	func didselectItem(at indexPath: IndexPath) {
		router?.goToFavCharDetailVC(with: favChars[indexPath.row])
	}
	
	
	func resetOrCancelButtonPressed() {
		isSearching 	= false
		auxSearchedName	= ""
		fetchCharactersFromDatabase()
	}
}


/* // Inside of
   // func loadFavCharsData(withRequest:...). This code below is implemented when the interactor to fetch the data from the database is not used
 
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
 } */
