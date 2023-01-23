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
	// MARK: - Elements in Cell
	@IBOutlet weak var characterImageView: UIImageView!
	@IBOutlet weak var characterNameLbl: UILabel!
	@IBOutlet weak var characterDescriptionLbl: UILabel!
	
	
	func configure(with viewModel: CharacterCollectionViewCellViewModel) {
		// In case that the placeholder is wanted to be configured from the UIImageViewExt file, comment this line of code (beerImage.image = UIImage(named: "beerPlaceholder-60x60")) and uncomment the lines in the extension file (UIImageViewExt)
		// Placeholder image
		characterImageView.image = UIImage(systemName: "person.circle.fill") //(named: "beerCollectionImagePlaceholder")
		
		guard let characterImgURL = viewModel.characterImageURL else { return }
		
		characterImageView.downloaded(from: URL(string: characterImgURL)!)
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
