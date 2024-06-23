//
//  LoginRouter.swift
//  Project
//
//  Created by Abdulkadir Oruç on 23.06.2024.
//

import UIKit

class LoginRouter: LoginRouterProtocol {
    static func createLoginModule() -> UIViewController {
        let view = LoginView()
        let presenter: LoginPresenterProtocol & LoginInteractorOutputProtocol = LoginPresenter()
        let interactor: LoginInteractorInputProtocol = LoginInteractor()
        let router: LoginRouterProtocol = LoginRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }

    func navigateToProfileScreen(from view: LoginViewProtocol,with uid: String) {
        let profileViewController = ProfileRouter.createProfileModule(with: uid)
   
        if let sourceView = view as? UIViewController {
            sourceView.dismiss(animated: true)
           
        }
    }
    
    func navigateToSignUpScreen(from view: LoginViewProtocol) {
        let signUpViewController = SignUpRouter.createSignUpModule()
   
        if let sourceView = view as? UIViewController {
           sourceView.navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
    
}

