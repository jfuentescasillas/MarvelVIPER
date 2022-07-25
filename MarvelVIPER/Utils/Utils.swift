//
//  Utils.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 13/05/22.
//


import Foundation


// MARK: - Error Manager
enum ApiError: Error, LocalizedError {
	case unknownError, apiError(reason: String)
	
	var errorDescription: String? {
		switch self {
		case .unknownError:
			return "Unknown Error"
			
		case .apiError(let error):
			return error
		}
	}
}


// MARK: - HTTP Methods
// What type of method is executed in the call
enum HTTPMethods: String {
	case get = "GET"
	case post = "POST"
}


// MARK: - RequestDTO
struct RequestDTO {
	var params: [String: Any]?
	var arrayParams: [[String: Any]]?
	var method: HTTPMethods
	var endpoint: String
	
	init(params: [String: Any]?, method: HTTPMethods, endpoint: String) {
		self.params   = params
		self.method   = method
		self.endpoint = endpoint
	}
	
	init(arrayParams: [[String: Any]]?, method: HTTPMethods, endpoint: String) {
		self.arrayParams = arrayParams
		self.method      = method
		self.endpoint 	 = endpoint
	}
}


// See SensitiveData.swift to see the construction of a URL to get 100 MarvelCharacters
struct URLEndpoint {
	static let baseURL: String 		  = "https://gateway.marvel.com/v1/public/characters?"
	static let setCharsLimit: String  = "limit=100"
	static let setCharsOffset: String = "&offset="  // link it to the offset. Example: &offset=300
	static let setTimeStamp: String	  = "&ts=" 	  	// link it to the timestamp. Example: &ts=1
	static let setApiKey: String	  = "&apikey="  // link it to the apiKey in the SensitiveData file
	static let setHashKey: String	  = "&hash="  	// link it to the generated hashKey
}


// See SensitiveData.swift to see the construction of a URL to get a Marvel Character details
struct CharacterDetailsURLEndpoint {
	static let baseURL: String 		  = "https://gateway.marvel.com/v1/public/characters/"  // Link it to the Char's ID
	static let setApiKey: String	  = "?apikey="  // link it to the apiKey in the SensitiveData file
	static let setTimeStamp: String	  = "&ts=" 	  	// link it to the timestamp. Example: &ts=1
	static let setHashKey: String	  = "&hash="  	// link it to the generated hashKey
}


// https://gateway.marvel.com/v1/public/characters/1010853?apikey=b5a004aac50e22dbccea83b58947bf97&ts=1&hash=cf8530437ab0e239d120f70010f33a34
