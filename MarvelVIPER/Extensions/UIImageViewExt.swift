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
	func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
		contentMode = mode
		imageUrlString = "\(url)"
		//image = avatarPlaceholder
		
		if let imageFromCache = imageCache.object(forKey: "\(url)" as NSString) {
			self.image = imageFromCache
			
			return
		}
		
		let imageTask = URLSession.shared.dataTask(with: url) { data, response, error in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)  // This is when the image is loaded for the 1st time
				else { return }
			
			DispatchQueue.main.async() { [weak self] in
				guard let imageToCache = UIImage(data: data) else { return }
				
				if imageUrlString == "\(url)" {
					self?.image = imageToCache
				}
								
				self?.image = image // Loading image for the 1st time
				imageCache.setObject(imageToCache, forKey: "\(url)" as NSString) // Image is stored in cache and this will help to prevent the "reuse" of cells, which will help to avoid to show an incorrect image for a determined item.
			}
		}
		
		imageTask.resume()
	}
	
	
	/*func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
		guard let url = URL(string: link) else { return }
		
		downloaded(from: url, contentMode: mode)
	}*/
}

