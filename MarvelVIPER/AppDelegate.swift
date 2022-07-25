//
//  AppDelegate.swift
//  MarvelVIPER
//
//  Created by Jorge Fuentes Casillas on 11/05/22.
//


import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var appAssembly: AppAssemblyProtocol = AppAssembly()
	

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		
		guard let window = window else { return false }
		
		appAssembly.setPrincipalViewController(in: window)
				
		return true
	}
}

