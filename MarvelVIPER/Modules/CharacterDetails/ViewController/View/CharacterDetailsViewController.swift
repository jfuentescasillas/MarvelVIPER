//
//  CharacterDetailsViewController.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 15/05/22.
//

import UIKit


// MARK: - CharacterDetailsViewModel
struct CharacterDetailsViewModel {
	let characterName: String?
	let characterImageURL: URL?
	let characterDescription: String?
	let characterComics: [MarvelItems]?
	let characterSeries: [MarvelItems]?
	let characterStories: [MarvelItems]?
	let characterEvents: [MarvelItems]?
}


// MARK: - CharacterDetailsTableViewProtocol
protocol CharacterDetailsTableViewProtocol {
	func startActivity()
	func stopAndHideActivity()
	func reloadTableView()
}


// MARK: - CharacterDetailsViewController
class CharacterDetailsViewController: BaseViewController<CharacterDetailsPresenterProtocol> {
	// MARK: Properties
	let constantStrings = kConstantKeyStrings()
		
	// MARK: Elements in Storyboard
	@IBOutlet weak var characterDetailsTableView: UITableView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
	// MARK: - Life cycle
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		presenter?.fetchCharacterDetailsFromAPI()
    }
}


// MARK: - Extension. TableViewDataSource
extension CharacterDetailsViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return constantStrings.kCharDetailsSectionTitles.count
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {		
		return presenter?.numberOfItemsInSection(inSection: section) ?? 0
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = presenter?.cellViewModel(at: indexPath) else { fatalError("No ViewModel detected in cellForRowAt of CharacterDetailsViewController") }
		guard let cell = characterDetailsTableView.dequeueReusableCell(withIdentifier: "characterBibliographyCell", for: indexPath) as? CharacterBibliographyTableViewCell else { return UITableViewCell() }
		
		let viewModelSection = indexPath.section
		//print("viewModelSection: \(viewModelSection)")
		
		switch viewModelSection {
		case 0:  // Character's Image Section
			guard let cell = characterDetailsTableView.dequeueReusableCell(withIdentifier: "characterImageCell", for: indexPath) as? CharacterImageTableViewCell else { return UITableViewCell() }
			
			cell.configureImgCell(with: viewModel)
			
			return cell
			
		case 1:  // Character's Description Section
			guard let cell = characterDetailsTableView.dequeueReusableCell(withIdentifier: "characterDescriptionCell", for: indexPath) as? CharacterDescriptionTableViewCell else { return UITableViewCell() }
			
			cell.configureDescriptionCell(with: viewModel)
			
			return cell
			
		case 2:  // Character's Comics Section
			guard let comics = viewModel.characterComics else { return UITableViewCell() }
			
			if comics.isEmpty {
				cell.textLabel?.text = kConstantKeyStrings().kNoCharComics
			} else {
				cell.textLabel?.text = comics[indexPath.row].name
			}
			
			cell.configureBibliographyCell(with: comics, indexPath: indexPath)
						
			return cell
			
		case 3:  // Character's Series Section
			guard let series = viewModel.characterSeries  else { return UITableViewCell() }
									
			if series.isEmpty {
				cell.textLabel?.text = kConstantKeyStrings().kNoCharSeries
			} else {
				cell.textLabel?.text = series[indexPath.row].name
			}
			
			cell.configureBibliographyCell(with: series, indexPath: indexPath)
						
			return cell
			
		case 4:  // Character's Stories Section
			guard let stories = viewModel.characterStories  else { return UITableViewCell() }
									
			if stories.isEmpty {
				cell.textLabel?.text = kConstantKeyStrings().kNoCharStories
			} else {
				cell.textLabel?.text = stories[indexPath.row].name
			}
			
			cell.configureBibliographyCell(with: stories, indexPath: indexPath)
						
			return cell
			
		case 5:  // Character's Events Section
			guard let events = viewModel.characterEvents  else { return UITableViewCell() }
									
			if events.isEmpty {
				cell.textLabel?.text = kConstantKeyStrings().kNoCharStories
			} else {
				cell.textLabel?.text = events[indexPath.row].name
			}
			
			cell.configureBibliographyCell(with: events, indexPath: indexPath)
						
			return cell
			
		default:
			return UITableViewCell()
		}
	}
}


// MARK: - Extension. TableViewDelegate
extension CharacterDetailsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		// For section 0 and 1 (where the character's's image and character's description are located), is used a height of 0.1 points. The other sections (which have names) have a height of 30.
		return (section == 0 || section == 1) ? 0.01 : 30
	}
	
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		let label = UILabel()
		
		switch section {
		case 0, 1:
			// Again, the label's color for section 0 is "clear"
			label.backgroundColor = .clear
			view.addSubview(label)
			
		default:
			label.text = constantStrings.kCharDetailsSectionTitles[section]
			label.backgroundColor = UIColor.lightGray
			label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
			view.addSubview(label)
		}
		
		return view
	}
}


// MARK: - Extension. CharacterDetailsTableViewProtocol
extension CharacterDetailsViewController: CharacterDetailsTableViewProtocol {
	// MARK: Activity Indicator Controllers
	func startActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.startAnimating()
			self.characterDetailsTableView.isHidden = true
		}
	}
	
	
	func stopAndHideActivity() {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.hidesWhenStopped = true
			
			self.characterDetailsTableView.isHidden = false
			// layoutIfNeeded() is needed in order to see the elements of the collection view in the last cell, otherwise, when the pagination is done, the collection view shows the requested items from the beginning (array's 1st item), and not from the array's last item (which is what is wanted)
			self.characterDetailsTableView.layoutIfNeeded()
		}
	}
	
	
	// MARK: Reload tableView
	func reloadTableView() {
		characterDetailsTableView.reloadData()
	}
}
