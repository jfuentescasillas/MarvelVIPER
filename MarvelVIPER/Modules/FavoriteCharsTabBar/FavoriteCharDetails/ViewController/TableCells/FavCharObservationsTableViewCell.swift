//
//  FavCharObservationsTableViewCell.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 10/02/23.
//

import UIKit


protocol FavCharObservationsTableViewCellProtocol {
	func configureObservationsCell(with observations: String)
}


// MARK: - Main class. FavCharObservationsTableViewCell
class FavCharObservationsTableViewCell: UITableViewCell {
	// MARK: Properties
	var parentVC: FavoriteCharDetailsTableViewControllerProtocol = FavoriteCharDetailsTableViewController()
	let presenter: FavoriteCharDetailsPresenterProtocol = FavoriteCharDetailsPresenter()
	
	// MARK: Elements in Storyboard
	@IBOutlet weak var favCharObservationsTxtView: UITextView!
	@IBOutlet weak var updateCommentOutlet: UIButton!
	
	
	// MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
				
		contentView.heightAnchor.constraint(equalToConstant: 260).isActive = true
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	
	// MARK: - Action Buttons
	@IBAction func updateCommentBtnPressed(_ sender: Any) {
		guard let comment = favCharObservationsTxtView.text else { return }
			
		presenter.saveCharBtnPressed(with: comment, usingVC: parentVC)		
	}
}


// MARK: - Extension. FavCharObservationsTableViewCellProtocol
extension FavCharObservationsTableViewCell: FavCharObservationsTableViewCellProtocol {
	func configureObservationsCell(with observations: String) {		
		favCharObservationsTxtView.text = observations
	}
}
