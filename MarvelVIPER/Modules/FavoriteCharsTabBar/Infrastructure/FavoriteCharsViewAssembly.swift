//
//  FavoriteCharsViewAssembly.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 26/01/23.
//


import UIKit


final public class FavoriteCharsViewAssembly {
	static func favoriteCharsViewNavigationController() -> BaseNavigationController {
		let navigationController = BaseNavigationController(rootViewController: favoriteCharsViewController())
				
		return navigationController
	}
	
	
	static func favoriteCharsViewController() -> FavoriteCharsViewController {
		let vc = FavoriteCharsViewController.createFromStoryboard()
		vc.title = "favoriteCharactersVCTitle".localized
		vc.presenter = favoriteCharsPresenter(viewController: vc)
		
		return vc
	}
	
	
	static func favoriteCharsPresenter(viewController: FavoriteCharsViewController) -> FavoriteMarvelCharsListPresenterProtocol {
		let presenter = FavoriteMarvelCharactersListPresenter(viewController: viewController)
		presenter.router = favoriteCharsRouter(viewController: viewController, presenter: presenter)
		presenter.interactor = favoriteCharsInteractor()
				
		return presenter
	}
	
	
	static func favoriteCharsRouter(viewController: FavoriteCharsViewController, presenter: FavoriteMarvelCharactersListPresenter) -> FavoriteCharsListRouterProtocol {
		let router = FavoriteCharsListRouter(presenter: presenter, viewController: viewController)
		
		return router
	}
	
	
	static func favoriteCharsInteractor() -> FavoriteMarvelCharactersListInteractorProtocol {
		let interactor = FavoriteMarvelCharactersListInteractor()
		
		return interactor
	}
}
