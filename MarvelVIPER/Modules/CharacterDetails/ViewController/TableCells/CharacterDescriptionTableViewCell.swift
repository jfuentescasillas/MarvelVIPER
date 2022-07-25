//
//  CharacterDescriptionTableViewCell.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 16/05/22.
//

import UIKit

class CharacterDescriptionTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()		
    }
	

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	public func configureDescriptionCell(with viewModel: CharacterDetailsViewModel) {
		if viewModel.characterDescription != "" {
			textLabel?.text = viewModel.characterDescription
		} else {
			textLabel?.text = kConstantKeyStrings().kNoCharDescription
		}
	}
}
