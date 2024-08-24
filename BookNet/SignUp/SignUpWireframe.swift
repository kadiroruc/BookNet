//
//  SignUpWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 30.07.2024.
//

import UIKit

final class SignUpWireframe: BaseWireframe<SignUpViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = SignUpViewController()
        super.init(viewController: moduleViewController)

        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        interactor.presenter = presenter
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension SignUpWireframe: SignUpWireframeInterface {
    
    func navigateToProfileScreen() {
        //navigationController?.setRootWireframe(TabBarWireframe(),animated: true)
        
        let initialViewController = UINavigationController()
        initialViewController.setRootWireframe(TabBarWireframe())
        
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = initialViewController // Veya sadece newRootViewController
            window.makeKeyAndVisible()
            
        }
    }
    
    func navigateToLoginScreen() {
        navigationController?.setRootWireframe(LoginWireframe())
    }
    
}
