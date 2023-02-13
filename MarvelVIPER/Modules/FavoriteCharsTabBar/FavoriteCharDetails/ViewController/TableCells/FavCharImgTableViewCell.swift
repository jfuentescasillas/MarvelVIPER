//
//  FavCharImgTableViewCell.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 10/02/23.
//


import UIKit


struct FavCharImgTableViewCellViewModel {
	let favCharImgView: UIImageView?
}


protocol FavCharImgTableViewCellProtocol {
	func configureImgCell(with viewModel: FavoriteCharacter)
}


class FavCharImgTableViewCell: UITableViewCell {
	@IBOutlet weak var favCharDetailsImgView: UIImageView!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
		favCharDetailsImgView.heightAnchor.constraint(equalToConstant: 235).isActive = true
    }

	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension FavCharImgTableViewCell: FavCharImgTableViewCellProtocol {
	func configureImgCell(with viewModel: FavoriteCharacter) {
		guard let favCharImgData = viewModel.favCharImg else { return }
		
		favCharDetailsImgView.image = UIImage(data: favCharImgData)
	}
}
