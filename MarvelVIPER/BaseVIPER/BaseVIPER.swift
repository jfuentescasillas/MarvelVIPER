//
//  BaseVIPER.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 11/05/22.
//


import UIKit


// MARK: - Base of the View.
// It will have contact with the Presenter
class BaseViewController<P>: UIViewController {
	// MARK: Properties
	var presenter: P?
	
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	
	// MARK: Memory Warning
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}


// MARK: - Base of the Presenter
// It will have contact with the View and the Router
class BasePresenter<V, R> {
	// MARK: Properties
	internal var viewController: V?
	internal var router: R?
	
	convenience init(viewController: V, router: R? = nil) {
		self.init()
		self.viewController = viewController
		self.router = router
	}
}


// MARK: - Base of the Interactor (Business Logic)
// It will have contact with the Presenter
class BaseInteractor<P> {
	// MARK: Properties
	internal var presenter: P?
	
	convenience init(presenter: P) {
		self.init()
		self.presenter = presenter
	}
}


// MARK: - Base of the Router/Wireframe
// It will have contact with the Presenter
class BaseRouter<P> {
	// MARK: Properties
	internal var presenter: P?
	internal var viewController: UIViewController?
	
	convenience init(presenter: P, viewController: UIViewController? = nil) {
		self.init()
		self.presenter = presenter
		self.viewController = viewController
	}
	
	
	internal func showVC(_ vc: UIViewController) {
		guard let navigationController = viewController?.navigationController else { return }
		
		navigationController.pushViewController(vc, animated: true)
	}
	
	
	internal func presentVC(_ vcToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
		if let navigationController = viewController?.navigationController {
			navigationController.present(vcToPresent, animated: flag, completion: completion)
		} else {
			viewController?.present(vcToPresent, animated: flag, completion: completion)
		}
	}
}


// MARK: - Base of the NavigationController
class BaseNavigationController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
	
