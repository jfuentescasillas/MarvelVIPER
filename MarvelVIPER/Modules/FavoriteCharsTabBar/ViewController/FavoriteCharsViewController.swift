//
//  FavoriteCharsViewController.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 26/01/23.
//

import UIKit

protocol FavoriteCharsListViewProtocol {
	func reloadTableViewData()
	func startActivity()
	func stopAndHideActivity()
}


// MARK: - Main Class of the view FavoriteCharsViewController
class FavoriteCharsViewController: BaseViewController<FavoriteMarvelCharsListPresenterProtocol> {
	// MARK: - Properties
	var isSearching: Bool = false
	
	
	// MARK: - Elements in Storyboard
	@IBOutlet weak var resetSearchOutlet: UIBarButtonItem!
	@IBOutlet weak var searchFavCharSearchBar: UISearchBar!
	@IBOutlet weak var favCharsTableView: UITableView!
	@IBOutlet weak var emptyFavoritesLbl: UILabel!
	@IBOutlet weak var emptyLogoContainerView: UIView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
	// MARK: - Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
								
		presenter?.fetchCharactersFromDatabase()
		initialValues()
	}
	
	
	private func initialValues() {
		if !isSearching {
			resetSearchOutlet.isEnabled = false
		} else {
			resetSearchOutlet.isEnabled = true
		}
		
		resetSearchOutlet.title 	    = "favCharsResetButtonTitle".localized
		searchFavCharSearchBar.placeholder  = "charsSearchBarPlaceholder".localized
		emptyFavoritesLbl.text 	        = "emptyFavoriteListTxt".localized
				
		registerNotifications()
		
		if presenter?.numFavChars == 0 {
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				
				self.favCharsTableView.isHidden  	 = true
				self.emptyFavoritesLbl.isHidden 	 = false
				self.emptyLogoContainerView.isHidden = false
			}
		} else {
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				
				self.favCharsTableView.isHidden  	 = false
				self.emptyFavoritesLbl.isHidden 	 = true
				self.emptyLogoContainerView.isHidden = true
			}
		}
	}
	
	
	// MARK: - Keyboard related Methods
	// Methods to Place Keyboard Under the TableView/CollectionView
	func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		favCharsTableView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
	}
	
	
	@objc func keyboardWillHide(notification: NSNotification) {
		favCharsTableView.contentInset.bottom = 0
	}
	
	
	// MARK: - Action buttons pressed
	@IBAction func resetBtnPressed(_ sender: Any) {
		resetDefaultFavoriteChars()
	}
	
	
	private func resetDefaultFavoriteChars() {
		searchFavCharSearchBar.text = ""
		resetSearchOutlet.isEnabled = false
		isSearching 				= false
		
		presenter?.resetOrCancelButtonPressed()
		
		// These lines help to hide the keyboard once the cancel button was clicked
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			   
			self.searchFavCharSearchBar.resignFirstResponder()
		}
	}
}


// MARK: - Extension. FavoriteCharsListViewProtocol
extension FavoriteCharsViewController: FavoriteCharsListViewProtocol {
	func reloadTableViewData() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			   
			self.favCharsTableView.reloadData()
			// layoutIfNeeded() is used in order to see the elements of the collection view in the last cell, otherwise, when the pagination is done, the collection view shows the requested items from the beginning (array's 1st item), and not from the array's last item (which is what is wanted)
			self.favCharsTableView.layoutIfNeeded()
		}
	}
	
	
	func startActivity() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			   
			self.activityIndicator.startAnimating()
			self.emptyFavoritesLbl.isHidden      = true
			self.favCharsTableView.isHidden      = true
			self.emptyLogoContainerView.isHidden = true
		}
	}
	
	
	func stopAndHideActivity() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			   
			self.activityIndicator.stopAnimating()
			self.activityIndicator.hidesWhenStopped = true
			
			self.favCharsTableView.isHidden = false
			// layoutIfNeeded() is needed in order to see the elements of the collection view in the last cell, otherwise, when the pagination is done, the collection view shows the requested items from the beginning (array's 1st item), and not from the array's last item (which is what is wanted)
			self.favCharsTableView.layoutIfNeeded()
		}
	}
}


// MARK: - Extension: UITableViewDataSource
extension FavoriteCharsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numFavChars ?? 0
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = presenter?.cellViewModel(at: indexPath) else { return UITableViewCell() }
		guard let favCharCell = favCharsTableView.dequeueReusableCell(withIdentifier: "favCharCell", for: indexPath) as? FavoriteCharsTableViewCell else { return UITableViewCell() }
		
		favCharCell.configure(with: viewModel)
		
		return favCharCell
	}	
}


// MARK: - UITableViewDelegate
extension FavoriteCharsViewController: UITableViewDelegate {
	// Cell is clicked
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		favCharsTableView.deselectRow(at: indexPath, animated: true)
		
		presenter?.didselectItem(at: indexPath)
	}
	
	
	// Delete character from list
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			favCharsTableView.beginUpdates()
			favCharsTableView.deleteRows(at: [indexPath], with: .fade)
			
			presenter?.deleteFavChar(at: indexPath)
			favCharsTableView.endUpdates()
		}
	}
}


// MARK: - Extension: SearchBarDelegate
extension FavoriteCharsViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		resetSearchOutlet.isEnabled = true
		isSearching = true
		
		guard let searchedFavCharName = searchBar.text else { return }
		
		// The search can only contain numbers and/or digits, otherwise it fails.
		if !searchedFavCharName.isEmpty {
			presenter?.fetchSearchedFavoriteItems(searchedName: searchedFavCharName)
		} else  {
			showMessageAlert(title: "alertControllerInvalidQueryTitle".localized,
							 message: "alertControllerInvalidQueryMsg".localized)
		}		
		
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
	}
	
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		resetDefaultFavoriteChars()
	}
}
