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
}


class MarvelCharactersListViewController: BaseViewController<MarvelCharactersListPresenterProtocol> {
	// MARK: Properties
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
	@IBOutlet weak var marvelCharactersCollectionView: UICollectionView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
	// MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		presenter?.fetchCharactersFromAPI()
    }
	
	
	// MARK: - LayoutSubviews
	// Writes the layout subviews programmed after didLoad
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		marvelCharactersCollectionView.setCollectionViewLayout(cellLayout, animated: false)
	}
}


extension MarvelCharactersListViewController: MarvelCharactersListViewProtocol {
	// Activity Indicator Controllers
	func startActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.startAnimating()
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
}



// MARK: - Extension. CollectionView Datasource
extension MarvelCharactersListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return presenter?.numCharacters ?? 0
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let viewModel = presenter?.cellViewModel(at: indexPath),
			  let cell = marvelCharactersCollectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? MarvelCharacterCollectionViewCell else { return UICollectionViewCell() }
		
		cell.configure(with: viewModel)
		
		return cell
	}
}


// MARK: - Extension. CollectionView Delegate
extension MarvelCharactersListViewController: UICollectionViewDelegate {
	// MARK: - Pagination
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let offsetY 		= scrollView.contentOffset.y     // y coordinate (up and down)
		let contentHeight 	= scrollView.contentSize.height  // The entire scrollview, if there are 5,000 items, it will be very tall
		let height 			= scrollView.frame.size.height   // Screen's height
		
		if (offsetY > (contentHeight - height)) {
			presenter?.fetchNextCharacters()
		}
	}
	
	
	// MARK: - Navigate to Details VC
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter?.didselectItem(at: indexPath)
	}
}
