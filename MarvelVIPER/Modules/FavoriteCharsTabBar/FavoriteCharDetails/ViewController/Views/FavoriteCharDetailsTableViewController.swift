//
//  FavoriteCharDetailsTableViewController.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 09/02/23.
//


import UIKit


protocol FavoriteCharDetailsTableViewControllerProtocol {
	func commentWasSavedInDatabase()
	func commentFailedToBeSavedInDatabase()
}


class FavoriteCharDetailsTableViewController: BaseViewController<FavoriteCharDetailsPresenterProtocol> {
	// MARK: Properties
	var sectionTitles = kConstantKeyStrings().kCharDetailsSectionTitles
	
	// MARK: Elements on storyboard
	@IBOutlet weak var favDetailsTableView: UITableView!
	
	
	// MARK: - Life Cycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		registerNotifications()
		createDismissKeyboardTapGesture()
		
		sectionTitles.append("Comments on the Character")
		presenter?.fetchFavCharDetailsFromDatabase()
    }
	
	
	// MARK: - Keyboard related Methods
	// Methods to Place Keyboard Under the CollectionView
	func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		favDetailsTableView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
	}
	
	
	@objc func keyboardWillHide(notification: NSNotification) {
		favDetailsTableView.contentInset.bottom = 0
	}
	
	
	// MARK: Hide keyboard when the user taps around
	func createDismissKeyboardTapGesture() {
		let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
		view.addGestureRecognizer(tap)
	}
}


// MARK: - Extension. Messages of Database Update
extension FavoriteCharDetailsTableViewController: FavoriteCharDetailsTableViewControllerProtocol {
	func commentWasSavedInDatabase() {
		showMessageAlert(title: "commentUpdateSavedInDBTitle".localized,
						 message: "commentSavedMsg".localized)
	}
	
	
	func commentFailedToBeSavedInDatabase() {
		showMessageAlert(title: "commentUpdateFailedToBeSavedInDBTitle".localized,
						 message: "commentFailedToBeSavedMsg".localized)
	}
}


// MARK: - Extension. Table view data source
extension FavoriteCharDetailsTableViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionTitles.count
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numberOfItemsInSection(inSection: section) ?? 0
	}

	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0, 1:
			return ""
			
		default:
			return sectionTitles[section]
		}
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = presenter?.cellViewModel(at: indexPath) else { return UITableViewCell() }
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCharBibliographyCell", for: indexPath) as? FavCharBibliographyTableViewCell else { return UITableViewCell() }
				
		title = viewModel.favCharName  // Set the title of the view with the Character's name
		
		let viewModelSection = indexPath.section
		
		switch viewModelSection {
		case 0: // Character's Image Section
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCharImgCell", for: indexPath) as? FavCharImgTableViewCell else { return UITableViewCell() }
			
			cell.configureImgCell(with: viewModel)
			
			return cell
		
		case 1:  // Character's Description Section
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCharDescriptionCell", for: indexPath) as? FavCharDescriptionTableViewCell else { return UITableViewCell() }
			
			cell.configureDescriptionCell(with: viewModel)
			
			return cell
		
		case 2:  // Character's Comics Section
			guard let comics = viewModel.favCharComics else { return UITableViewCell() }
			
			cell.configureBibliographyCell(with: comics, indexPath: indexPath)
						
			return cell
			
		case 3:  // Character's Series Section
			guard let series = viewModel.favCharSeries  else { return UITableViewCell() }
									
			cell.configureBibliographyCell(with: series, indexPath: indexPath)
						
			return cell
			
		case 4:  // Character's Stories Section
			guard let stories = viewModel.favCharStories  else { return UITableViewCell() }
									
			cell.configureBibliographyCell(with: stories, indexPath: indexPath)
						
			return cell
			
		case 5:  // Character's Events Section
			guard let events = viewModel.favCharEvents  else { return UITableViewCell() }
									
			cell.configureBibliographyCell(with: events, indexPath: indexPath)
						
			return cell
						
		default:  // Section about the Observations made by the user about this character
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCharObservationsCell", for: indexPath) as? FavCharObservationsTableViewCell else { return UITableViewCell() }
			
			cell.configureObservationsCell(with: viewModel.favCharacterComments ?? "")
			cell.parentVC = self
			
			return cell
		}
	}
}
