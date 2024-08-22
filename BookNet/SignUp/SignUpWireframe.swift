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
    
    func navigateToProfileScreen(with uid: String) {
        navigationController?.setRootWireframe(TabBarWireframe(),animated: true)
    }
    
    func navigateToLoginScreen() {
        navigationController?.setRootWireframe(LoginWireframe())
    }
    
}
