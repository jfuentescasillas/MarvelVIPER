//
//  UIImageViewExt.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 14/05/22.
//


import UIKit


// MARK: - Extension. Download image
/// Change the AvatarPlaceholder according to the desired avatar to use (located in the Assets folder).
/// In case that the avatarPlaceHolder is wanted to be configured from this extension, then uncomment the next lines of code (change placeholder name (for instance: "beerPlaceholder-60x60") if needed):
///
/// fileprivate let avatarPlaceholder = UIImage(named: "beerPlaceholder-60x60")
///
/// and
///
/// image = avatarPlaceholder
fileprivate var imageUrlString: String?
fileprivate let imageCache = NSCache<NSString, UIImage>()
//fileprivate let avatarPlaceholder = UIImage(named: "beerPlaceholder-60x60")


extension UIImageView {
	// Version 1. Original code
	func downloaded(from url: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
		imageUrlString = url
		//image = avatarPlaceholder
		
		if let imageFromCache = imageCache.object(forKey: "\(url)" as NSString) {
			self.image = imageFromCache
			
			return
		}
		
		let imageTask = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)  // This is when the image is loaded for the 1st time
			else { return }
			
			DispatchQueue.main.async() { [weak self] in
				guard let self = self,
					  let imageToCache = UIImage(data: data)
				else { return }
				
				self.image = image // Loading image for the 1st time
				
				imageCache.setObject(imageToCache, forKey: "\(url)" as NSString) // Image is stored in cache and this will help to prevent the "reuse" of cells, which will help to avoid to show an incorrect image for a determined item.
			}
		}
		
		imageTask.resume()
	}
	
	
	// Version 2. Youtube code https://www.youtube.com/watch?v=6smmGjep75s. Works fine and does the same as Version 1.
	/*func downloaded(from url: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
		if let image = imageCache.object(forKey: url as NSString) {
			self.image = image
			
			return
		}
		
		guard let stringToURL = URL(string: url) else { return }
		
		contentMode = mode
		
		DispatchQueue.global().async { [weak self] in
			guard let self = self else { return }
			
			if let data = try? Data(contentsOf: stringToURL) {
				if let image = UIImage(data: data) {
					DispatchQueue.main.async {
						imageCache.setObject(image, forKey: url as NSString)
						self.image = image
					}
				}
			}
		}
	}*/
	
	
	// Version 3. Based on GHFollowers app
	/*func downloaded(from url: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, completed: @escaping(UIImage?) -> Void) {
		let cacheKey = NSString(string: url)
		
		// Store downloaded image in cache
		if let image = imageCache.object(forKey: cacheKey) {
			completed(image)
			
			return
		}
		
		guard let stringToURL = URL(string: url) else {
			completed(nil)
			
			return
		}
		
		let task = URLSession.shared.dataTask(with: stringToURL) { [weak self] data, response, error in
			guard self != nil, error == nil,
				  let response = response as? HTTPURLResponse, response.statusCode == 200,
				  let data = data,
				  let image = UIImage(data: data) else {
				completed(nil)
				
				return
			}
			
			imageCache.setObject(image, forKey: cacheKey)
			
			completed(image)
		}
		
		task.resume()
	}*/
		
	
	// Version 3.1. Based on another version of GHFollowers app. Works fine and does the same as Version 1 and 2.
	/*func downloaded(from url: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) async -> UIImage? {
		let cacheKey = NSString(string: url)
		contentMode = mode
				
		if let image = imageCache.object(forKey: cacheKey) {
			return image
		}
		
		guard let stringToURL = URL(string: url) else { return nil }
		
		do {
			let (data, _) = try await URLSession.shared.data(from: stringToURL)
			
			guard let image = UIImage(data: data) else { return nil }
			
			// Store downloaded image in cache
			imageCache.setObject(image, forKey: cacheKey)
			
			return image
		} catch {
			return nil
		}
	}*/
}

