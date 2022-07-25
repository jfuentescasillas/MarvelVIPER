//
//  CharacterBibliographyTableViewCell.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 16/05/22.
//

import UIKit

class CharacterBibliographyTableViewCell: UITableViewCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		textLabel?.numberOfLines = 0
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	
	public func configureBibliographyCell(with bibliography: [MarvelItems], indexPath: IndexPath) {
		if bibliography.count > 0 {			
			textLabel?.text = bibliography[indexPath.row].name
		} else {
			switch indexPath.section {
			case 2:
				textLabel?.text = kConstantKeyStrings().kNoCharComics
				
			case 3:
				textLabel?.text = kConstantKeyStrings().kNoCharSeries
			
			case 4:
				textLabel?.text = kConstantKeyStrings().kNoCharStories
				
			default:
				textLabel?.text = kConstantKeyStrings().kNoCharEvents
			}			
		}
	}
}
