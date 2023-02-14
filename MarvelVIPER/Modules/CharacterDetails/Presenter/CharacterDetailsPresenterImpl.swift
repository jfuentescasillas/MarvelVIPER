//
//  CharacterDetailsPresenterImpl.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 29/05/22.
//

import UIKit
import CoreData


protocol CharacterDetailsPresenterProtocol {
	func fetchCharacterDetailsFromAPI()
	func cellViewModel(at indexPath: IndexPath) -> CharacterDetailsViewModel
	func numberOfItemsInSection(inSection: Int) -> Int?
	func isCharInDatabase(with viewModel: CharacterDetailsViewModel) -> Bool
	func saveCharBtnPressed(viewModel: CharacterDetailsViewModel, withUserComment: String)
}


class CharacterDetailsPresenterImpl: BasePresenter<CharacterDetailsViewController, CharacterDetailsRouterProtocol> {
	// Public properties
	var interactor: CharacterDetailsInteractorProtocol?
	var characterID: Int?
		
	// Private properties
	private var resultsViewModel = [MarvelResults?]()
	private var favCharImg: Data?
	
	private var numComics: Int?
	private var numSeries: Int?
	private var numStories: Int?
	private var numEvents: Int?
	
	private var isViewModelLoaded: Bool = false
}


extension CharacterDetailsPresenterImpl: CharacterDetailsPresenterProtocol {
	func fetchCharacterDetailsFromAPI() {
		guard let charID = characterID else { return }
		
		viewController?.startActivity()
		
		interactor?.fetchDetailsFromRequestedApi(withID: charID, success: { [weak self] characterDetails in
			guard let self = self,
				  let charDetails = characterDetails
			else { return }
			
			self.resultsViewModel = charDetails
			
			self.numComics  = self.resultsViewModel[0]?.comics.items.count
			self.numSeries  = self.resultsViewModel[0]?.series.items.count
			self.numStories = self.resultsViewModel[0]?.stories.items.count
			self.numEvents  = self.resultsViewModel[0]?.events.items.count
			
			self.isViewModelLoaded = true
			
			self.viewController?.title = self.resultsViewModel[0]?.name
			self.viewController?.stopAndHideActivity()
			self.viewController?.reloadTableView()
			
		}, failure: { (error) in
			print(error?.localizedDescription ?? "Error fetching the Character's Details from Api")
		})
	}
	
	
	func numberOfItemsInSection(inSection: Int) -> Int? {
		switch inSection {
		case 0, 1:  // Section 0: Character's Image, Section 1: Character's Description
			return resultsViewModel.count
			
		case 2:  // Section 2: Character's comics
			return numComics == 0 && isViewModelLoaded ? 1 : numComics
			/* The terniary operator above does the same as the next if-else statement
			 if numComics == 0 && isViewModelLoaded {
				return 1
			} else {
				return numComics
			}*/
						
		case 3:  // Section 3: Character's series
			return numSeries == 0 && isViewModelLoaded ? 1 : numSeries
						
		case 4:  // Section 4: Character's stories
			return numStories == 0 && isViewModelLoaded ? 1 : numStories
						
		case 5:  // Section 5: Character's events
			return numEvents == 0 && isViewModelLoaded ? 1 : numEvents
						
		default:
			return 0
		}
	}
	

