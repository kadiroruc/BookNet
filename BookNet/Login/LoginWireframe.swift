//
//  LoginWireframe.swift
//  Project
//
//  Created by Abdulkadir Oruç on 1.08.2024.
//

import UIKit

final class LoginWireframe: BaseWireframe<LoginViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = LoginViewController()
        moduleViewController.navigationController?.isNavigationBarHidden = true
        super.init(viewController: moduleViewController)

        let interactor = LoginInteractor()
        let presenter = LoginPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        interactor.presenter = presenter
        moduleViewController.presenter = presenter
    }

}

// MARK: - Extensions -

extension LoginWireframe: LoginWireframeInterface {
    
    
    func navigateToProfileScreen() {
        navigationController?.setRootWireframe(TabBarWireframe(),animated: true)
    }
    
    func navigateToSignUpScreen() {
        navigationController?.setRootWireframe(SignUpWireframe())
    }
    
}
