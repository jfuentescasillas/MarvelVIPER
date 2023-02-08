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


class FavoriteCharsViewController: BaseViewController<FavoriteMarvelCharsListPresenterProtocol> {
	// MARK: - Properties
	var isSearching: Bool = false
	
	
	// MARK: - Elements in Storyboard
	@IBOutlet weak var resetSearchOutlet: UIBarButtonItem!
	@IBOutlet weak var searchFavoriteChar: UISearchBar!
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
		searchFavoriteChar.placeholder  = "charsSearchBarPlaceholder".localized
		emptyFavoritesLbl.text 	        = "emptyFavoriteListTxt".localized
				
		registerNotifications()
		
		if presenter?.numFavChars == 0 {
			DispatchQueue.main.async {
				self.favCharsTableView.isHidden  	 = true
				self.emptyFavoritesLbl.isHidden 	 = false
				self.emptyLogoContainerView.isHidden = false
			}
		} else {
			DispatchQueue.main.async {
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
}


extension FavoriteCharsViewController: FavoriteCharsListViewProtocol {
	func reloadTableViewData() {
		DispatchQueue.main.async {
			self.favCharsTableView.reloadData()
			// layoutIfNeeded() is used in order to see the elements of the collection view in the last cell, otherwise, when the pagination is done, the collection view shows the requested items from the beginning (array's 1st item), and not from the array's last item (which is what is wanted)
			self.favCharsTableView.layoutIfNeeded()
		}
	}
	
	
	func startActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.startAnimating()
			self.emptyFavoritesLbl.isHidden      = true
			self.favCharsTableView.isHidden      = true
			self.emptyLogoContainerView.isHidden = true
		}
	}
	
	
	func stopAndHideActivity() {
		DispatchQueue.main.async {
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
		presenter?.numFavChars ?? 0
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
	
}
