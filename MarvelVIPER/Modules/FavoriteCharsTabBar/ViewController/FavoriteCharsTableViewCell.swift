//
//  FavoriteCharsTableViewCell.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 04/02/23.
//

import UIKit


struct FavoriteCharTableViewCellViewModel {
	let favCharImgView: UIImageView?
	let characterName: String?
}


class FavoriteCharsTableViewCell: UITableViewCell {
	// MARK: - Elements from Storyboard	
	@IBOutlet weak var favCharImg: UIImageView!
	@IBOutlet weak var FavCharNameLbl: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	// MARK: - Configuration
	func configure(with viewModel: FavoriteCharacter) {
		FavCharNameLbl.text = viewModel.favCharName

		guard let favCharImgData = viewModel.favCharImg else { return }
		
		favCharImg.image = UIImage(data: favCharImgData)
	}
}
