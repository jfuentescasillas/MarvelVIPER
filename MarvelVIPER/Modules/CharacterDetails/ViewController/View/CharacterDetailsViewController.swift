//
//  CharacterDetailsViewController.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 15/05/22.
//

import UIKit


// MARK: - CharacterDetailsViewModel
struct CharacterDetailsViewModel {
	var characterID: Int
	var characterName: String?
	var characterImageURL: String?
	var characterDescription: String?
	var characterComics: [MarvelItems]?
	var characterSeries: [MarvelItems]?
	var characterStories: [MarvelItems]?
	var characterEvents: [MarvelItems]?
}


// MARK: - CharacterDetailsTableViewProtocol
protocol CharacterDetailsTableViewProtocol {
	func startActivity()
	func stopAndHideActivity()
	func reloadTableView()
	
	// Success/fail message of a character saved in the favorite list
	func showCharacterSavedSuccessfullyMsg()
	func showCharacterCannotBeSavedMsg()
}


// MARK: - CharacterDetailsViewController
class CharacterDetailsViewController: BaseViewController<CharacterDetailsPresenterProtocol> {
	// MARK: Properties
	let constantStrings = kConstantKeyStrings()
	private var detailsToSaveInFavoriteViewModel: CharacterDetailsViewModel?
		
	// MARK: Elements in Storyboard
	@IBOutlet weak var addToFavoritesBtnOutlet: UIBarButtonItem!
	@IBOutlet weak var characterDetailsTableView: UITableView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
	// MARK: - Life cycle
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		presenter?.fetchCharacterDetailsFromAPI()
    }
	
	
	// MARK: - Save Char to Favorites
	// Action Buttons
	@IBAction func addToFavoritesActionBtn(_ sender: Any) {
		guard let detailsToSaveInFavoriteViewModel = detailsToSaveInFavoriteViewModel,
			  let isCharInDB = presenter?.isCharInDatabase(with: detailsToSaveInFavoriteViewModel)
		else { return }
		
		if isCharInDB {
			showCharacterCannotBeSavedMsg()
		} else {
			present(alertAddFavCharView, animated: true, completion: nil)
		}
	}
		
	//  Create Alert Controller Object here
	private	lazy var alertAddFavCharView: UIAlertController = {
		let alert = UIAlertController(title: "alertContrWriteCommentTitle".localized,
									  message: "alertContrWriteCommentMsg".localized,
									  preferredStyle: UIAlertController.Style.alert)
		
		// ADD TEXT FIELD (YOU CAN ADD MULTIPLE TEXTFILED AS WELL)
		alert.addTextField { (textField: UITextField!) in
			textField.placeholder = "saveCommentTxtFieldPlaceholder".localized
			textField.delegate = self
		}
		
		// SAVE BUTTON
		let save = UIAlertAction(title: "saveBtnTitle".localized,
								 style: UIAlertAction.Style.default,
								 handler: { saveAction -> Void in
			let textField: UITextField = alert.textFields![0]

			guard let detailsToSaveInFavoriteViewModel = self.detailsToSaveInFavoriteViewModel else { return }
			
			self.addToFavoritesBtnOutlet.isEnabled = false
			self.presenter?.saveCharBtnPressed(viewModel: detailsToSaveInFavoriteViewModel,
											   withUserComment: textField.text ?? "")
		})
		
		// CANCEL BUTTON
		let cancel = UIAlertAction(title: "cancelBtnTitle".localized,
								   style: UIAlertAction.Style.default,
								   handler: { (action : UIAlertAction!) -> Void in })
		
		alert.addAction(save)
		alert.addAction(cancel)
		
		return alert
	}()
}


// MARK: - Extension. TableViewDataSource
extension CharacterDetailsViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return constantStrings.kCharDetailsSectionTitles.count
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {		
		return presenter?.numberOfItemsInSection(inSection: section) ?? 0
	}
	
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0, 1:
			return ""
			
		default:
			return constantStrings.kCharDetailsSectionTitles[section]
		}
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = presenter?.cellViewModel(at: indexPath) else { return UITableViewCell() }
		guard let cell = characterDetailsTableView.dequeueReusableCell(withIdentifier: "characterBibliographyCell", for: indexPath) as? CharacterBibliographyTableViewCell else { return UITableViewCell() }
		
		// Load detailsToSaveInFavoriteViewModel with the retrieved viewModel
		detailsToSaveInFavoriteViewModel = viewModel
		
		let viewModelSection = indexPath.section
		
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
			
			cell.configureBibliographyCell(with: comics, indexPath: indexPath)
						
			return cell
			
		case 3:  // Character's Series Section
			guard let series = viewModel.characterSeries  else { return UITableViewCell() }
									
			cell.configureBibliographyCell(with: series, indexPath: indexPath)
						
			return cell
			
		case 4:  // Character's Stories Section
			guard let stories = viewModel.characterStories  else { return UITableViewCell() }
									
			cell.configureBibliographyCell(with: stories, indexPath: indexPath)
						
			return cell
			
		case 5:  // Character's Events Section
			guard let events = viewModel.characterEvents  else { return UITableViewCell() }
									
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
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	// Customize header in each section
	/*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		let label = UILabel()
		
		switch section {
		case 0, 1:
			// Again, the label's color for section 0 is "clear"
			label.backgroundColor = .clear
			view.addSubview(label)
			
		default:
			//label.text = constantStrings.kCharDetailsSectionTitles[section]
			label.backgroundColor = UIColor.lightGray
			label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
			view.addSubview(label)
		}
		
		return view
	}*/
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
	
	
	// MARK: - Show Messages of Character Saved (or not) in the data base
	func showCharacterSavedSuccessfullyMsg() {
		showMessageAlert(title: "characterSavedSuccessfullyTitle".localized,
						 message: "characterSavedSuccessfullyMsg".localized)
		
		// Re-enable the "save in favorites" button once the showMessageAlert window prompts
		addToFavoritesBtnOutlet.isEnabled = true
	}
	
	
	func showCharacterCannotBeSavedMsg() {
		showMessageAlert(title: "characterCannotBeSavedTitle".localized,
						 message: "characterCannotBeSavedMsg".localized)
		
		// Re-enable the "save in favorites" button once the showMessageAlert window prompts
		addToFavoritesBtnOutlet.isEnabled = true
	}
}


// MARK: - Extension. UITextFieldDelegate
extension CharacterDetailsViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
	
		return true
	}
}
