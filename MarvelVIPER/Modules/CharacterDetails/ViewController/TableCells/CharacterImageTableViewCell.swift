//
//  CharacterImageTableViewCell.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 16/05/22.
//

import UIKit


protocol CharacterImageTableViewCellProtocol {
	func configureImgCell(with viewModel: CharacterDetailsViewModel)
}


class CharacterImageTableViewCell: UITableViewCell {
	@IBOutlet private weak var characterImgView: UIImageView!
	

    override func awakeFromNib() {
        super.awakeFromNib()
		
		characterImgView.heightAnchor.constraint(equalToConstant: 265).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


// MARK: - Extension. Conforms to CharacterImageTableViewCellProtocol
extension CharacterImageTableViewCell: CharacterImageTableViewCellProtocol {
	public func configureImgCell(with viewModel: CharacterDetailsViewModel) {
		characterImgView.image = UIImage(systemName: "person.circle.fill")
		
		guard let characterImgURL = viewModel.characterImageURL else { return }
		
		characterImgView.downloaded(from: characterImgURL)
	}
}
