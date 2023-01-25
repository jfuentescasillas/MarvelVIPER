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
	// MARK: - Properties
	let placeholderImg = UIImage(systemName: "person.circle.fill")
	
	
	// MARK: - Elements in Storyboard
	@IBOutlet private weak var characterImgView: UIImageView!
	

	// MARK: - Lifecycle
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
	// Version 1. Original version and Version 2
	public func configureImgCell(with viewModel: CharacterDetailsViewModel) {
		characterImgView.image = placeholderImg
		
		guard let characterImgURL = viewModel.characterImageURL else { return }
		
		characterImgView.downloaded(from: characterImgURL)
	}
	
	
	// Version 3. Based on GHFollowers app. Works fine and does the same as Version 1
	/*public func configureImgCell(with viewModel: CharacterDetailsViewModel) {
		characterImgView.image = placeholderImg
		
		guard let characterImgURL = viewModel.characterImageURL else { return }
		
		characterImgView.downloaded(from: characterImgURL) { [weak self] img in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				self.characterImgView.image = img
			}
		}
	}*/
	
	
	// Version 3.1. Based on another version of GHFollowers app. Works fine and does the same as Version 1
	/*public func configureImgCell(with viewModel: CharacterDetailsViewModel) {
		characterImgView.image = placeholderImg
		
		guard let characterImgURL = viewModel.characterImageURL else { return }
		
		Task {
			characterImgView.image = await characterImgView.downloaded(from: characterImgURL)
		}
	}*/
}
