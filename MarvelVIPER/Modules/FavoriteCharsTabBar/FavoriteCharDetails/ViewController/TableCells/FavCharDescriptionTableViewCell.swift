//
//  FavCharDescriptionTableViewCell.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 10/02/23.
//


import UIKit


protocol FavCharDescriptionTableViewCellProtocol {
	func configureDescriptionCell(with viewModel: FavoriteCharacter)
}


class FavCharDescriptionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


extension FavCharDescriptionTableViewCell: FavCharDescriptionTableViewCellProtocol {
	func configureDescriptionCell(with viewModel: FavoriteCharacter) {
		textLabel?.text = viewModel.favCharDescription		
	}
	
	
}
