//
//  MarvelCollectionAssembly.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 11/05/22.
//


import UIKit


final public class MarvelCollectionAssembly {
	static func marvelCharactersNavigationController() -> BaseNavigationController {
		let navigationController = BaseNavigationController(rootViewController: marvelCharactersViewController())
				
		return navigationController
	}


	static func marvelCharactersViewController() -> MarvelCharactersListViewController {
		let vc = MarvelCharactersListViewController.createFromStoryboard()
		vc.title = "marvelCharactersVCTitle".localized
		vc.presenter = marvelCharactersPresenter(viewController: vc)
		
		return vc
	}
	
	
	static func marvelCharactersPresenter(viewController: MarvelCharactersListViewController) -> MarvelCharactersListPresenterProtocol {
		let presenter = MarvelCharactersListPresenterImpl(viewController: viewController)
		presenter.router = marvelCharactersRouter(viewController: viewController, presenter: presenter)
		presenter.interactor = marvelCharactersInteractor()
				
		return presenter
	}
	
	
	static func marvelCharactersInteractor() -> MarvelCharactersListInteractorProtocol {
		let interactor = MarvelCharactersListInteractorImpl()
		
		return interactor
	}
	
	
	static func marvelCharactersRouter(viewController: MarvelCharactersListViewController, presenter: MarvelCharactersListPresenterProtocol) -> MarvelCharactersListRouterProtocol {
		let router = MarvelCharactersListRouterImpl(presenter: presenter, viewController: viewController)
		
		return router
	}
}
