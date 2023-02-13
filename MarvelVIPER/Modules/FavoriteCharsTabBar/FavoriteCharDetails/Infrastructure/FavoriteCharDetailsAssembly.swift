//
//  FavoriteCharDetailsAssembly.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 09/02/23.
//


import UIKit


final public class FavoriteCharDetailsAssembly {
	static func favoriteCharDetailsNavigationController(withFavoriteCharacter: FavoriteCharacter? = nil) -> BaseNavigationController {
		let navigationController = BaseNavigationController(rootViewController: favoriteCharDetailsViewController(withFavoriteCharacter: withFavoriteCharacter))
				
		return navigationController
	}


	static func favoriteCharDetailsViewController(withFavoriteCharacter: FavoriteCharacter? = nil) -> FavoriteCharDetailsTableViewController {
		let vc = FavoriteCharDetailsTableViewController.createFromStoryboard()
		vc.presenter = favoriteCharDetailsPresenter(viewController: vc, withFavoriteChar: withFavoriteCharacter)

		return vc
	}
	
	
	static func favoriteCharDetailsPresenter(viewController: FavoriteCharDetailsTableViewController, withFavoriteChar: FavoriteCharacter? = nil) -> FavoriteCharDetailsPresenterProtocol {
		let presenter = FavoriteCharDetailsPresenter(viewController: viewController)
		presenter.favoriteCharDetails = withFavoriteChar
		presenter.interactor = favoriteCharDetailsInteractor()
		presenter.router = favoriteCharDetailsRouter(viewController: viewController, presenter: presenter)
		
		return presenter
	}
	
	
	static func favoriteCharDetailsInteractor() -> FavoriteCharDetailsInteractorProtocol {
		let interactor = FavoriteCharDetailsInteractor()
		interactor.provider = FavoriteCharDetailsProvider()  // MODIFICACIÓN
		
		return interactor
	}
	
	
	static func favoriteCharDetailsRouter(viewController: FavoriteCharDetailsTableViewController, presenter: FavoriteCharDetailsPresenterProtocol) -> FavoriteCharDetailsRouterProtocol {
		let router = FavoriteCharDetailsRouter(presenter: presenter, viewController: viewController)
		
		return router
	}
}
