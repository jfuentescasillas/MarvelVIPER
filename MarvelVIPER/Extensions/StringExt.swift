//
//  StringExt.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 31/07/22.
//


import Foundation


// Mark: - Extension. Check for alphanumerical characters
extension String {
	/// Allows only `a-zA-Z0-9 `
	public var isAlphanumeric: Bool {
		guard !isEmpty else { return false }
		
		let allowed = "-abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ1234567890()'. "
		let characterSet = CharacterSet(charactersIn: allowed)
		
		guard rangeOfCharacter(from: characterSet.inverted) == nil else { return false }
		
		return true
	}
	
	
	// Used in LocalizedKeys
	public var localized: String {
		return NSLocalizedString(self, comment: "")
	}
}
