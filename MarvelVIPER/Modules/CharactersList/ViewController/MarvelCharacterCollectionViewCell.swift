//
//  MarvelCharacterCollectionViewCell.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 14/05/22.
//


import UIKit


struct CharacterCollectionViewCellViewModel {
	let characterImageURL: String?
	let characterName: String?
	let characterDescription: String?
}



class MarvelCharacterCollectionViewCell: UICollectionViewCell {
	// MARK: - Properties
	let placeholderImg = UIImage(systemName: "person.circle.fill")
	
	// MARK: - Elements in Cell
	@IBOutlet weak var characterImageView: UIImageView!
	@IBOutlet weak var characterNameLbl: UILabel!
	@IBOutlet weak var characterDescriptionLbl: UILabel!
	
	
	func configure(with viewModel: CharacterCollectionViewCellViewModel) {
		// In case that the placeholder is wanted to be configured from the UIImageViewExt file, comment this line of code (beerImage.image = UIImage(named: "beerPlaceholder-60x60")) and uncomment the lines in the extension file (UIImageViewExt)
		// Placeholder image
		characterImageView.image = placeholderImg
		
		guard let characterImgURL = viewModel.characterImageURL else { return }
		
		// Version 1. Original code and Version 2
		characterImageView.downloaded(from: characterImgURL)
				
		// Version 3
		/*characterImageView.downloaded(from: characterImgURL) { [weak self] img in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				self.characterImageView.image = img
			}
		}*/
		
		// Version 3.1
		/*Task {
			characterImageView.image = await characterImageView.downloaded(from: characterImgURL)
		}*/
		
		characterNameLbl.text = viewModel.characterName
		
		if viewModel.characterDescription != "" {
			characterDescriptionLbl.text = viewModel.characterDescription
		} else {
			characterDescriptionLbl.text = "No Description Available"
		}
		
		contentView.layer.cornerRadius = 10
		contentView.layer.masksToBounds = true
		
		layer.shadowColor = UIColor.gray.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 2)
		layer.shadowRadius = 2
		layer.shadowOpacity = 1
		layer.masksToBounds = false
		layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
	}
}
