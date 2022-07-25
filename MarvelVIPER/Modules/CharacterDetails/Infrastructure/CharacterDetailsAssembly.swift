//
//  CharacterDetailsAssembly.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 15/05/22.
//


import UIKit


final public class CharacterDetailsAssembly {
	static func characterDetailsNavigationController(dto: CharacterIdDTO? = nil) -> BaseNavigationController {
		let navigationController = BaseNavigationController(rootViewController: characterDetailsViewController(dto: dto))
				
		return navigationController
	}


	static func characterDetailsViewController(dto: CharacterIdDTO? = nil) -> CharacterDetailsViewController {
		let vc = CharacterDetailsViewController.createFromStoryboard()	
		vc.presenter = characterDetailsPresenter(viewController: vc, dto: dto)

		return vc
	}
	
	
	static func characterDetailsPresenter(viewController: CharacterDetailsViewController, dto: CharacterIdDTO? = nil) -> CharacterDetailsPresenterProtocol {
		let presenter = CharacterDetailsPresenterImpl(viewController: viewController)
		presenter.characterID = dto?.charID
		presenter.interactor = characterDetailsInteractor()
		presenter.router = characterDetailsRouter(viewController: viewController, presenter: presenter)
		
		return presenter
	}
	
	
	static func characterDetailsInteractor() -> CharacterDetailsInteractorProtocol {
		let interactor = CharacterDetailsInteractorImpl()
		interactor.provider = CharacterDetailsProviderImpl()  // MODIFICACIÓN
		
		return interactor
	}
	
	
	static func characterDetailsRouter(viewController: CharacterDetailsViewController, presenter: CharacterDetailsPresenterProtocol) -> CharacterDetailsRouterProtocol {
		let router = CharacterDetailsRouterImpl(presenter: presenter, viewController: viewController)
		
		return router
	}
}


// MARK: - Data Transfer Object
struct CharacterIdDTO {
	var charID: Int?
}
