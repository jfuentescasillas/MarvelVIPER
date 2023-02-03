//
//  FavoriteCharsViewController.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 26/01/23.
//

import UIKit

class FavoriteCharsViewController: UIViewController {
	// MARK: - Properties
	
	
	// MARK: - Elements in Storyboard
	@IBOutlet weak var favCharsTableView: UITableView!
	@IBOutlet weak var emptyFavoritesLbl: UILabel!
	@IBOutlet weak var emptyLogoContainerView: UIView!
	
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		favCharsTableView.isHidden = true
		
	}
}


// MARK: - Extension: UITableViewDataSource
extension FavoriteCharsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		UITableViewCell()
	}	
}


// MARK: - UITableViewDelegate
extension FavoriteCharsViewController: UITableViewDelegate {
	
}
