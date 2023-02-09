//
//  MarvelCharactersListViewController.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 11/05/22.
//


import UIKit


protocol MarvelCharactersListViewProtocol {
	func startActivity()
	func stopAndHideActivity()
	func reloadCollectionViewData()
	func showNoInternetMsg()
	func showClientRequestErrorMsg()
	func showServerErrorMsg()
	func showEmptySearchResult()
	func scrollToBottom(atIndex: Int, isUsingPagination: Bool)
	func noMoreCharactersAvailable()
	func reactivateHasMoreCharacters()
}


// MARK: - Main Class. MarvelCharactersListViewController
class MarvelCharactersListViewController: BaseViewController<MarvelCharactersListPresenterProtocol> {
	// MARK: Properties
	private var hasMoreCharacters: Bool = true
	private var cellLayout: UICollectionViewFlowLayout {
		let numberOfColumns: CGFloat = 1  // For this app in particular, use the value of 1, otherwise reconfigure the cell
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 10  // Minimal space between cells
		layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 30, right: 10)  // margins of each section
		
		// width = (screen's width / number of columns in screen) - (space between cells / 2) - (the left section inset)
		let screenWidth = (marvelCharactersCollectionView.frame.width / numberOfColumns) - (layout.minimumInteritemSpacing / 2) - layout.sectionInset.left
		let screenHeight = (screenWidth/3) + (screenWidth/5) - (screenWidth/10.5)
		
//		print("Width of Screen: \(screenWidth)")
//		print("Height of Screen: \(round(screenHeight))")
		
		// Using screenWidth-5 because the console shows a message about a mismatching width (the calculated width is bigger than the phone's width), and 5 is the minimum number to make that message disappear
		layout.itemSize = CGSize(width: screenWidth-5, height: round(screenHeight))
		
		return layout
	}
	
	
	// MARK: Elements in storyboard
	@IBOutlet weak var resetSearchBtn: UIBarButtonItem!
	@IBOutlet weak var characterSearchBar: UISearchBar!
	@IBOutlet weak var marvelCharactersCollectionView: UICollectionView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var messageLbl: UILabel!  // This label will indicate when the device has no internet and when there are no results in the search bar
	@IBOutlet weak var reloadCharsBtnOutlet: UIButton!
	
	
	// MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setSearchBar()
		presenter?.fetchCharactersFromAPI()
    }
	
	
	// MARK: - LayoutSubviews
	// Writes the layout subviews programmed after didLoad
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		marvelCharactersCollectionView.setCollectionViewLayout(cellLayout, animated: false)
	}
	
	
	// MARK: - SearchBar config
	private func setSearchBar() {
		resetSearchBtn.isEnabled       = false
		resetSearchBtn.title 		   = "charsResetButtonTitle".localized
		
		characterSearchBar.delegate    = self
		characterSearchBar.placeholder = "charsSearchBarPlaceholder".localized
	}
	
	
	// MARK: - Action Buttons
	@IBAction func resetCharSearchBtnAction(_ sender: Any) {
		presenter?.resetButtonPressed()
		characterSearchBar.text = ""
		resetSearchBtn.isEnabled = false
	}
	
	
	@IBAction func reloadCharsBtnAction(_ sender: Any) {
		presenter?.fetchCharactersFromAPI()
	}
}


