//
//  FavoriteCharDetailsPresenter.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 10/02/23.
//


import UIKit


protocol FavoriteCharDetailsPresenterProtocol {
	func fetchFavCharDetailsFromDatabase()
	func cellViewModel(at indexPath: IndexPath) -> FavoriteCharacter
	func numberOfItemsInSection(inSection: Int) -> Int?
	func saveCharBtnPressed(with updatedComment: String, usingVC: FavoriteCharDetailsTableViewControllerProtocol)
}


// MARK: - Main Class: FavoriteCharDetailsPresenter
class FavoriteCharDetailsPresenter: BasePresenter<FavoriteCharDetailsTableViewController, FavoriteCharDetailsRouterProtocol>  {
	// Public properties
	var interactor: FavoriteCharDetailsInteractorProtocol = FavoriteCharDetailsInteractor()
	var favoriteCharDetails: FavoriteCharacter?
	// This static variable had to be created since the favoriteCharDetails was nil when the "Save comment" button was pressed
	private static var auxFavChar: FavoriteCharacter!
}


extension FavoriteCharDetailsPresenter: FavoriteCharDetailsPresenterProtocol {
	func fetchFavCharDetailsFromDatabase() {
		// Update the static variable in order to update the Database when a comment is modified
		FavoriteCharDetailsPresenter.auxFavChar = favoriteCharDetails
	}
	
	
	func cellViewModel(at indexPath: IndexPath) -> FavoriteCharacter {
		return favoriteCharDetails ?? FavoriteCharacter()
	}
	
	
	func numberOfItemsInSection(inSection: Int) -> Int? {
		switch inSection {
		case 0, 1:  // Section 0: Character's Image, Section 1: Character's Description
			return 1
			
		case 2:  // Section 2: Character's comics
			// print("favoriteCharDetails?.favCharComics?.count: \(String(describing: favoriteCharDetails?.favCharComics?.count))")
			return favoriteCharDetails?.favCharComics?.count == 0 ? 1 : favoriteCharDetails?.favCharComics?.count
			/* The terniary operator above does the same as the next if-else statement
			 if favoriteCharDetails?.favCharComics?.count == 0 {
				return 1
			} else {
				return favoriteCharDetails?.favCharComics?.count
			} */
						
		case 3:  // Section 3: Character's series
			return favoriteCharDetails?.favCharSeries?.count == 0 ? 1 : favoriteCharDetails?.favCharSeries?.count
			
		case 4:  // Section 4: Character's stories
			return favoriteCharDetails?.favCharStories?.count == 0 ? 1 : favoriteCharDetails?.favCharStories?.count
						
		case 5:  // Section 5: Character's events
			return favoriteCharDetails?.favCharEvents?.count == 0 ? 1 : favoriteCharDetails?.favCharEvents?.count
						
		default:  // Section 6: Character's comments
			return 1
		}
	}
	
	
	// Called from the FavCharObservationsTableViewCell
	func saveCharBtnPressed(with updatedComment: String, usingVC: FavoriteCharDetailsTableViewControllerProtocol) {
		let isUpdateSaved: Bool = interactor.saveCommentsAndUpdateCoreData(withComment: updatedComment, withViewModel: FavoriteCharDetailsPresenter.auxFavChar ?? FavoriteCharacter())
		
		if isUpdateSaved {
			// print("Comment updated and saved")
			usingVC.commentWasSavedInDatabase()
		} else {
			// print("Comment NOT SAVED!")
			usingVC.commentFailedToBeSavedInDatabase()
		}
	}
}
