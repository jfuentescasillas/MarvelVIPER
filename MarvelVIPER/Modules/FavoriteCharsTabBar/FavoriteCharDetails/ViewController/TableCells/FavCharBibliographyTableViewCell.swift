//
//  FavCharBibliographyTableViewCell.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 10/02/23.
//

import UIKit


protocol FavCharBibliographyTableViewCellProtocol {
	func configureBibliographyCell(with bibliography: [String], indexPath: IndexPath)
}


class FavCharBibliographyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


extension FavCharBibliographyTableViewCell: FavCharBibliographyTableViewCellProtocol {
	func configureBibliographyCell(with bibliography: [String], indexPath: IndexPath) {
		textLabel?.text = bibliography[indexPath.row]
	}
}