// MARK: - Main Class. MarvelCharactersListViewProtocol
extension MarvelCharactersListViewController: MarvelCharactersListViewProtocol {
	// Activity Indicator Controllers
	func startActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.startAnimating()
			self.messageLbl.isHidden = true
			self.reloadCharsBtnOutlet.isHidden = true
			self.marvelCharactersCollectionView.isHidden = true
		}
	}
	
	
	func stopAndHideActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.hidesWhenStopped = true
			
			self.marvelCharactersCollectionView.isHidden = false
			// layoutIfNeeded() is needed in order to see the elements of the collection view in the last cell, otherwise, when the pagination is done, the collection view shows the requested items from the beginning (array's 1st item), and not from the array's last item (which is what is wanted)
			self.marvelCharactersCollectionView.layoutIfNeeded()
		}
	}
	
	
	// Reload collectionView
	func reloadCollectionViewData() {
		DispatchQueue.main.async {
			self.marvelCharactersCollectionView.reloadData()
			// layoutIfNeeded() is used in order to see the elements of the collection view in the last cell, otherwise, when the pagination is done, the collection view shows the requested items from the beginning (array's 1st item), and not from the array's last item (which is what is wanted)
			self.marvelCharactersCollectionView.layoutIfNeeded()
		}
	}
	
	
	// Scrolls to the last element +2 in the collection view after the pagination or to the last element -1 when the "Reset" button is clicked (after making a character search).
	func scrollToBottom(atIndex: Int, isUsingPagination: Bool) {
		DispatchQueue.main.async {
			var index: IndexPath!
			
			if isUsingPagination {
				index = IndexPath(item: atIndex+1, section: 0)
			} else { // Reset button was pressed
				index = IndexPath(item: atIndex-1, section: 0)
			}
			
			self.marvelCharactersCollectionView?.scrollToItem(at: index, at: .bottom, animated: true)
			self.marvelCharactersCollectionView.isHidden = false
			
			self.activityIndicator.stopAnimating()
			self.activityIndicator.hidesWhenStopped = true
		}
	}
	
	
	// Show Message and Label when user has NO internet
	func showNoInternetMsg() {
		showElementsController()
		
		messageLbl.isHidden = false
		messageLbl.text = "noInternetMsg".localized
		
		let alertController = UIAlertController(title: "noInternetTitle".localized, message: "noInternetMsg".localized, preferredStyle: .actionSheet)
		alertController.addAction((UIAlertAction(title: "retryBtnTitle".localized, style: .default, handler: tryReload)))
		alertController.addAction(UIAlertAction(title: "cancelBtnTitle".localized, style: .cancel))
				
		self.present(alertController, animated: true, completion: nil)
	}
	
	
	// Show Message and Label when search fetches an empty result
	func showEmptySearchResult() {
		messageLbl.isHidden = false
		messageLbl.text = "emptySearchResultsLabel".localized
		
		activityIndicator.stopAnimating()
		activityIndicator.hidesWhenStopped = true
		
		marvelCharactersCollectionView.isHidden = true
	}
	
	// Show Client (user's device) request error (Error code 400-499)
	func showClientRequestErrorMsg() {
		showElementsController()
		
		messageLbl.isHidden = false
		messageLbl.text = "badRequestMsg".localized
		
		let alertController = UIAlertController(title: "alertControllerBadRequestTitle".localized,
												message: "alertControllerBadRequestMsg".localized,
												preferredStyle: .actionSheet)
		alertController.addAction((UIAlertAction(title: "retryBtnTitle".localized, style: .default, handler: tryReload)))
		alertController.addAction(UIAlertAction(title: "cancelBtnTitle".localized, style: .cancel))
				
		self.present(alertController, animated: true, completion: nil)
	}
	
	
	// Show Server response error (Error code 500-599)
	func showServerErrorMsg() {
		showElementsController()
		
		messageLbl.isHidden = false
		messageLbl.text = "badResponseMsg".localized
		
		let alertController = UIAlertController(title: "alertControllerBadResponseTitle".localized,
												message: "alertControllerBadResponseMsg".localized,
												preferredStyle: .actionSheet)
		alertController.addAction((UIAlertAction(title: "retryBtnTitle".localized, style: .default, handler: tryReload)))
		alertController.addAction(UIAlertAction(title: "cancelBtnTitle".localized, style: .cancel))
				
		self.present(alertController, animated: true, completion: nil)
	}
	
	
	// Standard behavior when an error occurs or a search is empty
	private func showElementsController() {
		activityIndicator.stopAnimating()
		activityIndicator.hidesWhenStopped = true
		
		marvelCharactersCollectionView.isHidden = true
		
		reloadCharsBtnOutlet.isHidden = false
		reloadCharsBtnOutlet.setTitle("reloadCharsButtonTitle".localized, for: .normal)
	}
	
	
	// Fetch again the characters from the beginning
	private func tryReload(action: UIAlertAction) {
		presenter?.fetchCharactersFromAPI()
	}
	
	
	// Change "hasMoreCharacters" to false to deactivate the pagination
	func noMoreCharactersAvailable() {
		DispatchQueue.main.async {
			self.hasMoreCharacters = false			
			self.stopAndHideActivity()
			self.marvelCharactersCollectionView.reloadData()
		}
	}
	
	
	func reactivateHasMoreCharacters() {
		DispatchQueue.main.async {
			self.hasMoreCharacters = true
			self.stopAndHideActivity()
			self.marvelCharactersCollectionView.reloadData()
		}
	}
}


// MARK: - Extension. CollectionView Datasource
extension MarvelCharactersListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return presenter?.numCharacters ?? 0
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let viewModel = presenter?.cellViewModel(at: indexPath),
			  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? MarvelCharacterCollectionViewCell else { return UICollectionViewCell() }
		
		cell.configure(with: viewModel)
		
		return cell
	}
}


// MARK: - Extension. CollectionViewDelegate
extension MarvelCharactersListViewController: UICollectionViewDelegate {
	// MARK: Pagination
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let offsetY 	  = scrollView.contentOffset.y     // y coordinate (up and down)
		let contentHeight = scrollView.contentSize.height  // The entire scrollview, if there are 5,000 items, it will be very tall
		let height 		  = scrollView.frame.size.height   // Screen's height
		
		if (offsetY > (contentHeight - height) && hasMoreCharacters == true) {
			presenter?.fetchNextCharacters()
		}
	}
	
	
	// MARK: Navigate to Details VC
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter?.didselectItem(at: indexPath)
	}
}


// MARK: - Extension. UISearchBarDelegate
extension MarvelCharactersListViewController: UISearchBarDelegate {
	// MARK: UISearchBarDelegate Methods
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		characterSearchBar.text = ""
				
		// These lines help to hide the keyboard once the cancel button was clicked
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
	}
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		// Can't make searches if the text is empty or if it has only one blank space
		if searchBar.text == "" || searchBar.text == " " {
			return
		}
		
		// Use of guard var instead of guard let since its value will later change
		guard var searchedChar = searchBar.text else { return }
		
		print("searchedChar: \(searchedChar)")
		
		// The search can only contain numbers and/or digits, otherwise it fails.
		if searchedChar.isAlphanumeric {
			// If the query has white spaces, it is replaced by %20, (which is the hexadecimal value for the white space used in an encoded URL)
			// Example: if the query is "alpha dog", it will be changed to "alpha%20dog", which is a valid encoded URL address for the API
			searchedChar = searchedChar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
			
			hasMoreCharacters = true
			
			presenter?.fetchSearchedItems(searchedName: searchedChar, pageSearchedOffset: 0)
		} else {
			showMessageAlert(title: "alertControllerInvalidTextInputTitle".localized,
							 message: "alertControllerInvalidTextInputMsg".localized)
		}
		
		// This lines help to hide the keyboard once the search was requested
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
	}
	
	
	// MARK: - Custom Methods related to the searchBar (not part of UISearchBarDelegate)
	// Reset button is active when a search has been made
	func enableResetButton() {
		resetSearchBtn.isEnabled = true
	}
}