	func cellViewModel(at indexPath: IndexPath) -> CharacterDetailsViewModel {
		return resultsViewModel[0]!.toDetailsCellViewModel
	}
	
	
	// MARK: - Create Data in the Database
	// Check if character is already in the database
	func isCharInDatabase(with viewModel: CharacterDetailsViewModel) -> Bool {
		let appDelegate  = UIApplication.shared.delegate as! AppDelegate  // Used for CoreData
		let context 	 = appDelegate.persistentContainer.viewContext  // Used for CoreData
		
		// Check if wanted beer is already in the favorite list
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteCharacter")
		request.returnsObjectsAsFaults = false
		request.predicate = NSPredicate(format: "favCharID == %@", "\(viewModel.characterID)")  // If favCharID is already in Favorite Character list, it won't be saved again
		
		do {
			// Just checking if the Character to save is already in the favorites list according to the request.predicate from above
			let results = try context.fetch(request)
			
			// If the result is 0, then the Character is NOT YET in the favorite list and can be saved in it
			if results.count == 0 {
				return false
			} else {
				return true
			}
		} catch {
			print("Error requesting the list of favorite Characters (Inside CharacterDetailsPresenter.isCharInDatabase(...)")
			
			return true
		}
	}
	
	
	// Save character in the Favorite Characters List
	// If character already exists in the database, return "true", otherwise it returns "false"
	func saveCharBtnPressed(viewModel: CharacterDetailsViewModel, withUserComment: String) {
		guard let imgURLString = viewModel.characterImageURL,
			  let imgURL = URL(string: imgURLString)
		else {
			print("Invalid URL address. Inside CharacterDetailsPresenterImpl.saveCharBtnPressed(...)")
			
			return
		}
		
		// Check if wanted beer is already in the favorite list
		let appDelegate = UIApplication.shared.delegate as! AppDelegate  // Used for CoreData
		let context 	= appDelegate.persistentContainer.viewContext  // Used for CoreData
		let request		= NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteCharacter")
		request.returnsObjectsAsFaults = false
		//request.predicate = NSPredicate(format: "favCharID == %@", "\(viewModel.characterID)")  // If favCharID is already in Favorite Character list, it won't be saved again. This is not needed since it was already checked in the method isCharInDatabase(...)
		
		do {
			// This Character can be saved in the list of favorites since it is not duplicated
			let task = URLSession.shared.dataTask(with: imgURL) { imgData, imgResponse, imgError in
				if imgError != nil {
					print("Error downloading the Character's Image")
					
					return
				}
				
				// Save new Favorite Character details (usually string and numeric values)
				let favCharacter = NSEntityDescription.insertNewObject(forEntityName: "FavoriteCharacter", into: context)
				favCharacter.setValue("\(viewModel.characterID)", forKey: "favCharID")
				favCharacter.setValue(viewModel.characterName, forKey: "favCharName")
				
				// MARK: - Control empty values for the fields that may have.
				// Character Description
				guard let description = viewModel.characterDescription  else { return }
				
				if description.isEmpty {
					let noDescription: String = "Character has no description"
					favCharacter.setValue(noDescription, forKey: "favCharDescription")
				} else {
					favCharacter.setValue(description, forKey: "favCharDescription")
				}
				
				// Character comics
				//print("------Comics------")
				guard let favCharComics = viewModel.characterComics else { return }
				
				fillBibliography(bibliographies: favCharComics,
								 emptyBibliographyMsg: "Character has no comics",
								 forKey: "favCharComics")
				
				// Character series
				//print("------Series------")
				guard let favCharSeries = viewModel.characterSeries else { return }
				
				fillBibliography(bibliographies: favCharSeries,
								 emptyBibliographyMsg: "Character has no series",
								 forKey: "favCharSeries")
				
				// Character stories
				//print("------Stories------")
				guard let favCharStories = viewModel.characterStories else { return }
				
				fillBibliography(bibliographies: favCharStories,
								 emptyBibliographyMsg: "Character has no stories",
								 forKey: "favCharStories")
				
				// Character events
				//print("------Events------")
				guard let favCharEvents = viewModel.characterEvents else { return }
				
				fillBibliography(bibliographies: favCharEvents,
								 emptyBibliographyMsg: "Character has no events",
								 forKey: "favCharEvents")
				
				
				// Function to fill the Character's bibliography to save as [String]. Bibliographies can be empty, and if they are, then we append the emptyBibliographyMsg to the array
				func fillBibliography(bibliographies: [MarvelItems], emptyBibliographyMsg: String, forKey: String) {
					var bibliographiesToSave = [String]()
					
					if bibliographies.isEmpty {
						bibliographiesToSave.append(emptyBibliographyMsg)
					} else {
						for bibliography in bibliographies {
							bibliographiesToSave.append(bibliography.name)
						}
					}
					
					favCharacter.setValue(bibliographiesToSave, forKey: forKey)
				}
				
				// Save the user's comments about the saved character. This can later be modified in the FavCharDetailsViewController
				if withUserComment.isEmpty || withUserComment == "" {
					favCharacter.setValue("characterSavedCommentsDefaultValue".localized, forKey: "favCharacterComments")
				} else {
					favCharacter.setValue(withUserComment, forKey: "favCharacterComments")
				}
				
				// Saving the image (which is Data). If some error occurs in the characterImage, the default placeholder will be shown in the cell along with all the data previously saved in favCharacter.setValue(...)
				guard let imgData = imgData else { return }
				
				self.favCharImg = imgData
				
				favCharacter.setValue(self.favCharImg, forKey: "favCharImg")
				
				// MARK: Save everything
				do {
					try context.save()
				} catch {
					print("Error trying to save values inside the URLSession")
				}
				
				DispatchQueue.main.async {
					self.viewController?.showCharacterSavedSuccessfullyMsg()
				}
				
				/*print("******Show saved favCharacter: \(favCharacter)******")
				 print("------------")*/
			}
			
			task.resume()
		}
	}
}
